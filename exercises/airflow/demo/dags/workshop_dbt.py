"""The workshop dbt build, scheduled in production on Conveyor.

ConveyorDbtTaskFactory reads the dbt manifest and generates one Airflow task
per dbt model (run + test), executed in this project's container. Same dbt
project as ../../data — plus a schedule, a container, and an IAM role.

Deployed by the facilitator with `conveyor deploy` — see demo/README.md.
"""

from airflow import DAG
from conveyor.factories import ConveyorDbtTaskFactory

dag = DAG(
    dag_id="workshop-dbt-build",
    description="dbt build of the workshop warehouse (one task per model)",
    schedule="@daily",
    catchup=False,
)

factory = ConveyorDbtTaskFactory(
    task_aws_role="product-agent-skills-workshop",
)
start, end = factory.add_tasks_to_dag(dag=dag)
