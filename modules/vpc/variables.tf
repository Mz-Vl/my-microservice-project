variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}
