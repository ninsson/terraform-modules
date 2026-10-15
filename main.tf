module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  public_subnet_names = var.public_subnet_names
  igw_name            = var.igw_name
  route_table_name    = var.route_table_name
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id               = module.network.vpc_id
  ssh_sg_name          = var.ssh_sg_name
  public_http_sg_name  = var.public_http_sg_name
  private_http_sg_name = var.private_http_sg_name
  allowed_ip_range     = var.allowed_ip_range
}

module "application" {
  source = "./modules/application"

  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.public_subnet_ids
  ssh_sg_id            = module.network_security.ssh_sg_id
  private_http_sg_id   = module.network_security.private_http_sg_id
  public_http_sg_id    = module.network_security.public_http_sg_id
  instance_type        = var.instance_type
  launch_template_name = var.launch_template_name
  asg_name             = var.asg_name
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  lb_name              = var.lb_name
  tg_name              = var.tg_name
}
