---
name: jonnify
# TODO 1: Write a description. Third person. Include what it does AND when to trigger it.
# Hint: "Use when the user wants to..."
description: ""
# TODO 5: Set allowed-tools. Claude needs to run python and read files.
---

# Jonnify

<!-- TODO 2: Accept the input image path from $ARGUMENTS and point to the style samples dir. -->
<!-- Style samples are in ${CLAUDE_SKILL_DIR}/reference/style-samples/ -->

<!-- TODO 3: Write a Python script inline that Claude runs with `python3 -c`. -->
<!-- The script should: -->
<!--   - Take input image, style samples dir, and output path from sys.argv -->
<!--   - Read the API key from os.environ["GEMINI_API_KEY"] (never log it) -->
<!--   - Base64-encode style samples + input image -->
<!--   - Send them to the Gemini API (see reference/gemini-api-guide.md for format) -->
<!--   - Extract and save the generated image from the response -->
<!-- Use LOW freedom here — the API call is fragile, give Claude the exact script. -->

<!-- TODO 4: Tell Claude what to report after the script runs. -->
<!-- Also: if the script fails because GEMINI_API_KEY isn't set, tell the user to set it. -->
<!-- Do NOT search for .env files or try to source the key yourself. -->
