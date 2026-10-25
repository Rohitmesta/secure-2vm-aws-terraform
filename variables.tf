variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region for the lab."
}

variable "project_name" {
  type        = string
  default     = "secure-2vm-lab"
  description = "Prefix used for resource names."
}

variable "admin_cidr" {
  type        = string
  description = "Your current public IPv4 address in CIDR notation, e.g. 203.0.113.10/32. Restrict RDP to this address."
}

variable "windows_instance_type" {
  type    = string
  default = "t3.small"
}

variable "linux_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_pair_name" {
  type    = string
  default = "secure-2vm-lab-key"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.20.2.0/24"
}
