export AWS_BUCKET_NAME="jl-terraform-remote-state-store"
export AWS_BUCKET_KEY_NAME="account-wide-terraform-support/terraform.tfstate"
export AWS_REGION="ap-southeast-1"

terraform init -migrate-state -backend-config="bucket=${AWS_BUCKET_NAME}" -backend-config="key=${AWS_BUCKET_KEY_NAME}" -backend-config="region=${AWS_REGION}"
