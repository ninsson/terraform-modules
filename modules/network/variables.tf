variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
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
  description = "Name tags for public subnets"
}

variable "igw_name" {
  type        = string
  description = "Name tag for the Internet Gateway"
}

variable "route_table_name" {
  type        = string
  description = "Name tag for the public route table"
}
