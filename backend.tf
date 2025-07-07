## ----- backend.tf ----- ##
# Configure the backend for Terraform state management

terraform {
  backend "s3" {}
}