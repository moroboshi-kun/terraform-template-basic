## ----- backend/variables.tf ----- ##

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-terraform-project"
  
}

variable "aws_region" {
  description = "The AWS region where the S3 bucket is located"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
} 

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
}   

