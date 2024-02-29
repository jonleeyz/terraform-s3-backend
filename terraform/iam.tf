resource "aws_iam_policy" "terraform_s3_state_store" {
  name   = "terraformS3StateStorePolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.terraform_s3_state_store_policy.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_policy" "account_wide_terraform_support" {
  name   = "accountWideTerraformSupportPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.account_wide_terraform_support_policy.json
}

resource "aws_iam_role" "account_wide_terraform_support" {
  name               = "accountWideTerraformSupportRole"
  assume_role_policy = data.aws_iam_policy_document.assume_account_wide_terraform_support_role.json
  managed_policy_arns = [
    aws_iam_policy.terraform_s3_state_store.arn,
    aws_iam_policy.account_wide_terraform_support.arn
  ]
}

output "ci_iam_role_arn" {
  description = "The ARN of the IAM role that the repo's CI workflow will attempt to assume"
  value = aws_iam_role.account_wide_terraform_support.arn
}
