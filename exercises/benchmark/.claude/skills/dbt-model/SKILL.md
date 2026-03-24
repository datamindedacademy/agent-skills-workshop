---
name: dbt-model
description: # TODO 1: Write a description that explains what this skill does
             # and when it should be used. Include key terms like "dbt", "model",
             # "create", "mart".
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# dbt Model Creator

## Step 1: Analyze project structure

# TODO 2: Tell Claude to run the analysis script as its first step
# Hint: cd exercises/benchmark/dbt_project && uv run python scripts/analyze_project.py
# The output gives Claude the full project context in one compact JSON

## Step 2: Review conventions

# TODO 3: Reference conventions.md so Claude loads your team's patterns
# Hint: Use a markdown link to the file

## Step 3: Create the model

# TODO 4: Reference the SQL template for mart models
# Hint: Use ${CLAUDE_SKILL_DIR} to reference templates/mart_model.sql

## Step 4: Validate

# TODO 5: Add the validation workflow
# After writing the model, run dbt build --select <model_name>
# If it fails, fix and retry
# Then add tests and documentation using the schema template

## Step 5: Verify

# TODO 6: Add final verification step
# Run dbt test --select <model_name>
# Confirm all tests pass
