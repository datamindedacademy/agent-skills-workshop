---
name: jonify
description: "Transforms a drawing or image into Jonny's cartoon style using Google Gemini image generation."
allowed-tools: Bash, Read, Write
---

# Jonify — Style Transfer

Transform the input image at `$ARGUMENTS` into Jonny's distinctive drawing style.

## Style Reference

The reference drawings showing Jonny's style are in:
`${CLAUDE_SKILL_DIR}/reference/style-samples/`

Read the style guide for usage instructions:
`${CLAUDE_SKILL_DIR}/reference/style-guide.md`

## Process

1. Read the input image at the path provided in `$ARGUMENTS`
2. Collect all images from `${CLAUDE_SKILL_DIR}/reference/style-samples/`
3. Call the Gemini API to generate a styled version:
   - Use model `gemini-2.5-flash-image`
   - Base64-encode all style sample images and the input image
   - Send style samples as `inlineData` parts first, then the input image last
   - Use a prompt like: "Here are examples of a specific drawing style. Redraw the last image in this exact same style, keeping the subject but matching the aesthetic of the example drawings."
   - Set `responseModalities: ["TEXT", "IMAGE"]`
4. Extract the generated image from the response (look for `inlineData` in response parts)
5. Decode the base64 data and save as `jonified-output.png` in the current working directory

Use the API key from the `GEMINI_API_KEY` environment variable.

See `${CLAUDE_SKILL_DIR}/reference/gemini-api-guide.md` for curl and Python examples.

## Output

After saving the image, tell the user:
- Where the output file was saved
- Briefly describe what the generated image looks like
