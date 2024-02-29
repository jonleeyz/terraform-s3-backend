module "account_wide_ci_supporting_infra" {
  source                   = "./account_wide_ci_supporting_infra"
  github_oidc_provider_url = local.github_oidc_provider_url
}

module "repo_ci" {
  source                            = "./repo_ci"
  github_oidc_provider_url          = local.github_oidc_provider_url
  github_iam_oidc_provider_arn      = module.account_wide_ci_supporting_infra.github_iam_oidc_provider_arn
  terraform_state_management_policy = aws_iam_policy.terraform_s3_state_store.arn
}
