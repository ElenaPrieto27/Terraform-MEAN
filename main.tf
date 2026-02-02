module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "compute_app" {
  source = "./modules/compute_app"

  subnet_id         = module.network.public_subnet_ids[0]
  security_group_id = module.security.app_sg_id
}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_sg_id
  app_instance_id       = module.compute_app.instance_id
}
