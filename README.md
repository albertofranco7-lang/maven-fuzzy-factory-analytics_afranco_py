# Modern Data Pipeline — Maven Fuzzy Factory Analytics

![Python](https://img.shields.io/badge/python-3.12-blue)
![dbt](https://img.shields.io/badge/dbt-1.11-orange)
![DuckDB](https://img.shields.io/badge/warehouse-motherduck-yellow)
![Prefect](https://img.shields.io/badge/orchestrator-prefect-blueviolet)
![Airbyte](https://img.shields.io/badge/ELT-airbyte-green)
![Metabase](https://img.shields.io/badge/BI-metabase-purple)

---

# Overview

Este proyecto implementa un **pipeline moderno de analítica de datos para ecommerce** utilizando herramientas del **Modern Data Stack**.

El objetivo es construir un flujo **end-to-end** que permita:

- ingestión automática de datos
- transformación analítica
- validación de calidad de datos
- orquestación de pipelines
- visualización de métricas de negocio

El pipeline fue desarrollado como parte de la **Maestría en Inteligencia Artificial y Análisis de Datos**.

---

# Arquitectura del Pipeline

El flujo de datos sigue el siguiente diseño:


MySQL
│
▼
Airbyte
│
▼
MotherDuck (DuckDB)
│
▼
dbt
(staging → marts)
│
▼
Prefect
(orquestación)
│
▼
Metabase
(dashboard BI)


---

# Modern Data Stack Utilizado

| Herramienta | Rol |
|--------------|-----|
MySQL | Base de datos transaccional |
Airbyte | Extracción y carga de datos |
MotherDuck | Data Warehouse |
dbt | Transformación analítica |
Prefect | Orquestación del pipeline |
Metabase | Business Intelligence |

---

# Flujo del Pipeline

1️⃣ **Extracción**

Airbyte extrae datos desde MySQL.

Tablas:

- orders
- order_items
- products
- website_sessions

---

2️⃣ **Carga**

Airbyte carga los datos en **MotherDuck (DuckDB cloud)**.

---

3️⃣ **Transformación**

dbt transforma los datos mediante modelos SQL organizados en:

- staging layer
- marts layer

---

4️⃣ **Orquestación**

Prefect ejecuta automáticamente:

- Airbyte sync
- dbt build
- data quality tests

---

5️⃣ **Visualización**

Metabase permite analizar:

- revenue
- conversion rate
- sesiones
- ventas por producto
- performance por canal

---

# Arquitectura de Modelos dbt

El proyecto sigue la arquitectura recomendada de dbt.

## Staging Layer

Responsable de limpiar y normalizar datos.

Modelos:


stg_orders
stg_order_items
stg_products
stg_website_sessions


Funciones:

- limpieza de datos
- renombrado de columnas
- tipado consistente

---

## Marts Layer

Modelos optimizados para análisis.

Modelos:


dim_products
fct_orders
fct_website_sessions
mart_channel_performance
mart_daily_ecommerce


Estos modelos permiten analizar métricas como:

- revenue
- total orders
- conversion rate
- sesiones
- performance por canal

---

# Data Quality Framework

Se implementó un framework de calidad de datos utilizando **dbt tests**.

---

## Tests Genéricos

Ejemplos:


unique
not_null
relationships


Validan:

- integridad de claves
- ausencia de valores nulos
- consistencia entre tablas

---

## Tests Avanzados con dbt-expectations

Se utilizó el paquete:


dbt-expectations


Ejemplos de validaciones:


expect_column_values_to_be_between
expect_column_distinct_values_to_be_in_set


Esto permite validar:

- rangos de métricas
- valores permitidos en columnas categóricas

---

## Tests Personalizados (Singular Tests)

### Revenue negativo

Archivo:


tests/singular_orders_positive_revenue.sql


Verifica que no existan órdenes con revenue negativo.

---

### Canal inválido

Archivo:


tests/singular_sessions_valid_channel.sql


Valida que los canales pertenezcan al set permitido.

---

# Estructura del Proyecto


maven_analytics/

models/
├ staging/
│
│ stg_orders.sql
│ stg_order_items.sql
│ stg_products.sql
│ stg_website_sessions.sql
│
└ marts/

dim_products.sql
fct_orders.sql
fct_website_sessions.sql
mart_channel_performance.sql
mart_daily_ecommerce.sql

tests/

singular_orders_positive_revenue.sql
singular_sessions_valid_channel.sql

pipelines/

ecommerce_pipeline.py

packages.yml
dbt_project.yml
.env
README.md


---

# Ejecución del Proyecto

## Instalar dependencias


dbt deps


---

## Ejecutar pipeline completo


dbt build


Resultado esperado:


PASS=48 WARN=0 ERROR=0


Esto confirma que:

- todos los modelos se construyeron correctamente
- todos los tests pasaron

---

# Documentación del Proyecto

dbt permite generar documentación automática.

Generar documentación:


dbt docs generate


Visualizar:


dbt docs serve


Esto muestra:

- DAG de dependencias
- documentación de modelos
- documentación de columnas
- tests asociados

---

# Orquestación con Prefect

El pipeline completo es ejecutado mediante:


pipelines/ecommerce_pipeline.py


El flujo ejecuta:

1. Airbyte sync
2. dbt build
3. tests de calidad

Esto permite automatizar el pipeline completo.

---

# Dashboard Analítico

El dashboard en **Metabase** incluye:

Visualizaciones:

- revenue diario
- total orders
- revenue por producto
- conversion rate por canal
- sesiones por canal

Filtros:

- fecha
- canal

Esto permite analizar el desempeño del ecommerce.

---

# Resultados

El pipeline permite:

- ingestión automatizada de datos
- transformación analítica escalable
- validación de calidad de datos
- orquestación automática
- visualización interactiva

---

# Tecnologías

- Python
- SQL
- dbt
- DuckDB
- MotherDuck
- Airbyte
- Prefect
- Metabase

---

# Autor

Alberto Franco  
IAAD FPUNA
