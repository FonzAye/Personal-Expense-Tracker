terraform {

  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "network" {
  source = "../modules/network"

  assign_public_ip = true
}

module "database" {
  source = "../modules/database"

  # Input Variables
  tags = {Name="database"}
  create_secret = false
  subnet_ids = [ module.network.subnet_id_public, module.network.subnet_id_private, module.network.subnet_id_db ]
  vpc_security_group_ids  = [ module.network.vpc_security_group_ids_rds ]
}

module "server" {
  source = "../modules/compute"

  # Input Variables
  instance_type = "t2.micro"
  key_name = "pipi"
  subnet_id = module.network.subnet_id_public
  vpc_security_group_ids = module.network.vpc_security_group_ids_instances
  instance_name = "backend"
  user_data_path = file("./files/create-server.sh")
  create_iam_role = true
  create_eip = true
}

module "client" {
  depends_on = [ module.server ]
  source = "../modules/compute"

  # Input Variables
  instance_type = "t2.micro"
  key_name = "pipi"
  subnet_id = module.network.subnet_id_public
  vpc_security_group_ids = module.network.vpc_security_group_ids_instances
  instance_name = "frontend"
  user_data_path = templatefile("./files/create-client.tpl", {
    backend_ip = module.server.eip
  })
  create_iam_role = false
  create_eip = false
}
