resource "aws_iam_policy" "terraform_state_management" {
  name   = "accountWideTerraformSupport_TerraformStateManagementPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.terraform_state_management_policy.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_policy" "repo_infra" {
  name   = "accountWideTerraformSupport_InfraPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.workspace_infra_policy.json
}

resource "aws_iam_role" "repo_ci" {
  name               = "accountWideTerraformSupport_CIRole"
  assume_role_policy = data.aws_iam_policy_document.assume_account_wide_terraform_support_role.json
  managed_policy_arns = [
    aws_iam_policy.terraform_state_management.arn,
    aws_iam_policy.repo_infra.arn
  ]
}

output "ci_iam_role_arn" {
  description = "The ARN of the IAM role that the repo's CI workflow will attempt to assume"
  value = aws_iam_role.repo_ci.arn
}
