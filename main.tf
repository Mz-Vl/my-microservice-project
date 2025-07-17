provider "aws" {
  region = "eu-central-1"
}

module "s3_backend" {
  source         = "./modules/s3-backend"
  bucket_name    = "lesson5-tfstate-bucket"
  table_name     = "terraform-locks"
  region         = var.region
  project_prefix = var.project_prefix
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson5-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson5-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "lesson5-eks-cluster"
  subnet_ids      = module.vpc.public_subnet_ids
  instance_type   = "t3.small"
  desired_size    = 2
  min_size        = 1
  max_size        = 3
}

data "aws_eks_cluster" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {}

module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_pat        = var.github_pat
  github_user       = var.github_user
  github_repo_url   = var.github_repo_url
  depends_on        = [module.eks]
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"
  depends_on    = [module.eks]
}

module "rds" {
  source = "./modules/rds"

  name                       = "lesson5-db"
  use_aurora                 = false
  aurora_instance_count      = 2

  engine                     = "postgres"
  engine_version             = "15.4"
  parameter_group_family_rds = "postgres15"

  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "lesson5"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections            = "150"
    log_min_duration_statement = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "lesson5"
  }
}
