variable "name" {
  description = "Name Helm-release"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "version Argo CD"
  type        = string
  default     = "5.46.4"
}