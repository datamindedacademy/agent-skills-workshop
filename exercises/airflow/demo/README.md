# Production demo — facilitator notes

`dags/workshop_dbt.py` is the DAG participants see in the `workshop` Airflow
environment: the shared dbt project, scheduled daily, one Airflow task per dbt
model via `ConveyorDbtTaskFactory`.

## Deploying (before the workshop)

This DAG ships inside a Conveyor *project* containing the dbt project from
`../../data` (the factory needs the compiled manifest in the container):

```bash
conveyor project create --name agent-skills-workshop   # already exists (terraform)
# in the conveyor project dir (dbt project + this dags/ folder + Dockerfile):
conveyor build && conveyor deploy --env workshop
```

See the [dbt task factory guide](https://docs.conveyordata.com/how-to-guides/working-with-dbt/using-the-dbt-task-factory/)
for the expected project layout (Dockerfile compiling the dbt project,
`dags/` folder).

## For Stage 2 (failure triage)

Break a few DAGs before the second half: deploy one or two copies of the DAG
with a failing model (e.g. point a source at a missing table) or clear a task
with a bad env var — participants' `/failure-triage` needs ≥2 failing DAGs to
make the fan-out worth it.

⚠️ Still to verify live before the workshop (needs `conveyor auth login`):
- the `af` smoke test against `https://app.conveyordata.com/environments/workshop/airflow`
  (Airflow 3 → af should pick `/api/v2` itself)
- token lifetime of `conveyor auth get` during a 3-hour session
