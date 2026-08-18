# Track: Data Analyst

You'll build a skill that answers **plain-language questions** about the shared
warehouse with SQL, then, after the break, a second skill that fans out
**subagents** to write a multi-panel business report in parallel.

> **Dataset:** the shared warehouse `../../data/warehouse.duckdb` (built by the
> engineer's dbt project). You query it with the `duckdb` CLI, pre-installed in
> the workshop IDE.

## The two stages

Each stage is its own folder with the skill skeleton, its instructions, and a
test that tells you when you're done. **Start `claude` inside the stage
folder** so it picks up that stage's skill.

| | Folder | You build | Time |
|---|---|---|---|
| 1 | [`1-build/`](1-build/) | `talk-to-your-data`: plain-language Q&A over the warehouse | 45 min |
| 2 | [`2-subagents/`](2-subagents/) | `multi-panel-report`: one subagent per report section | 60 min |

```bash
cd 1-build && claude       # stage 1; after the break: cd ../2-subagents
```

The warehouse builds automatically when the IDE opens. If a query says the file
is missing (e.g. in a plain terminal where that startup task didn't run), build
it once from this folder: `bash ../../data/build.sh`.

## Stuck?

Peek at `solutions/data-analyst/` (same folder layout), but try the TODOs first.

## Requirements

The workshop IDE pre-installs the `duckdb` CLI. Running locally instead?
[Install DuckDB](https://duckdb.org/docs/installation/) (`curl https://install.duckdb.org | sh`
or `brew install duckdb`).
