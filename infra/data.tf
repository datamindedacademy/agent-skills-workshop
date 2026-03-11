data "aws_eks_cluster" "this" {
  name = "datafy-dp-eks-rm-prd"
}

data "aws_iam_openid_connect_provider" "cluster" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0]["issuer"]
}

data "aws_bedrock_inference_profiles" "this" {
  type = "SYSTEM_DEFINED"
}
