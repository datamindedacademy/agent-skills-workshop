.PHONY: manifest build deploy

# Regenerate the dbt manifest that ConveyorDbtTaskFactory reads at DAG parse
# time (it must be committed next to the DAG in exercises/airflow/demo/dags/).
manifest:
	cd data && uv run dbt ls
	cp data/target/manifest.json exercises/airflow/demo/dags/manifest.json

build:
	conveyor build

deploy:
	conveyor deploy --env workshop
