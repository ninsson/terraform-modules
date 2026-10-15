variable "vpc_id" {
  type        = string
  description = "The VPC ID where security groups will be created"
}

variable "ssh_sg_name" {
  type        = string
  description = "Name for the SSH security group"
}

variable "public_http_sg_name" {
  type        = string
  description = "Name for the Public HTTP security group"
}

variable "private_http_sg_name" {
  type        = string
  description = "Name for the Private HTTP security group"
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "Allowed IP CIDR blocks for SSH and Public HTTP access"
}
