# Exercise: Sandi — Skills & Interests Lookup

Build a skill that wraps the BigQuery `bq` CLI to answer natural language questions about the skills and interests of people at Dataminded.

## What you'll learn

- `description` field — how Claude decides when to trigger your skill
- Supporting files — giving Claude schema knowledge via `${CLAUDE_SKILL_DIR}`
- `!`command`` — dynamic context injection
- `allowed-tools` — restricting Claude to only the tools it needs
- CLI wrapping — teaching Claude to use a CLI tool effectively

## Prerequisites

- `gcloud` CLI installed and authenticated (`gcloud auth login`)
- Access to the `sensei-seeker` BigQuery project (`gcloud config set project sensei-seeker`)

Verify with:
```bash
bq query --use_legacy_sql=false 'SELECT COUNT(*) FROM `sensei-seeker.sandi_prod.sandi_entries`'
```

## Directory layout

```
.claude/skills/sandi/
├── SKILL.md                    # The skill (your exercise)
└── reference/
    └── schema.md               # Table schemas and value scales
```

## Steps

### 1. Read the reference material

- `.claude/skills/sandi/SKILL.md` — the skeleton with TODOs
- `.claude/skills/sandi/reference/schema.md` — the BigQuery table schemas

### 2. TODO 1 — Write the description

The `description` tells Claude when to use this skill. Think about how users will phrase questions: "Who knows Spark?", "What are Jan's skills?", "Find people interested in GenAI."

### 3. TODO 2 — Inject the schema

Claude needs to know the table structure to write correct SQL. Use `!`cat ${CLAUDE_SKILL_DIR}/reference/schema.md`` to inject the schema at invocation time.

### 4. TODO 3 — Write the instructions

This is where you teach Claude how to use the `bq` CLI. Be specific about:
- The exact command format: `bq query --project_id=sensei-seeker --use_legacy_sql=false 'SQL'`
- Always join with `profiles` to show names, not just emails
- How to handle the `type` column (`skill` vs `interest`)
- Interpreting the 0-4 value scale

### 5. TODO 4 — Structure the output

Tell Claude how to present results. Consider:
- A markdown table for results
- Showing the SQL query for transparency
- Different formats for different question types (person lookup vs team search)

### 6. TODO 5 — Set allowed-tools

Claude needs `Bash` (to run `bq`) and `Read` (to read the schema file). Add these to the frontmatter.

### 7. Test it

```bash
cd exercises/sandi
claude
```

Then try these queries:
```
/sandi Who has the highest Spark skills?
/sandi What are the skills of jan.vanbuel@dataminded.com?
/sandi Find people interested in GenAI
/sandi Compare Docker skills across the team
```

### 8. Verify

Your skill should:
- Run valid BigQuery SQL via the `bq` CLI
- Return human-readable names (not just emails)
- Handle both skill and interest lookups
- Present results in a clean table format