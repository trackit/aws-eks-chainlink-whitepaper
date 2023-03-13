locals {
  tags = {
    Name = "chainlink-article"
    Owner = "jean-gael"
    Project = "chainlink"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v3.10.0"

  name             = "${var.name}-${var.env}"
  cidr             = var.vpc_cidr
  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_cidrs
  public_subnets   = var.vpc_public_cidrs
  database_subnets = var.vpc_database_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw = true

  tags = merge(local.tags, {
    "kubernetes.io/cluster/${var.name}-${var.env}" = "shared"
  })

  public_subnet_tags = merge(local.tags, {
    "kubernetes.io/cluster/${var.name}-${var.env}" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  })

  private_subnet_tags = merge(local.tags, {
    "kubernetes.io/cluster/${var.name}-${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"              = "1"
  })
}
