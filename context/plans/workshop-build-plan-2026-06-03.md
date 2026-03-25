---
problem: Build the repo for "AI Agent Skills for Data Practitioners" — dataset foundation, three two-stage scaffolded tracks + solutions, and the pre-baked image.
date: 2026-06-03
related_outline: ../exports/workshop-design-outline-2026-06-03.md
---

# Workshop Build Plan

Ordered by dependency. Each track exercise is **two-stage**: a *build* skeleton that reaches a runnable checkpoint by the break, and a *subagent* skeleton that composes it. Every exercise ships a matching `solutions/` version (the rip-cord).

## Phase 0 — Repo hygiene (done / in progress)
- [x] Rewrite `README.md` as the workshop map.
- [ ] Remove Dataminded-specific `exercises/jonnify/`.
- [ ] Rename/retire: `exercises/pr-review`, `exercises/benchmark`, `exercises/swill` → mark as **take-home** (keep, but out of the main flow).

## Phase 1 — Dataset foundation ⭐ critical path (unblocks intro + analyst + architect) — ✅ DONE 2026-06-03
Build `data/`:
- [x] A small dummy dbt project (staging + 3 mart "data products": dim_customers, fct_orders, customer_order_summary) targeting **DuckDB** (`profiles.yml`, `pyproject.toml` pinning dbt-duckdb via `uv`).
- [x] `dbt build` produces **`data/warehouse.duckdb`** (verified, all tables present).
- [x] `data/scripts/export_sample.py` exports `fct_orders` → **`data/sample.csv`** (53 rows; verified). Orchestrated by `data/build.sh` (`dbt build` + export).
- [x] `data/README.md` documents rebuild + lists the deliberate issues.
- [x] Seed data has deliberate quality issues — verified in sample.csv: nulls, "N/A" placeholder, `-50`, `999999`, future 2099 dates, dup customer_id (3), dup order_id (50), orphan FK (999). dbt tests at `severity: warn` flag them (PASS=10 WARN=5).
- Note: minor cosmetic dbt 1.11 deprecation on the `relationships` test (`MissingArgumentsPropertyInGenericTestDeprecation`) — harmless, fix later if desired.

## Phase 2 — Intro assets
- [ ] Confirm `explore-data` install recipe (single-file `curl` of its `SKILL.md`); script it for the image pre-bake.
- [ ] Write the 30-min intro facilitator notes: run `/explore-data data/sample.csv` → dissect frontmatter → "why `description` triggers."

## Phase 3 — Track exercises (build first end-to-end, then fast-follow)
Recommended order: **Architect (Checkup)** first — it sits directly on the Phase 1 dataset and has the cleanest build→fan-out story; then Analyst; then Engineer (most infra).

### 3a. `exercises/data-checkup/` — Architect — ✅ DONE 2026-06-03
- [x] Build skeleton: `data-product-checkup` skill wraps `checkup`+`checkup-dbt` (governance metrics from the dbt manifest). TODOs for description / allowed-tools / metrics / scorecard. Starter `checkup.yaml`.
- [x] Subagent skeleton: `portfolio-health` — fan out one subagent per mart, synthesize a portfolio scorecard. TODOs for product list / Task dispatch / synthesis; includes the when-NOT-to-fan-out lesson.
- [x] `solutions/data-checkup/` — both skills filled + full `checkup.yaml`. Verified: runs from the solution dir, `../../data` resolves, real metrics (5 models / 3 documented / 75% coverage / 8 tests).
- [x] `checkup`/`checkup-dbt` confirmed on the DuckDB project — uses provider `dbt_project_dir` mode (parses the project; no committed manifest). Invoked via `uv run --with checkup --with checkup-dbt --with dbt-duckdb`. NOTE: `checkup init` is an interactive wizard (won't run headless) — ship a `checkup.yaml`, don't rely on init.
- [ ] LIVE DRY-RUN still needed: actually run `/portfolio-health` in a Claude session to confirm the subagent dispatch works as written (couldn't exercise Task fan-out headlessly here).

### 3b. `exercises/talk-to-your-data/` — Analyst / BI
- [ ] Build skeleton: a **Talk to your data** skill — NL→SQL via the DuckDB CLI against `warehouse.duckdb`; dynamic schema context.
- [ ] Subagent skeleton: **Multi-panel report** — a subagent per section (e.g. trend / cohort / funnel), each calling the query capability, assembled into one report.
- [ ] `solutions/talk-to-your-data/`.

### 3c. `exercises/airflow/` — Engineer
- [ ] Build skeleton: drive Conveyor Airflow with the [Astronomer Airflow skill](https://github.com/astronomer/agents/blob/main/astro-airflow-mcp/README.md#airflow-cli-tool) — `AIRFLOW_API_URL` + `conveyor auth get … access_token`; schedule the dbt→DuckDB build via `ConveyorDbtTaskFactory` (the "poetic" production demo).
- [ ] Subagent skeleton: **Failure triage** — a subagent per failed DAG diagnoses root cause in parallel → one incident summary.
- [ ] `solutions/airflow/`.
- [ ] Pre-deploy the dbt project to a live Conveyor env for the demo; live-test token refresh + Airflow API version.

## Phase 4 — Pre-baked Conveyor IDE image
- [ ] Bake in: `explore-data` skill, committed `warehouse.duckdb` + `sample.csv`, the deployed engineer demo, all CLIs (`checkup`, `duckdb`, `conveyor`, `af`).
- [ ] Smoke-test: fresh image → `/explore-data data/sample.csv` works in <1 min with zero install.

## Phase 5 — Dry run
- [ ] Full 3-hour timed rehearsal with a non-engineer tester per track.
- [ ] Confirm each build skeleton hits a runnable checkpoint by the 1:30 break.
- [ ] Confirm the subagent skeleton is completable (or peekable) in 60 min post-lunch.

## Definition of done (per the project's own bar)
A working skill **installs clean, triggers correctly, produces structured output** — verify each exercise against that.
