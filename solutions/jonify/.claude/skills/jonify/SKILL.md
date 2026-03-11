---
name: jonify
description: "Transforms an image into Jonny's cartoon drawing style using Gemini image generation. Use when the user wants to stylize, jonify, or redraw an image in Jonny's style."
allowed-tools: Bash, Read
---

# Jonify

Input image: `$ARGUMENTS`
Style samples: `${CLAUDE_SKILL_DIR}/reference/style-samples/`

Run this script with `python3 -c` to perform the style transfer. Do not modify it.

```python
import sys, os, json, base64, urllib.request
from pathlib import Path

input_image = sys.argv[1]
style_dir = sys.argv[2]
output_path = sys.argv[3] if len(sys.argv) > 3 else "jonified-output.png"

api_key = os.environ["GEMINI_API_KEY"]

def enc(path):
    mime = "image/png" if str(path).endswith(".png") else "image/jpeg"
    return {"inline_data": {"mime_type": mime, "data": base64.b64encode(Path(path).read_bytes()).decode()}}

style_images = sorted(p for p in Path(style_dir).iterdir() if p.suffix.lower() in (".png", ".jpg", ".jpeg", ".webp"))
if not style_images:
    print(f"No style samples in {style_dir}", file=sys.stderr); sys.exit(1)

parts = [{"text": "Here are examples of a specific drawing style. Redraw the last image in this exact same style, keeping the subject but matching the aesthetic of the examples."}]
for img in style_images:
    parts.append(enc(str(img)))
parts.append(enc(input_image))

req = urllib.request.Request(
    f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key={api_key}",
    data=json.dumps({"contents": [{"parts": parts}], "generationConfig": {"responseModalities": ["TEXT", "IMAGE"]}}).encode(),
    headers={"Content-Type": "application/json"})

resp = json.loads(urllib.request.urlopen(req).read())
for part in resp["candidates"][0]["content"]["parts"]:
    if "inlineData" in part:
        Path(output_path).write_bytes(base64.b64decode(part["inlineData"]["data"]))
        print(f"Saved to {output_path}"); sys.exit(0)
print("No image in response", file=sys.stderr); sys.exit(1)
```

Pass the arguments:
```
python3 -c '<script above>' "$ARGUMENTS" "${CLAUDE_SKILL_DIR}/reference/style-samples/" jonified-output.png
```

Do NOT read, echo, or log the GEMINI_API_KEY value.

After the script runs, tell the user where the output was saved.
