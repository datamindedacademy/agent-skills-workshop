# Exercise: Jonnify

Build a skill that stylizes images into Jonny's drawing style using the Gemini API. The model sees actual sample drawings as reference — no text description of the style.

The API call lives as an inline Python script in the SKILL.md. Claude runs it with `python3 -c`, never touching the API key directly.

## Prerequisites

- `GEMINI_API_KEY` set in your environment (shell profile or devcontainer config — NOT a .env file)
- `python3` available
- Drop some of Jonny's drawings into `.claude/skills/jonnify/reference/style-samples/`

## Directory layout

```
.claude/skills/jonnify/
├── SKILL.md                     # The skill (your exercise)
└── reference/
    ├── style-guide.md           # How to use the style samples
    ├── gemini-api-guide.md      # API format reference
    └── style-samples/           # Put Jonny's drawings here
        ├── drawing1.png
        └── drawing2.png
```

## Steps

### 1. Read the reference material

- `.claude/skills/jonnify/SKILL.md` — the skeleton
- `.claude/skills/jonnify/reference/gemini-api-guide.md` — API format
- `.claude/skills/jonnify/reference/style-guide.md` — how style samples work

### 2. TODO 1 — Write the description

Third person. Say what the skill does AND when to use it. "Use when the user wants to..."

### 3. TODO 2 — Wire up the inputs

Accept the image path from `$ARGUMENTS`. Point to style samples via `${CLAUDE_SKILL_DIR}/reference/style-samples/`.

### 4. TODO 3 — Write the API script

Embed a Python script that Claude runs with `python3 -c`. It should:
- Read the API key from `os.environ` (never log it)
- Base64-encode style samples + input image
- Call Gemini API, extract output, save to file

This is **low freedom** — the API call is fragile. Give Claude the exact script.

### 5. TODO 4 & 5 — Output and allowed-tools

Tell Claude what to report. Set `allowed-tools` in frontmatter. Add a guardrail: if the key isn't set, tell the user — don't go looking for it.

### 6. Test it

```bash
/jonnify sample-input.png
```

## When you're done

Compare with `solutions/jonnify/`.
