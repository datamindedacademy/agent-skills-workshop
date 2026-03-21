# Hack & Beers: Applied Context Engineering — Building Agent Skills

**Infra:** OV Bedrock | **Prep:** Jesus + Jan | **Proposed date:** Mid March 

---

## Outcomes

| | Ideally, we want to achieve this... |
|---|---|
| **Mental model** | What context engineering is and why it determines agent quality |
| **Practical skill** | Can install, read, and write an Agent skill |
| **Positioning** | When to reach for a Skill vs MCP vs RAG vs raw prompting |
| **Artifact** | At least one working skill they built themselves |

---

## Part 1: Theory

**Arc:** See it work → understand why → understand how → build one → go build your own.

#### Block 1 — Agentic Harness Demo

- Claude Code doing a task *without* a skill (fumbles), then *with* a skill (nails it).
- "The skill gave the agent the right context at the right time."
- **Prep:** One polished before/after demo on OV Bedrock. Pre-recorded backup.

#### Block 2 — Context Engineering: The Mental Model

- LLMs are capable but directionless without context. "A brilliant intern on day one."
- Context engineering = designing the information diet for your agent. Three levers: *what info*, *when it appears*, *how it's structured*.
- The spectrum: Raw prompting → CLAUDE.md → Skills → MCP → RAG. Skills are the sweet spot for *reusable, shareable, scoped* context.

#### Block 3 — Skills Deep-Dive

- **Spec walkthrough:** Open a real SKILL.md. Walk through frontmatter, markdown instructions, `$ARGUMENTS`, `!command` syntax.
- **Good vs bad skill:** Side-by-side. Clear responsibility and right-sized context vs bloated/vague.
- **Marketplace:** A git repo IS a marketplace. Show [anthropics/skills](https://github.com/anthropics/skills), [SkillsMP](https://skillsmp.com/), [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code).

#### Block 4 — Live Build Together

- Build a simple Dataminded skill from scratch. Everyone follows along.
- **Prep:** Starter template ready, tested on OV Bedrock. Pre-recorded backup.

#### Block 5 — Hacking Setup

- Environment check, overview of exercises, Claude Code cheat sheet for beginners, questions.

---

## Part 2: Hacking

#### Warm-up: PR Review Skill

Everyone builds the same skill: `/pr-review` — reviews code changes and gives structured feedback.

- Skeleton with TODOs provided
- Uses `!git diff --cached` for dynamic context injection (teaches `!command` syntax)
- **Deliverable:** Working `/pr-review` installed in `~/.claude/skills/`
- **Prep:** Test repo with pre-staged changes so `!git diff --cached` always produces output

#### Deep Tracks — Pick One

Each track has a **minimum viable deliverable** and **stretch goals** for fast finishers.

| Track | Exercise | Deliverable | Key Learning |
|---|---|---|---|
| **A. Jonify** | Build a skill that takes a user's drawing and uses the Nano Banana image generator to transform it into Jonny's distinctive drawing style. Requires setting up the Nano Banana pipeline. | Working `/jonify` skill + generated image output | Image generation integration, tool setup, style transfer via prompting |
| **B. Context Reduction Benchmark** | Run a coding task with and without a skill. Measure token usage, compare output quality. | Benchmark data: token counts, cost delta, quality comparison | Quantifying skill value |
| **C. Terraform Resource Visualizer** | Build a skill that parses Terraform state/plan and generates an interactive HTML visualization of infrastructure resources and dependencies. | Skill with supporting files + generated HTML | Supporting files, `allowed-tools`, script bundling |
| **D. Anti-Skill / Swill** | Fork a working skill. Introduce subtle bugs. Write a companion "fix-it" exercise. | A "broken" skill + student exercise sheet | Skill design by breaking (academy concept) |
| **E. Sandi — Skills & Interests** | Build a skill that wraps the BigQuery `bq` CLI to answer natural language questions about skills and interests of people at Dataminded using the Sandi dataset. | Working `/sandi` skill that translates questions to SQL | CLI wrapping, supporting files, dynamic context, `allowed-tools` |
