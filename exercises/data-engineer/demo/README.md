# The production demo: `workshop-dbt-build`

The workshop warehouse's dbt build, scheduled on Conveyor Airflow. This is the
DAG you operate in the track. Read it here, or point your agent at the folder:
*"read `exercises/data-engineer/demo/` and explain what this pipeline does."*

| Piece | Where |
|---|---|
| DAG | `dags/workshop_dbt.py`: `ConveyorDbtTaskFactory`, one Airflow task per dbt model |
| dbt manifest the factory reads | `dags/manifest.json` (regenerate with `make manifest` at the repo root) |
| Conveyor project config | `.conveyor/project.yaml` at the repo root |
| Container | `Dockerfile` at the repo root: the `data/` dbt project on the dataminded dbt image |

`ConveyorDbtTaskFactory` turns the dbt graph into Airflow tasks: `start` → one
task per model → `end`. Each task runs `dbt build --select +<model>` in its own
ephemeral container, rebuilding its lineage from the seeds.
