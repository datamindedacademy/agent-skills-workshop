# Solution: Jonify

## Why these choices

**Script wraps the API call** — Claude never sees or handles `GEMINI_API_KEY`. The `jonify.py` script reads it from the environment internally. This is a security boundary: even if Claude tries to grep for it, it won't find it in any file.

**`allowed-tools: Bash, Read`** — Bash to run the script, Read to view the output image. No Write needed since the script handles file output. No need for Edit or Glob.

**Style samples as images, not text** — "Draw it like these" works better than "draw it with wobbly lines." The model sees the actual style instead of interpreting a description.

**`$ARGUMENTS` for input path** — The user should be able to `/jonify` any image, not just hardcoded paths.

**`${CLAUDE_SKILL_DIR}` for supporting files** — The skill finds its script and samples regardless of the user's working directory.
