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
