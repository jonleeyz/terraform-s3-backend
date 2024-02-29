output "ci_iam_role_arn" {
  description = "The ARN of the IAM role that the repo's CI workflow will attempt to assume"
  value       = module.repo_ci.ci_iam_role_arn
}
