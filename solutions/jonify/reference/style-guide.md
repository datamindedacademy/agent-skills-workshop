# Jonny's Style — Reference Images

The `style-samples/` directory contains example drawings by Jonny.

Use these images as direct style reference when calling the Gemini API. Send them alongside the input image so the model can see the target style rather than relying on a text description.

## How to use them

1. Collect all images from `style-samples/`
2. Base64-encode each one
3. Send them as `inlineData` parts in the API request, before the input image
4. Use a prompt like: "Here are examples of a specific drawing style. Redraw the last image in this exact same style."

## Adding your own samples

Drop more of Jonny's drawings into `style-samples/` to improve style consistency. More examples = better style matching.
