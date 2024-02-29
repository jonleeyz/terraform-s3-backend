data "aws_iam_policy_document" "account_wide_terraform_support_policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
    ]

    resources = [
      var.github_iam_oidc_provider_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_account_wide_terraform_support_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "${var.github_oidc_provider_url}:sub"
      values = [
        "repo:jonleeyz/terraform-backend:*",
      ]
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::574182556674:oidc-provider/${var.github_oidc_provider_url}"]
    }
  }
}
