# Container for the scheduled dbt build (Conveyor Airflow tasks).
# Each ConveyorDbtTaskFactory task runs `dbt build --select +<model>` in here —
# the DuckDB file is ephemeral per task, so every task rebuilds its lineage.
FROM public.ecr.aws/dataminded/dbt:v1.11.2

WORKDIR /app
COPY data/ .

ENV DBT_PROFILES_DIR="/app"
ENV DBT_PROJECT_DIR="/app"

# Populate the dbt parse cache so tasks start fast.
RUN dbt ls
