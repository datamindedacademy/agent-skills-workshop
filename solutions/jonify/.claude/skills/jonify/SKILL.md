---
name: jonify
description: "Transforms a drawing or image into Jonny's cartoon style using Google Gemini image generation."
allowed-tools: Bash, Read
---

# Jonify — Style Transfer

Transform the input image at `$ARGUMENTS` into Jonny's distinctive drawing style.

## Style Reference

Style sample images are in: `${CLAUDE_SKILL_DIR}/reference/style-samples/`

## Process

Run the jonify script — it handles the API call and key internally:

```
python3 ${CLAUDE_SKILL_DIR}/reference/jonify.py "$ARGUMENTS" "${CLAUDE_SKILL_DIR}/reference/style-samples/" jonified-output.png
```

Do NOT construct API calls yourself or read/use the API key. The script handles all of that.

## Output

Tell the user:
- Where the output file was saved
- Briefly describe what the generated image looks like (read the output file)
