# Gemini Image Generation API

## Models

| Model | Use case |
|---|---|
| `gemini-2.5-flash-image` | Fast, low-latency |
| `gemini-3.1-flash-image-preview` | High-efficiency, high-volume |
| `gemini-3-pro-image-preview` | Best quality, advanced reasoning |

Use `gemini-2.5-flash-image` for this exercise. Good enough and fast.

## Auth

Set `GEMINI_API_KEY` as an environment variable.

## Curl example

```bash
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: $GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {"text": "YOUR PROMPT HERE"},
        {
          "inline_data": {
            "mime_type": "image/png",
            "data": "'$(base64 -i INPUT_IMAGE_PATH)'"
          }
        }
      ]
    }],
    "generationConfig": {
      "responseModalities": ["TEXT", "IMAGE"]
    }
  }'
```

## Sending multiple images

To send style reference images alongside the input, add multiple `inline_data` parts:

```json
{
  "contents": [{
    "parts": [
      {"text": "Here are examples of a drawing style. Redraw the last image in this style."},
      {"inline_data": {"mime_type": "image/png", "data": "STYLE_IMAGE_1_BASE64"}},
      {"inline_data": {"mime_type": "image/png", "data": "STYLE_IMAGE_2_BASE64"}},
      {"inline_data": {"mime_type": "image/png", "data": "INPUT_IMAGE_BASE64"}}
    ]
  }],
  "generationConfig": {
    "responseModalities": ["TEXT", "IMAGE"]
  }
}
```

## Extracting the output image

The response has `candidates[0].content.parts`. Find the part with `inlineData`:

```bash
# Pipe the curl response to this:
python3 -c "
import sys, json, base64
resp = json.load(sys.stdin)
for part in resp['candidates'][0]['content']['parts']:
    if 'inlineData' in part:
        img = base64.b64decode(part['inlineData']['data'])
        with open('output.png', 'wb') as f:
            f.write(img)
        print('Saved to output.png')
        break
"
```

## Python example

```python
import os, json, base64, requests
from pathlib import Path

API_KEY = os.environ["GEMINI_API_KEY"]
MODEL = "gemini-2.5-flash-image"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent"

def encode_image(path):
    return base64.b64encode(Path(path).read_bytes()).decode()

parts = [
    {"text": "YOUR PROMPT HERE"},
    {"inline_data": {"mime_type": "image/png", "data": encode_image("input.png")}}
]

resp = requests.post(
    URL,
    headers={"x-goog-api-key": API_KEY, "Content-Type": "application/json"},
    json={
        "contents": [{"parts": parts}],
        "generationConfig": {"responseModalities": ["TEXT", "IMAGE"]}
    }
).json()

for part in resp["candidates"][0]["content"]["parts"]:
    if "inlineData" in part:
        Path("output.png").write_bytes(base64.b64decode(part["inlineData"]["data"]))
        print("Saved to output.png")
        break
```
