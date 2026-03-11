# Solution: Jonify

## Why these choices

**`allowed-tools: Bash, Read, Write`** — Bash is needed to call the Gemini API (via curl or python). Read for loading images and the style guide. Write for saving the output. No need for Edit, Glob, or anything else.

**Style samples instead of text description** — Showing the model actual examples of the style works way better than describing it in words. "Draw it like these" beats "draw it with wobbly lines and primary colors" every time.

**`$ARGUMENTS` for input path** — Hardcoding paths defeats the purpose. The user should be able to `/jonify` any image.

**`${CLAUDE_SKILL_DIR}` for supporting files** — The skill needs to find its reference files regardless of where the user's working directory is. Relative paths break; this doesn't.

**Separate API guide** — The Gemini API details are reference material, not core instructions. Keeping them in a supporting file keeps the SKILL.md focused on the workflow.

## Note on API key

The `GEMINI_API_KEY` stays in the environment — never hardcode it in the skill.
