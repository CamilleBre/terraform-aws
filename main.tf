
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# appel du modules networking
module "networking" {
  source = "./modules/networking"
  sg_application_lb_id = module.security.sg_application_lb_id
  datascientest_a_id = module.ec2.datascientest_a_id
  datascientest_b_id = module.ec2.datascientest_b_id
  web_server_a_id = module.autoscaling.web_server_a_id
  web_server_b_id = module.autoscaling.web_server_b_id
}

# appel du modules ec2
module "ec2" {
  source          = "./modules/ec2"
  app_subnet_a_id = module.networking.app_subnet_a_id
  app_subnet_b_id = module.networking.app_subnet_b_id
  sg_id           = module.security.sg_id
  ec2_key_name    = module.security.ec2_key_name
}

module "bastion" {
  source             = "./modules/bastion"
  public_subnet_a_id = module.networking.public_subnet_a_id
  sg22_id            = module.security.sg22_id
  ec2_key_name       = module.security.ec2_key_name
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
  public_subnet_a_id = module.networking.public_subnet_a_id
  public_subnet_b_id = module.networking.public_subnet_b_id
}

module "autoscaling" {
  source = "./modules/autoscaling"
  min_instances = 1 
  max_instances = 2
  public_subnet_a_id = module.networking.public_subnet_a_id
  public_subnet_b_id = module.networking.public_subnet_b_id
  datascientest_a_name = module.ec2.datascientest_a_name
  datascientest_b_name = module.ec2.datascientest_b_name
}

module "database" {
  source = "./modules/database"
  sg_rds = module.security.sg_rds
  username = var.username
  password = var.password
}