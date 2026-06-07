"""The workshop dbt build, scheduled in production on Conveyor.

ConveyorDbtTaskFactory reads dags/manifest.json (regenerate with
`make manifest`) and creates one Airflow task per dbt model. Each task runs
`dbt build --select +<model>` in its own container: the DuckDB file is
ephemeral, so a task rebuilds its full lineage from the seeds.

NOTE for the workshop: with `--target prod`, two tests on fct_orders are
strict (severity error) and fail on the deliberately dirty seed data: the
duplicate order_id and the orphan customer_id 999. Participants debug this
with their airflow-ops / failure-triage skills.
"""

from datetime import datetime

from airflow import DAG
from conveyor.factories import ConveyorDbtTaskFactory

dag = DAG(
    dag_id="workshop-dbt-build",
    description="dbt build of the workshop warehouse (one task per model)",
    schedule="@hourly",
    start_date=datetime(2026, 6, 1),
    catchup=False,
    max_active_runs=1,
    tags=["workshop", "dbt"],
)

factory = ConveyorDbtTaskFactory(
    # `build` (not the default run/test split): seeds + models + tests of the
    # whole `+model` lineage, so each task is self-sufficient on ephemeral DuckDB.
    # Cautious indirect selection: a test only runs when ALL the models it
    # touches are in the selection: otherwise the fct_orders relationships
    # test would run (and crash) in the dim_customers task too.
    task_arguments=[
        "--no-use-colors",
        "build",
        "--target", "prod",
        "--select", "+{model}",
        "--indirect-selection", "cautious",
    ],
)
start, end = factory.add_tasks_to_dag(dag=dag, test_tasks=False)
