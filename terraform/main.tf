module "account_wide_ci_supporting_infra" {
  source = "./account_wide_ci_supporting_infra"
  github_oidc_provider_url = local.github_oidc_provider_url
}
