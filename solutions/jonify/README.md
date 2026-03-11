# Solution: Jonify

## Design choices

**Description with trigger** — "Transforms an image... Use when the user wants to stylize, jonify, or redraw..." Third person, says what AND when. Claude picks from potentially 100+ skills based on this field alone.

**Inline script with low freedom** — The Gemini API call is fragile. One wrong field and it fails. So we give Claude the exact script — no improvisation. This follows the "narrow bridge" principle from the best practices.

**`python3 -c` instead of temp file** — Claude can run Python directly. No file management overhead.

**API key stays in `os.environ`** — Claude sees `os.environ["GEMINI_API_KEY"]` in the code but never the actual value. The instruction "Do NOT read, echo, or log the GEMINI_API_KEY" adds a guardrail.

**Style samples as images** — Showing beats telling. Sending actual drawings as reference works better than describing "wobbly lines and primary colors."

**`allowed-tools: Bash, Read`** — Bash runs the script. Read lets Claude view the output image. Nothing else needed.
