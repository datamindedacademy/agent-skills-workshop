# Agent Skills for Data Practitioners

A hands-on workshop where you **use** an agent skill against a real data stack, then **build** your own. You'll walk out with at least one working skill and a feel for when a skill is the right tool.

The workshop meets you wherever you work, from people at home in a terminal to analysts who live in a SQL editor. After a shared intro you **choose your own adventure** by role: engineer, analyst, or steward.

## A skill in one sentence

A skill is a `SKILL.md` file. It has a name, a description that tells the agent *when* to use it, and a set of instructions, optionally with commands, scripts, and supporting files. The agent loads it on demand and follows it.

## When is a skill the right tool?

The context window is the agent's working memory, and it's finite. **Context engineering is the craft of getting the right information into that window at the right time**, and keeping everything else out. These four techniques are different answers to one question: *what occupies the context, and when?*

- **Plain prompting**: you put the knowledge in context yourself, in the message, every time. Simplest, but it's spent the moment the conversation moves on.
- **A skill**: the instructions live in a file and load *on demand*, only when the description matches the task. The context stays lean until the skill is needed, then the procedure appears just in time. That's this workshop.
- **An MCP server**: instead of loading knowledge, you give the agent *tools*. A live connection to an external system (a database, an API), or a common set of capabilities shared across a team and reusable from any agent. Results enter the context only when a tool is actually called, so a huge system stays addressable without sitting in the window. A skill teaches a *procedure*; an MCP server hands over *capabilities*.
- **RAG**: when the source of truth is a large body of existing knowledge (docs, tickets, a wiki), you retrieve just the relevant, citable slice at query time and inject it. This keeps the agent *grounded* in verifiable sources instead of its own memory, while only the slice that matters ever touches the context.

They compose rather than compete. A skill can call an MCP server, and RAG retrieval can sit behind a skill, because each is just a different valve on the same context window. A skill is the sweet spot for "I know how to do this, let me teach the agent once," and learning to wield it is learning context engineering in miniature.

## Pick your surface

Same Claude Code, same skills, same `SKILL.md`. Use whichever interface you like.

| Surface | Best for |
|---|---|
| **Claude Code in VSCode** | Anyone who'd rather chat in an editor panel than a terminal |
| **Claude Code CLI** | Anyone comfortable on the command line |

Both run the whole skill identically, instructions and automation alike (`` !`commands` ``, scripts, `allowed-tools`). The interface is just a surface.

## Prerequisites

- A **Conveyor IDE** with Claude Code pre-installed and configured.
- The `conveyor` CLI authenticated: run `conveyor auth login` once in the IDE terminal.
- Skim `cheatsheet.md` before you start.

## The shape of the workshop (3 hours)

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
| 🛡️ **Data Steward** | **Data Product Checkup**: wrap [`checkup`](https://pypi.org/project/checkup/) to score a data product's governance | **Remediate the portfolio**: a subagent per product drafts the missing docs and tests, then one reviewable diff |

One dataset runs through all of it. `data/warehouse.duckdb` and its `data/sample.csv` export ship in the repo. You profile it in the intro, the analyst queries it, the steward scores its products, and the engineer track runs its dbt build on a schedule in Conveyor Airflow. Same data, different lenses.

## Getting started

First, install a skill yourself: it's just a folder under `.claude/skills/`. Install Anthropic's [`explore-data`](https://github.com/anthropics/knowledge-work-plugins/tree/main/data/skills/explore-data) either way:

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

Then pick your track and work the TODOs one at a time. Solutions live in `solutions/`, but try first.

```bash
cd exercises/<track>   # data-engineer | data-analyst | data-steward
claude
```

## Reference

- `cheatsheet.md`: skill syntax quick reference.
- `CLAUDE.md`: project context, itself a small context-engineering example.
- [Claude Code skills docs](https://code.claude.com/docs/en/skills).
