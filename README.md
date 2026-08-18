# Agent Skills for Data Practitioners

This is a hands-on workshop about agent skills. You start by using an existing skill, then build one yourself, and finally learn about more advanced practices like spawning subagents. 

After a shared intro you pick a track that matches your day-to-day work as a data practitioner: engineer, analyst, or steward.

## LLMs are not dumb, it's a skill issue

Agent skills are a simple, yet elegant way to provide additional context to an agent. A skill is nothing more than a markdown file named `SKILL.md`. This markdown file contains a so-called "frontmatter": a block of metadata containing its name and a description that tells the agent *when* to use it. In addition to the frontmatter, skills can contain arbitrary content like a set of instructions, scripts, and supporting files. The agent loads it on demand and follows it. Think of it as a recipe that you would teach a newcomer on your team when executing routine tasks.

## When is a skill the right tool?

An agent's working memory is its context window, and that window is finite. Context engineering means getting the right information into it at the right time, and keeping everything else out. There are a few common ways to do that, each with its own trade-off.

- **Plain prompting**: you put the knowledge in the message yourself, every single time. Nothing wrong with that, but it's spent the moment the conversation moves on.
- **A skill**: the instructions live in a file and load *on demand*, only when the description matches the task at hand. The context stays lean until the skill is needed, and then the recipe appears just in time. This is the technique the workshop is about.
- **An MCP server**: instead of teaching the agent knowledge, you hand it *tools*: a live connection to an external system like a database or an API, or a set of capabilities shared across a team and reusable from any agent. Results only enter the context when a tool is actually called, so even a huge system stays addressable without sitting in the window. In short: a skill teaches a *procedure*, an MCP server hands over *capabilities*.
- **RAG**: when the source of truth is a large body of existing knowledge (docs, tickets, a wiki), you retrieve just the relevant, citable slice at query time and inject it. The agent stays grounded in verifiable sources instead of its own memory, and only the slice that matters ever touches the context.

You can also combine them: a skill can call an MCP server, and RAG retrieval can sit behind a skill. A skill is the right choice when you already know how to do something and want to teach it to the agent once. That's the case this workshop focuses on.

## Terminal or editor?

Claude Code runs both in the terminal and in a VSCode panel, and skills behave the same in both. Use whichever you prefer.

| Interface | Best for |
|---|---|
| **Claude Code in VSCode** | Anyone who'd rather chat in an editor panel than a terminal |
| **Claude Code CLI** | Anyone comfortable on the command line |

Both run the whole skill, including the automated parts: `` !`commands` ``, scripts, and `allowed-tools`.

## Prerequisites

- A **Conveyor IDE** with Claude Code pre-installed and configured.
- The `conveyor` CLI authenticated: run `conveyor auth login` once in the IDE terminal.
- Skim `cheatsheet.md` before you start.

## Schedule (3 hours)

| Duration | Block | Who |
|---|---|---|
| 45 min | Introduction + using `explore-data` (presentation) | everyone |
| 45 min | Build your skill | by track |
| 30 min | 🍽️ Food | |
| 60 min | Add subagents | by track |

### Build your skill, then add subagents (by track)

You spend the rest of the workshop on one track. Before the break you build a real skill from a scaffold and learn what makes one tick: the description that decides when it fires, the tools it may use, context pulled in live at runtime, and the domain knowledge you encode so the agent stops guessing. After the break you grow it into a skill that fans out **subagents** to work in parallel and pulls their answers back together, and you learn when that's worth doing and when a single pass is better.

Not sure which track fits you? Run `/sorting-hat`; it asks a couple of questions and points you to one.

| Track | Build (45 min) | Add subagents (60 min) |
|---|---|---|
| ⚙️ **Data Engineer** | **Airflow Ops**: operate the scheduled dbt pipeline on Conveyor Airflow via the [Astronomer Airflow CLI](https://github.com/astronomer/agents/blob/main/astro-airflow-mcp/README.md#airflow-cli-tool) | **Failure triage**: a subagent per failed DAG diagnoses the root cause in parallel, then one incident summary |
| 📊 **Data Analyst** | **Talk to your data**: ask in plain language, it fires SQL at the shared DuckDB and explains the result | **Multi-panel report**: a subagent investigates each section, then one assembled report |
| 🛡️ **Data Steward** | **Data Product Checkup**: wrap [`checkup`](https://pypi.org/project/checkup/) to score a data product's governance | **Remediate**: a subagent per failing check drafts the fixes, then one reviewable diff |

All tracks work on the same dataset: `data/warehouse.duckdb` and its `data/sample.csv` export ship in the repo. You profile it in the intro, the analyst track queries it, the steward track scores its products, and the engineer track runs its dbt build on a schedule in Conveyor Airflow.

## Getting started

First, install a skill yourself. An installed skill is nothing more than a folder under `.claude/skills/`. Install Anthropic's [`explore-data`](https://github.com/anthropics/knowledge-work-plugins/tree/main/data/skills/explore-data) either way:

```bash
npx skills add anthropics/knowledge-work-plugins --skill explore-data
```

or inside `claude`, via the built-in plugin marketplace:

```
/plugin marketplace add anthropics/knowledge-work-plugins
/plugin install data@knowledge-work-plugins
```

Run it on the sample data, then open the `SKILL.md` to see how its `description` told the agent when to fire:

```bash
/explore-data data/sample.csv     # /data:explore-data with the plugin
```

Then pick your track and work the TODOs one at a time. Solutions live in `solutions/`, but try it yourself before you look.

```bash
cd exercises/<track>/1-build   # track: data-engineer | data-analyst | data-steward
claude
```

Each track has two stage folders, `1-build/` and `2-subagents/`, each with the
skill skeleton, its instructions, and a `tests/` checker that tells you when
you're done. Start `claude` inside the stage folder you're working on.

## Reference

- `cheatsheet.md`: skill syntax quick reference.
- `CLAUDE.md`: project context, itself a small context-engineering example.
- [Claude Code skills docs](https://code.claude.com/docs/en/skills).
