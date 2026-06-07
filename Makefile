.PHONY: manifest build deploy

# Regenerate the dbt manifest that ConveyorDbtTaskFactory reads at DAG parse
# time (it must be committed next to the DAG in dags/).
manifest:
	cd data && uv run dbt ls
	cp data/target/manifest.json dags/manifest.json

build:
	conveyor build

deploy:
	conveyor deploy --env workshop
