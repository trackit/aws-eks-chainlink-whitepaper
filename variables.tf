variable "kms_key_id" {
  type = string
}

variable "env" {
  type = string
  default = "article"
}

variable "name" {
  type = string
  default = "chainlink"
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

variable "role_arn" {
  type = string
}

variable "username" {
  type = string
}

variable "user_arn" {
  type = string
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
  default = "fake-p2p"
}

variable "chainlink_acm_certificate_arn" {
  type = string
  default = "fake-acm-chainlink"
}

variable "user_email" {
  type = string
  default = "user@example.com"
}

