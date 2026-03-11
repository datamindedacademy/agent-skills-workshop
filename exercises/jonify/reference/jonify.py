#!/usr/bin/env python3
"""
Calls the Gemini image generation API to transform an image
into a target style using reference images.

Usage:
    python3 jonify.py <input_image> <style_samples_dir> [output_path]

The GEMINI_API_KEY env var must be set.
"""
import sys
import os
import json
import base64
import urllib.request
from pathlib import Path

MODEL = "gemini-2.5-flash-image"
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent"


def encode_image(path):
    data = Path(path).read_bytes()
    mime = "image/png" if path.endswith(".png") else "image/jpeg"
    return {"inline_data": {"mime_type": mime, "data": base64.b64encode(data).decode()}}


def main():
    if len(sys.argv) < 3:
        print("Usage: python3 jonify.py <input_image> <style_samples_dir> [output_path]")
        sys.exit(1)

    input_image = sys.argv[1]
    style_dir = sys.argv[2]
    output_path = sys.argv[3] if len(sys.argv) > 3 else "jonified-output.png"

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY env var not set", file=sys.stderr)
        sys.exit(1)

    if not Path(input_image).exists():
        print(f"Error: Input image not found: {input_image}", file=sys.stderr)
        sys.exit(1)

    # Collect style samples
    style_images = sorted(
        p for p in Path(style_dir).iterdir()
        if p.suffix.lower() in (".png", ".jpg", ".jpeg", ".webp")
    )

    if not style_images:
        print(f"Error: No images found in {style_dir}", file=sys.stderr)
        sys.exit(1)

    # Build parts: prompt + style samples + input image
    parts = [
        {"text": (
            "Here are examples of a specific drawing style. "
            "Redraw the last image in this exact same style, "
            "keeping the subject but matching the aesthetic of the example drawings."
        )}
    ]
    for img in style_images:
        parts.append(encode_image(str(img)))
    parts.append(encode_image(input_image))

    payload = json.dumps({
        "contents": [{"parts": parts}],
        "generationConfig": {"responseModalities": ["TEXT", "IMAGE"]}
    }).encode()

    req = urllib.request.Request(
        f"{API_URL}?key={api_key}",
        data=payload,
        headers={"Content-Type": "application/json"},
    )

    print(f"Calling Gemini API with {len(style_images)} style samples...")
    resp = urllib.request.urlopen(req)
    result = json.loads(resp.read())

    # Extract generated image
    for part in result["candidates"][0]["content"]["parts"]:
        if "inlineData" in part:
            img_data = base64.b64decode(part["inlineData"]["data"])
            Path(output_path).write_bytes(img_data)
            print(f"Saved to {output_path}")
            return

    print("Error: No image in API response", file=sys.stderr)
    sys.exit(1)


if __name__ == "__main__":
    main()
