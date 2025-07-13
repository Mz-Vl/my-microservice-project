variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "region" {
  description = "Region for S3 and DynamoDB"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for naming S3 bucket and DynamoDB table"
  type        = string
}
