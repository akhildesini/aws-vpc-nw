provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source        = "./modules/vpc"
  vpc_cidr      = "10.0.0.0/16"
  az_count      = 3
  env           = var.env
}

module "nat" {
  source         = "./modules/nat_gateway"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  azs            = module.vpc.azs
  env            = var.env
}

module "firewall" {
  source               = "./modules/firewall"
  vpc_id               = module.vpc.vpc_id
  firewall_subnet_ids  = module.vpc.firewall_subnet_ids
  env                  = var.env
}

module "routes" {
  source                = "./modules/routes"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  firewall_endpoint_ids = module.firewall.endpoint_ids
  nat_gateway_ids       = module.nat.nat_gateway_ids
  azs                   = module.vpc.azs
  env                   = var.env
}

