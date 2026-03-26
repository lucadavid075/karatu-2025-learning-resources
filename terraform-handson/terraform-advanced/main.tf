terraform {
  required_version = ">= 1.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}


# Using Local Module


module "local_module_vpc" {
  source             = "./vpc"
  vpc_name           = "local-module-vpc"
  vpc_cidr           = "89.207.0.0/16"
  public_subnet_cidr = "89.207.132.0/24"
  availability_zone  = "us-east-1a"
}

module "local_module_vpc_2" {
  source             = "./vpc"
  vpc_name           = "local-module-vpc_2"
  vpc_cidr           = "70.207.0.0/16"
  public_subnet_cidr = "70.207.132.0/24"
  availability_zone  = "us-east-1b"
}

# module.loca_module_vpc.vpc_id


# Remote modules

module "vpc_from_registry" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2" # Always pin to a specific version

#   # Basic configuration
   name = "my-vpc-from-registry"
   cidr = "10.0.0.0/16"

   # Subnets across availability zones
   azs             = ["us-east-1a", "us-east-1b"]
   public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

#   # Enable NAT Gateway for private subnets
   enable_nat_gateway = false
   single_nat_gateway = true # Use one NAT for cost savings in dev

#   # DNS settings
   enable_dns_hostnames = true
   enable_dns_support   = true

   # Tags
   tags = {
     Environment = "dev"
     ManagedBy   = "terraform"
   }

   public_subnet_tags = {
     Type = "public"
   }

   private_subnet_tags = {
     Type = "private"
   }
}

# # Access outputs from the registry module
# output "registry_vpc_id" {
#   description = "VPC ID from registry module"
#   value       = module.vpc_from_registry.vpc_id
# }

# output "registry_public_subnets" {
#   description = "Public subnet IDs from registry module"
#   value       = module.vpc_from_registry.public_subnets
# }

# output "registry_private_subnets" {
#   description = "Private subnet IDs from registry module"
#   value       = module.vpc_from_registry.private_subnets
# }

# output "registry_nat_gateway_ids" {
#   description = "NAT Gateway IDs"
#   value       = module.vpc_from_registry.natgw_ids
# }
