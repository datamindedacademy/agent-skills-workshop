variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "participants" {
  type        = list(string)
  description = "Email addresses of the workshop participants to invite as Conveyor users"
}
