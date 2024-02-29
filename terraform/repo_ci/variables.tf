variable "github_oidc_provider_url" {
  description = "The URL of the GitHub OpenID Connect Provider"
  type        = string
}

variable "github_iam_oidc_provider_arn" {
  description = "The ARN of the GitHub OpenID Connect IAM Provider"
  type        = string
}

variable "terraform_state_management_policy" {
  description = "The ARN of the IAM policy that can be attached to manage Terrform state"
  type        = string
}