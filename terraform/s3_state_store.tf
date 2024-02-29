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

output "state_store_bucket_name" {
  description = "The bucket name of the account-wide Terraform state store S3 bucket"
  value = aws_s3_bucket.terraform_state_store.bucket
}

output "state_lock_table_name" {
  description = "The bucket name of the account-wide Terraform state locking DynamoDB table"
  value = aws_dynamodb_table.terraform_state_lock.name
}
