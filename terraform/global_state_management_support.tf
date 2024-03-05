########
### - The following infrastructure are provisioned to enable Terraform state management in S3.
### - The S3 bucket stores Terraform state files. 
### - Multiple workspaces can make use of this bucket; ensure the key for the state file is unique for each workspace.
### - The DynamoDB table enables state locking.
### - The IAM policy can be attached to any appropriate IAM user or role to allow them to manage Terraform state in S3.
### - The Open ID Connect IAM Provider allows GitHub pushes and PRs to trigger `terraform plan` and `apply`.
########


resource "aws_s3_bucket" "terraform_state_store" {
  bucket = "jl-terraform-remote-state-store"
}

resource "aws_s3_bucket_versioning" "terraform_state_store" {
  bucket = aws_s3_bucket.terraform_state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://${local.github_oidc_provider_url}"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612"]
}

output "terraform_state_store_bucket_arn" {
  value       = aws_s3_bucket.terraform_state_store.arn
  description = "The ARN of the provisioned S3 bucket that will store state for all Terraform workspaces associated with this AWS account"
}

output "terraform_state_lock_table_arn" {
  value       = aws_dynamodb_table.terraform_state_lock.arn
  description = "The ARN of the provisioned DynamoDB table that will perform state locking for all Terraform workspaces associated with this AWS account"
}

output "oidc_iam_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "The ARN of the provisioned OpenID Connect IAM Provider that will allow requests from GitHub to assume IAM roles"
}

