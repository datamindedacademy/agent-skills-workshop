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

| Time | Block | Who |
|---|---|---|
| 0:00–0:30 | Use a skill, then look inside it | everyone |
| 0:30–1:30 | Build your skill | by track |
| 1:30–2:00 | 🍽️ Food | |
| 2:00–3:00 | Add subagents | by track |

One arc: **use → inspect → build → fan out.**

### Use a skill, then look inside it (0:00–0:30, everyone)

A skill is just a folder you drop into `.claude/skills/`. That's the whole trick, so let's prove it by installing one. We'll use Anthropic's official [`explore-data`](https://github.com/anthropics/knowledge-work-plugins/tree/main/data/skills/explore-data). Pick **one** of these two ways.

#### Install it

**Option A, the `skills` CLI** (one command, no Claude needed):

```bash
npx skills add anthropics/knowledge-work-plugins --skill explore-data
```

This drops the skill into `.claude/skills/explore-data/`. You invoke it as `/explore-data`.

**Option B, Claude Code's built-in plugin marketplace.** Start `claude`, then:

```
/plugin marketplace add anthropics/knowledge-work-plugins
/plugin install data@knowledge-work-plugins
```

The skill arrives inside the `data` plugin, so it's invoked as `/data:explore-data` (plugin skills are namespaced to avoid collisions).

#### Run it

Point it at the sample dataset and ask, in plain language, *"What's in this data, and what's wrong with it?"*

```bash
/explore-data data/sample.csv          # Option A
/data:explore-data data/sample.csv     # Option B
```

One shot gives you a column profile, a data dictionary, and a list of quality problems.

#### Look inside it

Now open the file you just installed (`.claude/skills/explore-data/SKILL.md`) and read it. Notice the `description` line. That, and nothing else, is how the agent decided to run this skill when you asked your question. Everyone, whatever your track, profiles unfamiliar data, so this is where we all start.

### Build your skill (0:30–1:30, by track)

Pick the track that fits your role and build a working skill: structured output, plus a little power (`allowed-tools`, dynamic `` !`command` `` context, wrapping a CLI). You start from a scaffolded skeleton with TODOs, not a blank page. Each track ends with a stretch step: swap the `model:` in the frontmatter (Opus → Sonnet → Haiku) and find the smallest model your skill still works on.

### Add subagents (2:00–3:00, by track)

A subagent is a fresh Claude with its own context window. You hand it one job, it works in isolation, and it hands back an answer. The finale of every track spins up several at once to do independent work in parallel, then stitches the results together, often *calling* the skill you built before the break.

| Track | Build (0:30–1:30) | Add subagents (2:00–3:00) |
|---|---|---|
| ⚙️ **Data Engineer** | **Airflow Ops**: operate the scheduled dbt pipeline on Conveyor Airflow via the [Astronomer Airflow CLI](https://github.com/astronomer/agents/blob/main/astro-airflow-mcp/README.md#airflow-cli-tool) | **Failure triage**: a subagent per failed DAG diagnoses the root cause in parallel, then one incident summary |
| 📊 **Data Analyst** | **Talk to your data**: ask in plain language, it fires SQL at the shared DuckDB and explains the result | **Multi-panel report**: a subagent investigates each section, then one assembled report |
| 🛡️ **Data Steward** | **Data Product Checkup**: wrap [`checkup`](https://pypi.org/project/checkup/) to score a data product's governance | **Remediate the portfolio**: a subagent per product drafts the missing docs and tests, then one reviewable diff |

The judgment to take home: fan out when the work is independent, parallelizable, and context-heavy. Don't bother when a single quick pass will do, because subagents cost latency, tokens, and coordination. The intro profiled one CSV in a single pass; each finale hits many independent units, so it pays to spread them out.

One dataset runs through all of it. `data/warehouse.duckdb` and its `data/sample.csv` export ship in the repo. You profile it in the intro, the analyst queries it, the steward scores its products, and the engineer track runs its dbt build on a schedule in Conveyor Airflow. Same data, different lenses.

## How to start

Install `explore-data` (above), run it on `data/sample.csv`, then pick your track:

```bash
cd exercises/<track>   # data-engineer | data-analyst | data-steward
claude
# work the TODOs: build your skill first, then add subagents after the break
```

Each track folder has its skeleton and TODOs. Work them one at a time. Solutions live in `solutions/`, but try the TODOs before you peek.

## Reference

- `cheatsheet.md`: skill syntax quick reference.
- `CLAUDE.md`: project context, itself a small context-engineering example.
- [Claude Code skills docs](https://code.claude.com/docs/en/skills).
