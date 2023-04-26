variable "kms_key_id" {
  type        = string
  description = "Your KMS Key ID for decrypting secrets with SOPS"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  default     = "chainlink"
  description = "The name of the Chainlink deployment"
}

variable "chainlink_eth_chain_id" {
  type        = string
  description = "Your ETH Chain ID"
}

variable "chainlink_dev" {
  type        = string
  default     = "true"
  description = "Whether or not to run Chainlink in dev mode"
}

variable "aws_auth_roles" {
  type = list(object({
    rolearn  = string       # AWS Role
    username = string       # Username in Kubernetes
    groups   = list(string) # Group in Kubernetes
  }))

  default = []

  description = "List of AWS roles to map to Kubernetes users"
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string       # AWS User
    username = string       # Username in Kubernetes
    groups   = list(string) # Group in Kubernetes
  }))

  default     = []
  description = "List of AWS users to map to Kubernetes users"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "VPC CIDR"
}

variable "vpc_azs" {
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
  description = "VPC Availability Zones"
}

variable "vpc_private_cidrs" {
  type        = list(string)
  default     = ["10.10.100.0/24", "10.10.101.0/24"]
  description = "VPC Private Subnets CIDR"
}

variable "vpc_public_cidrs" {
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
  description = "VPC Public Subnets CIDR"
}

variable "vpc_database_cidrs" {
  type        = list(string)
  default     = ["10.10.200.0/24", "10.10.201.0/24"]
  description = "VPC Database Subnets CIDR"
}

variable "rds_instance_type" {
  type        = string
  default     = "db.r6g.large"
  description = "RDS Instance Type (see https://aws.amazon.com/rds/instance-types/)"
}

variable "eth_url" {
  type        = string
  description = "Your WSS ETH URL"
}

variable "chainlink_domain_name" {
  type        = string
  description = "Your Chainlink Domain Name (Route53 and LoadBalancer unimplemented)"
}

variable "p2p_bootstrap_peers" {
  type        = string
  default     = ""
  description = "Default set of bootstrap peers (see https://docs.chain.link/chainlink-nodes/v1/configuration/#p2p_bootstrap_peers)"
}

variable "chainlink_acm_certificate_arn" {
  type        = string
  default     = "fake-acm-chainlink"
  description = "Your ACM Certificate ARN (Route53 and LoadBalancer unimplemented)"
}

variable "user_email" {
  type        = string
  default     = "user@example.com"
  description = "Email address for the Chainlink initial user"
}
