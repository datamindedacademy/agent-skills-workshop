# Sandi BigQuery Schema Reference

Project: `sensei-seeker`
Dataset: `sandi_prod`

## Tables

### `profiles`

Maps email addresses to display names.

| Column | Type | Mode | Description |
|---|---|---|---|
| `user_email` | STRING | REQUIRED | Email of user |
| `user_name` | STRING | NULLABLE | Name of the user |

### `sandi_entries`

Each row is one person's skill or interest rating for a specific topic.

| Column | Type | Mode | Description |
|---|---|---|---|
| `user_email` | STRING | REQUIRED | Email of user |
| `category` | STRING | REQUIRED | Category grouping (e.g. "GenAI", "Platform") |
| `topic` | STRING | REQUIRED | Specific topic (e.g. "Docker", "SQL") |
| `type` | STRING | REQUIRED | Either `skill` or `interest` |
| `value` | INTEGER | REQUIRED | Rating from 0 (none) to 4 (expert/passionate) |
| `timestamp` | TIMESTAMP | REQUIRED | When the entry was recorded |

### `harvest_table`

Staffing data: role levels and client history.

| Column | Type | Mode | Description |
|---|---|---|---|
| `user_email` | STRING | REQUIRED | Email of user |
| `level` | STRING | NULLABLE | Role level (e.g. Partner, Data Engineer) |
| `level_code` | STRING | NULLABLE | Code for the level |
| `client` | STRING | REPEATED | Lifetime list of clients |
| `level_number` | INTEGER | NULLABLE | Numeric level |
| `timestamp` | TIMESTAMP | REQUIRED | Timestamp of entry |

## Categories in `sandi_entries`

AIML - Foundations, AIML - MLOps, AIML - Tools, AIML Frameworks & Platforms,
Analytics - Data Analytics, Analytics - Data Engineering, Communication,
Data Analytics, Data Engineering, Data Science Foundations, Domain Expertise,
GenAI, MLOps, Platform, Process & Roles, Programming Languages,
Software Development, Strategy & Impact

## Value scale

| Value | Skill meaning | Interest meaning |
|---|---|---|
| 0 | No experience | No interest |
| 1 | Beginner | Slight interest |
| 2 | Intermediate | Moderate interest |
| 3 | Advanced | Strong interest |
| 4 | Expert | Passionate |
