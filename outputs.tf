output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "ECR repo URL"
  value       = module.ecr.repository_url
}

# output "s3_backend_bucket" {
#   value       = module.s3_backend.bucket_name
#   description = "S3 bucket used for terraform state storage"
# }

output "ebs_csi_driver_role" {
  value = module.eks.ebs_csi_driver_role
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
