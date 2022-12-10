terraform {
  backend "s3" {
  region = "us-east-1"
  bucket = "main-tf-state-310257323767"
  key = "state-main.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source               = "./module/vpc"
  private_subnet_cidrs = ["10.0.0.96/27", "10.0.0.128/27", "10.0.0.160/27"]
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs  = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
}

module "database" {
  source               = "./module/rds"
  vpc_id               = module.networking.vpc_id
  subnet_ids           = [module.networking.public_subnet-b, module.networking.public_subnet-a, module.networking.public_subnet-c]
}

module "ec2-bake"{
     source               = "./module/bake-ec2"
     vpc_id               = module.networking.vpc_id
     database_endpoint    = module.database.endpoint
     subnet_id            = module.networking.public_subnet-a
}

module "alb"{
  source               = "./module/alb"
  vpc_id               = module.networking.vpc_id
  sg_ec2               = module.ec2-bake.sg
  subnet_ids           = [module.networking.public_subnet-b, module.networking.public_subnet-a, module.networking.public_subnet-c]
}

output "ALB-output" {
  value       = module.alb.loadbalancer
  description = "The private IP address of the main server instance."
}

 
#  resource "aws_autoscaling_group" "bar" {
#   desired_capacity   = 1
#   max_size           = 10
#   min_size           = 1
#   target_group_arns  = [aws_lb_target_group.petclinic.id]
#   vpc_zone_identifier= [module.networking.public_subnet-b, module.networking.public_subnet-a, module.networking.public_subnet-c]

#   launch_template {
#     id      = "lt-051c1af5d0fe8dadb"
#     version = "$Latest"
#   }
# }