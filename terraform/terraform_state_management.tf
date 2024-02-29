########
### - The following infrastructure are provisioned to enable Terraform state management in S3.
### - The S3 bucket stores Terraform state files. 
### - Multiple workspaces can make use of this bucket; ensure the key for the state file is unique for each workspace.
### - The DynamoDB table enables state locking.
### - The IAM policy can be attached to any appropriate IAM user or role to allow them to manage Terraform state in S3.
########


resource "aws_s3_bucket" "terraform_state_store" {
  bucket = "jl-terraform-remote-state-store"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_store" {
  bucket = aws_s3_bucket.terraform_state_store.id
  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
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

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_policy" "terraform_s3_state_store" {
  name   = "terraformS3StateStorePolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.terraform_s3_state_store_policy.json

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "terraform_s3_state_store_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.terraform_state_store.arn,
      "${aws_s3_bucket.terraform_state_store.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:ListTables",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      aws_dynamodb_table.terraform_state_lock.arn
    ]
  }
}

output "state_store_bucket_name" {
  description = "The bucket name of the account-wide Terraform state store S3 bucket"
  value       = aws_s3_bucket.terraform_state_store.bucket
}

output "state_lock_table_name" {
  description = "The bucket name of the account-wide Terraform state locking DynamoDB table"
  value       = aws_dynamodb_table.terraform_state_lock.name
}

output "state_management_iam_policy_arn" {
  description = "The ARN of the IAM policy that can be attached to manage Terrform state using the provisioned S3 bucket and DynamoDB table"
  value       = aws_iam_policy.terraform_s3_state_store.arn
}