resource "aws_s3_bucket" "terraform_state_store" {
  bucket = "jl-terraform-remote-state-store"
}

resource "aws_s3_bucket_versioning" "terraform_state_store" {
  bucket = aws_s3_bucket.terraform_state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}
