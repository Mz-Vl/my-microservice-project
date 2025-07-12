output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "ECR repo URL"
  value       = module.ecr.repository_url
}

output "s3_backend_bucket" {
  description = "S3 backend bucket name"
  value       = module.s3_backend.bucket_name
}
