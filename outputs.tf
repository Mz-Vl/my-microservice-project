# ─────────────── S3 & DynamoDB ───────────────
output "s3_bucket_name" {
  description = "Name S3-bucket for save states"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Name DynamoDB for blocking Terraform states"
  value       = module.s3_backend.dynamodb_table_name
}

# ─────────────── VPC ───────────────
output "vpc_id" {
  description = "ID created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of ID for public subnets"
  value       = module.vpc.public_subnet_ids
}

# ─────────────── ECR ───────────────
output "ecr_url" {
  description = "URL ECR repository"
  value       = module.ecr.repository_url
}

# ─────────────── EKS ───────────────
output "eks_cluster_name" {
  description = "Name of EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint connection to cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_role_arn" {
  description = "ARN roles IAM for EKS workers"
  value       = module.eks.eks_node_role_arn
}

output "ebs_csi_driver_role" {
  description = "IAM role for Amazon EBS CSI Driver"
  value       = module.eks.ebs_csi_driver_role
}

# ─────────────── Jenkins ───────────────
output "jenkins_release" {
  description = "Name of Helm-release Jenkins"
  value       = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  description = "Kubernetes namespace, with Jenkins"
  value       = module.jenkins.jenkins_namespace
}

# ─────────────── RDS ───────────────
output "rds_endpoint" {
  description = "Endpoint бази даних RDS"
  value       = module.rds.rds_endpoint
}
