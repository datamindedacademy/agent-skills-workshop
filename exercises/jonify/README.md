# Exercise: Jonify

Build a skill that takes a drawing and transforms it into Jonny's style using the Gemini image generation API. The trick: you feed the model actual sample drawings as style reference, not a text description.

## Prerequisites

- `GEMINI_API_KEY` env var set with a valid GCP API key
- `curl` or `python3` available
- Drop a few of Jonny's drawings into `reference/style-samples/`

## Steps

### 1. Read the reference material

- `.claude/skills/jonify/SKILL.md` — the skeleton
- `reference/style-guide.md` — how to use the style samples
- `reference/gemini-api-guide.md` — Gemini API details

### 2. TODO 1 — Accept the input image

The user invokes `/jonify path/to/drawing.png`. Use `$ARGUMENTS` to capture the path.

### 3. TODO 2 — Load the style samples

Point Claude to the style sample images in `${CLAUDE_SKILL_DIR}/reference/style-samples/`. These get sent to the API alongside the input image.

### 4. TODO 3 — Call the Gemini API

Write instructions for Claude to call the API. Send the style samples + input image together. The prompt should tell the model to redraw the input in the style of the samples. See `gemini-api-guide.md` for the API format.

### 5. TODO 4 — Save output and report

Tell Claude where to save the generated image and what to say to the user.

### 6. TODO 5 — Set allowed tools

The skill needs `Bash` (for API calls), `Read` (for files), and `Write` (for saving output).

### 7. Test it

```bash
/jonify reference/sample-input.png
```

Check that an output image file was created.

## When you're done

Compare with `solutions/jonify/`.
