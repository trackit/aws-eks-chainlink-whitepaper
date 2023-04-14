variable "kms_key_id" {
  type = string
}

variable "env" {
  type = string
  default = "example"
}

variable "name" {
  type = string
  default = "chainlink"
}

variable "chainlink_eth_chain_id" {
  type = string
  default = "4"
}

variable "chainlink_dev" {
  type = string
  default = "true"
}

variable "aws_auth_roles" {
  type = list(object({
    rolearn  = string # AWS Role
    username = string # Username in Kubernetes
    groups   = list(string) # Group in Kubernetes
  }))

  default = [
    {
      rolearn  = "fake_role_arn"
      username = "fake_username"
      groups   = ["system:masters"]
    }
  ]
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string # AWS User
    username = string # Username in Kubernetes
    groups   = list(string) # Group in Kubernetes
  }))

  default = [
    {
      userarn  = "fake_user_arn"
      username = "fake_username"
      groups   = ["system:masters"]
    }
  ]
}

variable "vpc_cidr" {
  type = string
  default     = "10.10.0.0/16"
}

variable "vpc_azs" {
  type = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "vpc_private_cidrs" {
  type = list(string)
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}

variable "vpc_public_cidrs" {
  type = list(string)
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "vpc_database_cidrs" {
  type = list(string)
  default = ["10.10.200.0/24", "10.10.201.0/24"]
}

variable "rds_instance_type" {
  type = string
  default = "db.r6g.large"
}

variable "eth_url" {
  type = string
}

variable "chainlink_domain_name" {
  type = string
  default = "chainlink.example.com"
}

variable "p2p_bootstrap_peers" {
  type = string
  default = ""
}

variable "chainlink_acm_certificate_arn" {
  type = string
  default = "fake-acm-chainlink"
}

variable "user_email" {
  type = string
  default = "user@example.com"
}
