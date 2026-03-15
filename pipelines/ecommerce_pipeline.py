import os
import time
import httpx
from typing import Optional

from dotenv import load_dotenv
from prefect import flow, task, get_run_logger
from prefect_dbt.cli.commands import DbtCoreOperation

# cargar variables
load_dotenv()

AIRBYTE_HOST = os.getenv("AIRBYTE_HOST", "localhost")
AIRBYTE_PORT = os.getenv("AIRBYTE_PORT", "8000")
AIRBYTE_CONNECTION_ID = os.getenv("AIRBYTE_CONNECTION_ID")
AIRBYTE_USERNAME = os.getenv("AIRBYTE_USERNAME")
AIRBYTE_PASSWORD = os.getenv("AIRBYTE_PASSWORD")

DBT_PROJECT_DIR = "."
DBT_PROFILES_DIR = os.path.expanduser("~/.dbt")


@task(name="Extract and Load", retries=2, retry_delay_seconds=60)
def extract_and_load():

    logger = get_run_logger()

    base_url = f"http://{AIRBYTE_HOST}:{AIRBYTE_PORT}/api/v1"

    with httpx.Client(timeout=30, auth=(AIRBYTE_USERNAME, AIRBYTE_PASSWORD)) as client:

        logger.info("Triggering Airbyte sync")

        response = client.post(
            f"{base_url}/connections/sync",
            json={"connectionId": AIRBYTE_CONNECTION_ID}
        )

        response.raise_for_status()

        job_id = response.json()["job"]["id"]

        logger.info(f"Airbyte job started: {job_id}")

        while True:

            status_resp = client.post(
                f"{base_url}/jobs/get",
                json={"id": job_id}
            )

            status = status_resp.json()["job"]["status"]

            logger.info(f"Airbyte status: {status}")

            if status == "succeeded":
                logger.info("Airbyte sync completed")
                return job_id

            if status in ("failed", "cancelled"):
                raise RuntimeError(f"Airbyte job failed: {status}")

            time.sleep(10)


@task(name="Transform with dbt")
def transform(select: Optional[str] = None):

    commands = ["dbt deps"]

    if select:
        commands.append(f"dbt run --select {select}")
    else:
        commands.append("dbt run")

    DbtCoreOperation(
        commands=commands,
        project_dir=DBT_PROJECT_DIR,
        profiles_dir=DBT_PROFILES_DIR
    ).run()


@task(name="Test dbt models")
def test_data():

    DbtCoreOperation(
        commands=["dbt test"],
        project_dir=DBT_PROJECT_DIR,
        profiles_dir=DBT_PROFILES_DIR
    ).run()


@flow(name="Ecommerce ELT Pipeline")
def ecommerce_pipeline(
        run_extract: bool = True,
        run_transform: bool = True,
        run_tests: bool = True):

    logger = get_run_logger()

    logger.info("Starting Maven Fuzzy Factory pipeline")

    if run_extract:
        extract_and_load()

    if run_transform:
        transform()

    if run_tests:
        test_data()

    logger.info("Pipeline completed successfully")

    return {"status": "success"}


if __name__ == "__main__":
    ecommerce_pipeline()