# AI Agent Skills for Data Practitioners

A hands-on workshop where you **use** an agent skill against a real data stack, then **build** your own. You'll leave with at least one working skill and a clear mental model for when to reach for a skill vs MCP vs RAG vs plain prompting.

No deep coding required. After a shared intro, you **choose your own adventure** based on your role.

## A skill in one sentence

A skill is a `SKILL.md` file: a name, a description that tells the agent *when* to use it, and a set of instructions (optionally with commands, scripts, and supporting files). The agent loads it on demand and follows it.

## Pick your surface

Same Claude Code, same skills, same `SKILL.md`: choose whichever interface you prefer:

| Surface | Best for |
|---|---|
| **VSCode: Claude Code extension** | Anyone who'd rather chat in an editor panel than a terminal |
| **Claude Code CLI** | Anyone comfortable on the command line |

Both run the *whole* skill identically (instructions **and** automation: `!`commands, scripts, `allowed-tools`). The interface is just a surface; the skill is the same.

## Prerequisites

- Access to the workshop **Conveyor** environment (managed Airflow): [app.conveyordata.com](https://app.conveyordata.com)
- A **Conveyor IDE**: Claude Code comes pre-installed and configured
- The `conveyor` CLI authenticated: `conveyor auth login`
- Prefer not to use a terminal? Use the **Claude Code VSCode extension** instead: same skills, friendlier surface.
- Skim `cheatsheet.md` before you start

## The shape of the workshop (3 hours)

| Time | Block | Who |
|---|---|---|
| 0:00–0:30 | **Use a skill, then look inside it** | everyone |
| 0:30–1:30 | **Build your skill** | by track |
| 1:30–2:00 | 🍽️ Food | |
| 2:00–3:00 | **Add subagents** | by track |

One arc: **use → inspect → build → fan out.**

### Use a skill, then look inside it (0:00–0:30, everyone)

First, **install a skill yourself**. A skill is just a folder under `.claude/skills/` with a `SKILL.md` inside. Install Anthropic's official [`explore-data`](https://github.com/anthropics/knowledge-work-plugins/blob/main/data/skills/explore-data/SKILL.md) by creating that folder and downloading the file (run from the repo root):

```bash
mkdir -p .claude/skills/explore-data
curl -fsSL https://raw.githubusercontent.com/anthropics/knowledge-work-plugins/main/data/skills/explore-data/SKILL.md \
  -o .claude/skills/explore-data/SKILL.md
```

That's the whole install: one file in the right place. Start `claude` and run it on the sample dataset:

```bash
/explore-data data/sample.csv
```

Ask, in plain language, *"What's in this data, and what's wrong with it?"* One shot returns a column profile, a data dictionary, and flagged quality issues.

Then **open the file you just downloaded** (`.claude/skills/explore-data/SKILL.md`) and read its frontmatter and instructions. Notice the `description`: it is how the agent decides when to trigger the skill. Profiling an unfamiliar dataset is something an engineer, analyst, *and* architect all do, so everyone starts here.

### Build your skill (0:30–1:30, by track)

Pick the track that fits your role and build a working skill: structured output, plus a bit of power (`allowed-tools`, dynamic `` !`command` `` context, CLI wrapping). You start from a **scaffolded skeleton with TODOs**, not a blank page. Each track ends with a stretch step: **swap the `model:` in the frontmatter** (Opus → Sonnet → Haiku) and find the smallest model your skill still works on.

### Add subagents (2:00–3:00, by track)

The finale, for everyone regardless of track: a skill that **fans out work across many independent units in parallel, then synthesizes**: often *calling* the skill you built before the break. You also learn *when not to*.

| Track | Build (0:30–1:30) | Add subagents (2:00–3:00) |
|---|---|---|
| ⚙️ **Data Engineer** | **Airflow Ops**: schedule the dbt → DuckDB build on Conveyor Airflow (`ConveyorDbtTaskFactory`) and operate the pipeline via the [Astronomer Airflow skill](https://github.com/astronomer/agents/blob/main/astro-airflow-mcp/README.md#airflow-cli-tool) | **Failure triage**: a subagent per failed DAG diagnoses root cause in parallel → one incident summary |
| 📊 **Analyst / BI Developer** | **Talk to your data**: ask in plain language, it fires SQL at the shared DuckDB and explains the result | **Multi-panel report**: a subagent per section queries independently → one assembled report |
| 🏗️ **Data Architect** | **Data Product Checkup**: wrap [`checkup`](https://pypi.org/project/checkup/) to score one data product on DuckDB | **Portfolio health**: fan out `checkup` across *all* data products → one governance scorecard |

> **The subagent lesson: *when*, not just *how*.** The intro profiled **one** CSV single-pass: no subagents needed. Each finale hits **many** independent units (failed DAGs / report sections / data products), so it fans out and synthesizes. Heuristic: *independent + parallelizable + context-heavy → subagents; quick single-pass → don't* (they cost latency, tokens, and coordination).

> **One dataset, all day (the narrative spine).** A pre-built `data/warehouse.duckdb` and its `data/sample.csv` export ship in the repo: that committed file is the real source of truth every track uses. You profile it in the intro, the **analyst** queries it, the **architect** scores its products' health. The **engineer** track shows how that same dbt build is *scheduled in production* on Conveyor Airflow (`ConveyorDbtTaskFactory`): a demonstration, since the DuckDB file itself is local. Same data, four lenses.

## How to start

The intro skill (`explore-data`) is shared: install it once at the repo root (commands above) and run `/explore-data data/sample.csv`. Then pick your track:

```bash
cd exercises/<track>   # data-engineer | data-analyst | data-architect
claude
# follow the TODOs: build your skill first, then add subagents after the break
```

Each track dir has a scaffolded skeleton and TODOs: follow them one at a time. Solutions live in `solutions/`. Don't peek until you've tried.

## Testing your skill locally

Skills are picked up from the `.claude/` directory relative to where you run Claude:

```bash
cd exercises/<exercise-name>
claude
# then invoke: /skill-name <args>
```

Claude finds the `.claude/skills/` directory inside that folder.

## Reference

- `cheatsheet.md`: skill syntax quick reference
- `CLAUDE.md`: project context (itself a context-engineering example)
- [Claude Code skills docs](https://code.claude.com/docs/en/skills)
