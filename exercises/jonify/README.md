# Exercise: Jonify

Build a skill that takes a drawing and transforms it into Jonny's style using the Gemini image generation API. You feed the model actual sample drawings as style reference, not a text description.

The API call itself is wrapped in a script (`jonify.py`) — Claude never sees the API key.

## Prerequisites

- `GEMINI_API_KEY` env var set with a valid GCP API key
- `python3` available
- Drop a few of Jonny's drawings into `reference/style-samples/`

## Steps

### 1. Read the reference material

- `.claude/skills/jonify/SKILL.md` — the skeleton
- `reference/jonify.py` — the script that handles the API call
- `reference/style-guide.md` — how the style samples work
- `reference/gemini-api-guide.md` — API details (for your understanding, not Claude's)

### 2. TODO 1 — Accept the input image

The user invokes `/jonify path/to/drawing.png`. Use `$ARGUMENTS` to capture the path.

### 3. TODO 2 — Point to the style samples

Tell Claude where the style sample images live. Use `${CLAUDE_SKILL_DIR}` for the path.

### 4. TODO 3 — Run the script

Tell Claude to run `jonify.py` with the right arguments. The script takes `<input_image> <style_samples_dir> [output_path]`. Claude should NOT construct API calls or touch the API key directly.

### 5. TODO 4 — Set allowed tools and output

Set `allowed-tools` (Bash to run the script, Read to view the result). Tell Claude what to report to the user.

### 6. Test it

```bash
/jonify reference/sample-input.png
```

Check that `jonified-output.png` was created.

## When you're done

Compare with `solutions/jonify/`.
