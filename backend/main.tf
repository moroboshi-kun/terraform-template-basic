## ----- /backend/main.tf ----- ##
provider "aws" {
  # Configuration options
  region  = var.aws_region
  profile = aws_profile
}

# add resources here