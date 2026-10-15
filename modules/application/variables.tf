variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for ALB and ASG"
}

variable "ssh_sg_id" {
  type        = string
  description = "Security group ID for SSH"
}

variable "private_http_sg_id" {
  type        = string
  description = "Security group ID for instances (private HTTP)"
}

variable "public_http_sg_id" {
  type        = string
  description = "Security group ID for ALB (public HTTP)"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "launch_template_name" {
  type        = string
  description = "Name of the Launch Template"
}

variable "asg_name" {
  type        = string
  description = "Name of the Auto Scaling Group"
}

variable "lb_name" {
  type        = string
  description = "Name of the Application Load Balancer"
}

variable "tg_name" {
  type        = string
  description = "Name of the Target Group"
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
