---
name: dbt-model
description: Create a new dbt model (staging or mart) following project conventions. Use this skill when asked to create, add, or build a new dbt model, mart, or staging table.
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# dbt Model Creator

## Step 1: Analyze project structure

Run the analysis script from the dbt project directory to get the full project context:

```bash
cd exercises/benchmark/dbt_project && uv run python scripts/analyze_project.py
```

Review the JSON output before proceeding — it contains sources, models, macros, and conventions.

## Step 2: Review conventions

Follow the team's established patterns documented here:

[Project conventions](${CLAUDE_SKILL_DIR}/conventions.md)

## Step 3: Create the model

Use the mart model template as a starting point:

[Mart model template](${CLAUDE_SKILL_DIR}/templates/mart_model.sql)

When creating the model:
- Place it in `exercises/benchmark/dbt_project/models/marts/`
- Use `{{ ref('stg_...') }}` to reference staging models
- Use the `cents_to_dollars()` macro for monetary conversions
- Follow the CTE pattern: source CTEs → joined/transformed → final
- End with `select * from final`

## Step 4: Validate

After writing the model SQL file:

1. Run `cd exercises/benchmark/dbt_project && uv run dbt build --select <model_name> --profiles-dir .`
2. If it fails, read the error, fix the SQL, and retry
3. Add tests and documentation to `_marts_schema.yml` using this template:

[Schema entry template](${CLAUDE_SKILL_DIR}/templates/schema_entry.yml)

## Step 5: Verify

Run the final verification:

```bash
cd exercises/benchmark/dbt_project && uv run dbt test --select <model_name> --profiles-dir .
```

Confirm all tests pass before completing the task.
