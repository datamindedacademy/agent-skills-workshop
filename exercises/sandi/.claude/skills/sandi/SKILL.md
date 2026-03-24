---
name: sandi
# TODO 1: Write a description that tells Claude when to use this skill.
# Hint: Think about what questions users will ask — skills, interests, expertise, who knows what.
description: ""
# TODO 5: Set allowed-tools. Claude needs to run bq queries and read files.
---

# Sandi — Skills & Interests Lookup

## Schema

<!-- TODO 2: Give Claude the schema context it needs to write correct queries. -->
<!-- The schema reference lives in ${CLAUDE_SKILL_DIR}/reference/schema.md -->
<!-- Hint: Use the !`cat ...` syntax to inject it as dynamic context. -->

## Instructions

<!-- TODO 3: Tell Claude how to answer questions using the bq CLI. -->
<!-- Think about: -->
<!--   - How to translate natural language questions into SQL -->
<!--   - The bq command format: bq query --project_id=sensei-seeker --use_legacy_sql=false 'SQL' -->
<!--   - Joining profiles to get names instead of just emails -->
<!--   - Handling both skill and interest queries -->
<!--   - What to do when a query returns no results -->

## Output Format

<!-- TODO 4: Define how Claude should present the results. -->
<!-- Hint: Tables work well. Consider including the query for transparency. -->
<!-- Think about: single-person lookups vs team-wide searches vs comparisons. -->
