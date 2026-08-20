# Stage 1: Build `airflow-ops` (45 min)

Ask about your pipelines in plain language; the skill drives the Airflow API
via `af` (list, inspect, trigger, diagnose). Do the smoke test in the track
README ("Before you start") first — your skill encodes that exact recipe.

1. Open `.claude/skills/airflow-ops/SKILL.md` and work the TODOs in order.
2. Use it to answer: **is the pipeline healthy? what was the last run?** Let the
   skill tell you, don't assume.
3. **Diagnose, then fix.** If a run failed, have the skill pull the logs and work
   out what actually caused it. Then fix it at the source in the dbt
   project (`../../../data`) and prove it the way Airflow does, locally:
   ```bash
   cd ../../../data && uv run dbt build --target prod
   ```
   When that's green, the scheduled run would be too. (No need to redeploy to the
   shared environment during the workshop.)

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

## Pick your mode

The TODO comments in the skeleton are the scaffolding. Less scaffolding, more
difficulty — the tests and the "Done when" checklist are identical in all three.

| Mode | What you get |
|---|---|
| Guided | The skeleton with all its TODO hints. Work them in order. |
| Challenge | Headings and numbered steps only — every hint stripped. Build from the "Done when" checklist. |
| Expert | Just the frontmatter and any reference marked "(given)". Write the skill from scratch. |

The Sorting Hat already put your track in the mode you picked. To switch:

```bash
python3 ../../../.claude/skills/sorting-hat/set-mode.py <track> <guided|challenge|expert>
```

Going back down a level is `git checkout .claude` from this folder.

## Done when

Run the checker from this folder:

```bash
bash tests/test-airflow-ops.sh
```

It verifies the structure (no TODOs, connection recipe, live DAG list,
guardrails) and then hands you the behavioural test. You're done when all
three hold:

- [ ] Asking "is the pipeline healthy?" **without naming the skill** triggers
      it — that's your `description` doing its job.
- [ ] The answer is a small table (DAG | state | last run | result) plus a
      one-sentence verdict and a suggested next step.
- [ ] Asking it to **trigger** a run makes it ask for your confirmation first —
      state-changing commands stay on a leash.
- [ ] It still passes with `model: eu.anthropic.claude-haiku-4-5-20251001-v1:0`
      in the frontmatter (see Stretch below). A vague spec passes on Opus, where
      the model covers for it, and falls apart on Haiku.

## Challenge: cheapest passing skill

Measure on **clean context** — `/clear` first. Not `/compact`: compaction costs
tokens itself and leaves a summary behind, so the number stops being comparable.

```
/clear
/cost              # baseline
/airflow-ops
/cost              # delta = what one run of your skill costs
```

Now make that delta smaller without failing the checklist. What moves it:

- a tight `description` — Claude stops hunting for when to fire
- a tight `allowed-tools` — no exploratory Read/Glob before the `af` calls
- an exact output spec — no re-drafting the table
- a smaller `model:` — same work, cheaper tokens

Lowest output-token run that still passes the "Done when" checks wins.

## Stretch

- **Swap the model.** A skill can declare its own `model:` (override lasts while
  active). Run it on each and find the smallest model it still works on:
  | `model:` | |
  |---|---|
  | *(none)* | session model (Opus 4.8) |
  | `eu.anthropic.claude-sonnet-4-6` | usually identical, faster |
  | `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | fastest, still correct? |
  `/model` shows what's active. (`effort:` dials reasoning up/down too.)
- **Make it manual-only.** This skill can *trigger* and *pause* production DAGs.
  Add `disable-model-invocation: true` so Claude never fires it on its own; you
  invoke it deliberately with `/airflow-ops`. Compare with the in-skill
  confirmation guardrail: two different ways to keep side effects on a leash.
