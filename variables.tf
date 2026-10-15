variable "aws_region" {
  type        = string
  description = "AWS region for resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for public subnets"
}

variable "public_subnet_names" {
  type        = list(string)
  description = "Names for public subnets"
}

variable "igw_name" {
  type        = string
  description = "Name for the Internet Gateway"
}

variable "route_table_name" {
  type        = string
  description = "Name for the public route table"
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
  description = "Allowed IP ranges for SSH and HTTP"
}

variable "launch_template_name" {
  type        = string
  description = "Name for the Launch Template"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "asg_name" {
  type        = string
  description = "Name for the Auto Scaling Group"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity of ASG"
}

variable "min_size" {
  type        = number
  description = "Minimum size of ASG"
}

variable "max_size" {
  type        = number
  description = "Maximum size of ASG"
}

variable "lb_name" {
  type        = string
  description = "Name for the Application Load Balancer"
}

variable "tg_name" {
  type        = string
  description = "Name for the Target Group"
}
