# ─────────────── S3 & DynamoDB ───────────────
output "s3_bucket_name" {
  description = "Назва S3-бакета для зберігання стейтів"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування Terraform стейтів"
  value       = module.s3_backend.dynamodb_table_name
}

# ─────────────── VPC ───────────────
output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Список ID публічних підмереж"
  value       = module.vpc.public_subnet_ids
}

# ─────────────── ECR ───────────────
output "ecr_url" {
  description = "URL ECR репозиторію"
  value       = module.ecr.repository_url
}

# ─────────────── EKS ───────────────
output "eks_cluster_name" {
  description = "Назва EKS кластера"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint для підключення до кластера"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_role_arn" {
  description = "ARN ролі IAM для EKS воркерів"
  value       = module.eks.eks_node_role_arn
}

output "ebs_csi_driver_role" {
  description = "IAM роль для Amazon EBS CSI Driver"
  value       = module.eks.ebs_csi_driver_role
}

# ─────────────── Jenkins ───────────────
output "jenkins_release" {
  description = "Назва Helm-релізу Jenkins"
  value       = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  description = "Kubernetes namespace, в якому розгорнуто Jenkins"
  value       = module.jenkins.jenkins_namespace
}

# ─────────────── RDS ───────────────
output "rds_endpoint" {
  description = "Endpoint бази даних RDS"
  value       = module.rds.rds_endpoint
}
