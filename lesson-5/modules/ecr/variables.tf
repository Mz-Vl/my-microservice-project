variable "ecr_name" {
  description = "Name of ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Enable scan on push"
  type        = bool
  default     = true
}
