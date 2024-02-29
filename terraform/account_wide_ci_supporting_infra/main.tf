resource "aws_iam_openid_connect_provider" "github" {
  url = "https://${var.github_oidc_provider_url}"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612"]

  lifecycle {
    prevent_destroy = true
  }
}

output "github_iam_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}
