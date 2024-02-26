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
