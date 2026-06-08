# IAM role for the workshop project (assumed by Conveyor workloads at runtime)
resource "aws_iam_role" "workshop" {
  name               = "product-${local.project_name}"
  assume_role_policy = data.aws_iam_policy_document.workshop_trust.json
}

data "aws_iam_policy_document" "workshop_trust" {
  statement {
    sid     = "ConveyorWorkerAssumeRoleWebIdentity"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0]["issuer"], "https://", "")}:sub"
      values = [
        "system:serviceaccount:${conveyor_environment.workshop.name}:${local.project_name}-????????-????-????-????-????????????"
      ]
    }

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.cluster.arn]
    }
  }
}

# Bedrock access policy for the workshop role
data "aws_iam_policy_document" "bedrock" {
  statement {
    sid    = "AllowModelAndInferenceProfileAccess"
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]
    resources = concat(local.foundation_model_arns, local.inference_profile_arns)
    condition {
      test     = "StringLike"
      variable = "aws:RequestedRegion"
      values   = ["eu-*"]
    }
  }

  statement {
    sid    = "AllowMarketplaceSubscription"
    effect = "Allow"
    actions = [
      "aws-marketplace:ViewSubscriptions",
      "aws-marketplace:Subscribe"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:CalledViaLast"
      values   = ["bedrock.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "bedrock" {
  name   = "bedrock"
  role   = aws_iam_role.workshop.id
  policy = data.aws_iam_policy_document.bedrock.json
}
