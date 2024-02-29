resource "aws_iam_policy" "terraform_s3_state_store" {
  name   = "terraformS3StateStorePolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.terraform_s3_state_store_policy.json

  lifecycle {
    prevent_destroy = true
  }
}
