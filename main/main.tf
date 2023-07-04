provider "aws" {
  region                       = "${var.region}"
}

module "vpc" {
  name                         = "${var.vpc_name}"
  source                       = "../modules/vpc"
  vpc-cidr                     = "${var.vpc-cidr}"
  namespace                    = "${var.namespace}"
  vpc-location                 = "${var.vpc-location}"
  cluster-name                 = "${var.namespace}-eks-cluster"
  use_existing_vpc             = "${var.use_existing_vpc}"
  vpc-public-subnet-cidr       = "${var.public_cidr}"
  vpc-private-subnet-cidr      = "${var.private_cidr}"
  map_public_ip_on_launch      = "${var.map_public_ip_on_launch}"
}


module "instances" {
  name                         = "${var.vpc_name}"
  source                       = "../modules/instances"
  instance_type                = "${var.instance_type}"
  ami                          = "${var.ami}"
  subnet_id                    = module.vpc.private_subnet_ids[0]
  security_groups              = [module.vpc.app_sg_id]
}
