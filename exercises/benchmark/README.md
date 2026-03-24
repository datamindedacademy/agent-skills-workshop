# Exercise: Benchmark — Proving Skills Reduce Token Usage

## Goal

Prove that a well-designed Claude Code skill reduces token usage for a real coding task. You'll run the same dbt model creation task twice — once without a skill (baseline) and once with your skill — then compare the results.

## Prerequisites

- Devcontainer running (or local environment with `dbt-core`, `dbt-duckdb`, and `uv` installed)
- Claude Code CLI available (`claude --version`)
- dbt project seeded and building cleanly

### Quick setup

```bash
cd exercises/benchmark/dbt_project
uv sync
uv run dbt deps --profiles-dir .
uv run dbt seed --profiles-dir .
uv run dbt build --profiles-dir .
```

All 58 checks should pass with zero errors.

## Part 1: Explore the dbt project

Before building anything, understand the project:

```bash
cd exercises/benchmark/dbt_project
```

- Look at `models/staging/` — how are staging models structured?
- Look at `models/marts/` — what patterns do mart models follow?
- Look at `macros/` — what helpers are available?
- Run `uv run python scripts/analyze_project.py | python3 -m json.tool` to see the full project summary

Key conventions to notice:
- CTE-based transformations (source → renamed → final)
- `stg_` prefix for staging, `mart_` prefix for marts
- Monetary values in cents, converted via `cents_to_dollars()` macro
- All sources referenced via `{{ source() }}`, models via `{{ ref() }}`

## Part 2: Baseline run

Run the task **without any skill** to establish a baseline:

```bash
# From the repository root
claude -p "$(cat exercises/benchmark/TASK.md)" --dangerously-skip-permissions --output-format json > exercises/benchmark/results/baseline_1.json
```

> **WARNING:** `--dangerously-skip-permissions` is ONLY safe in isolated devcontainers. NEVER use this flag against real infrastructure.

After the run, check if the model was created correctly:

```bash
cd exercises/benchmark/dbt_project
uv run dbt build --profiles-dir .
```

Then reset for the next run:

```bash
git checkout -- exercises/benchmark/dbt_project/models/
```

**Important:** Start a fresh `claude` session for each run. Do NOT reuse conversation context between runs.

## Part 3: Build the skill

Open the skill skeleton at `.claude/skills/dbt-model/SKILL.md` and fill in the TODOs one at a time:

1. **TODO 1** — Write a description with keywords like "dbt", "model", "create", "mart"
2. **TODO 2** — Add a dynamic context command to run the analysis script
3. **TODO 3** — Reference `conventions.md` for project patterns
4. **TODO 4** — Reference the SQL template for mart models
5. **TODO 5** — Add the validation workflow (dbt build + fix loop)
6. **TODO 6** — Add the verification step (dbt test)

Also fill in the supporting files:
- `conventions.md` — document the project conventions you discovered in Part 1
- `templates/mart_model.sql` — create a SQL template based on existing marts
- `templates/schema_entry.yml` — create a test/doc YAML template

**Test after each TODO** — invoke the skill with Claude to make sure it triggers and works.

## Part 4: Skill run

Run the same task **with your skill**:

```bash
# From the repository root
claude -p "/dbt-model $(cat exercises/benchmark/TASK.md)" --dangerously-skip-permissions --output-format json > exercises/benchmark/results/skill_1.json
```

Verify the model:

```bash
cd exercises/benchmark/dbt_project
uv run dbt build --profiles-dir .
```

Then reset:

```bash
git checkout -- exercises/benchmark/dbt_project/models/
```

## Part 5: Measure

Token usage is tracked via **ccusage**, which reads Claude Code's local session logs.

First, list your recent sessions to find the IDs:

```bash
npx ccusage session
```

Create the results directory and save session IDs (one per line):

```bash
mkdir -p exercises/benchmark/results
echo "<baseline-session-id>" > exercises/benchmark/results/baseline_sessions.txt
echo "<skill-session-id>" > exercises/benchmark/results/skill_sessions.txt
```

Then compare:

```bash
python3 exercises/benchmark/scripts/compare.py exercises/benchmark/results/
```

This fetches token data from ccusage and shows a side-by-side table with input tokens, output tokens, total tokens, cost, and percentage reduction.

### Automated benchmark (optional)

For more reproducible results with multiple runs:

```bash
bash exercises/benchmark/scripts/benchmark.sh 3
```

This runs 3 baseline and 3 skill runs automatically, saves session IDs, then shows the comparison.

## Part 6: Reflect

- Did the skill reduce token usage? By how much?
- Did the quality of the generated model change?
- Which part of the skill contributed most to the reduction?
  - Dynamic context (analysis script)?
  - Conventions reference?
  - SQL template?
  - Validation workflow?
- What would you change about your skill design?

## Tips

- Between runs, always `git checkout -- exercises/benchmark/dbt_project/models/` to reset and start a new `claude -p` session
- The skill triggers on the description keywords — if it doesn't trigger, check your `description` field
- Keep your skill under 500 lines total
- The analysis script is your biggest token saver — it replaces ~15 file reads with one JSON payload
