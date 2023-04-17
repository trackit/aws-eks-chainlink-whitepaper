### GLOBAL ###
kms_key_id = "REPLACE_BY_KMS_KEY_ID"
env = "example"
chainlink_acm_certificate_arn = "arn:aws:acm:REGION:AWS_ACCOUNT_ID:certificate/CERTIFICATE_ID"

### EKS ###
aws_auth_roles = [
  {
    rolearn = "arn:aws:iam::REPLACE_BY_AWS_ACCOUNT_ID:role/REPLACE_BY_AWS_ROLE_NAME"
    username = "admin"
    groups = ["systems:masters"]
  }
]
aws_auth_users = [
  {
    userarn = "arn:aws:iam::REPLACE_BY_AWS_ACCOUNT_ID:user/REPLACE_BY_AWS_USER_NAME"
    username = "admin"
    groups = ["systems:masters"]
  }
]

### VPC ###
vpc_cidr = "10.10.0.0/16"
vpc_azs = ["us-east-2a", "us-east-2b"]
vpc_private_cidrs = ["10.10.100.0/24", "10.10.101.0/24"]
vpc_public_cidrs = ["10.10.0.0/24", "10.10.1.0/24"]
vpc_database_cidrs = ["10.10.200.0/24", "10.10.201.0/24"]

### RDS ###
rds_instance_type = "db.r6g.large"

### CHAINLINK ###
eth_url = "wss://mainnet.example.io/ws/v3/example"
chainlink_domain_name = "chainlink.example.com"
p2p_bootstrap_peers = ""
user_email = "user@example.com"
chainlink_eth_chain_id = "4"
chainlink_dev = "true"
