resource "aws_secretsmanager_secret" "gemini_api_key" {
  name = "hackandbeers/gemini-api-key"
}
