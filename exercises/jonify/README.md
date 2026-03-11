# Exercise: Jonify

Build a skill that stylizes images into Jonny's drawing style using the Gemini API. The model sees actual sample drawings as reference — no text description of the style.

The API call lives as an inline Python script in the SKILL.md. Claude runs it with `python3 -c`, never touching the API key directly.

## Prerequisites

- `GEMINI_API_KEY` env var set
- `python3` available
- Drop some of Jonny's drawings into `reference/style-samples/`

## Steps

### 1. Read the reference material

- `.claude/skills/jonify/SKILL.md` — the skeleton
- `reference/gemini-api-guide.md` — API format and examples
- `reference/style-guide.md` — how to use the style samples

### 2. TODO 1 — Write the description

Third person. Say what the skill does AND when to use it. Example: "Does X. Use when the user wants to Y."

### 3. TODO 2 — Wire up the inputs

Accept the image path from `$ARGUMENTS`. Point to style samples via `${CLAUDE_SKILL_DIR}`.

### 4. TODO 3 — Write the API script

Embed a Python script that Claude runs with `python3 -c`. It should:
- Read the API key from `os.environ` (never log it)
- Base64-encode style samples + input image
- Call Gemini API, extract output, save to file

This is a **low freedom** section — the API call is fragile. Give Claude the exact script, don't let it improvise.

### 5. TODO 4 & 5 — Output and allowed-tools

Tell Claude what to report. Set `allowed-tools` in frontmatter.

### 6. Test it

```bash
/jonify reference/sample-input.png
```

## When you're done

Compare with `solutions/jonify/`.
