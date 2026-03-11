locals {
  project_name = "hackathon"

  # Bedrock inference profiles to allow
  inference_profile_names = [
    "EU Anthropic Claude Opus 4.6",
    "EU Anthropic Claude Sonnet 4.6",
    "EU Anthropic Claude Haiku 4.5",
  ]

  inference_profiles = [
    for profile in data.aws_bedrock_inference_profiles.this.inference_profile_summaries : profile
    if contains(local.inference_profile_names, profile.inference_profile_name)
  ]

  inference_profile_arns = [
    for profile in local.inference_profiles : profile.inference_profile_arn
  ]

  foundation_model_arns = flatten([
    for profile in local.inference_profiles : [for model in profile.models : model.model_arn]
  ])
}
