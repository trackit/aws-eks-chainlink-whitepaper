module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~>6.1.4"

  name = "${var.name}-${var.env}"

  engine         = "aurora-postgresql"
  instance_class = var.rds_instance_type
  instances = {
    1 = {}
    2 = {}
  }

  autoscaling_enabled      = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 2

  monitoring_interval           = 60
  iam_role_name                 = "${var.name}-monitor"
  iam_role_use_name_prefix      = true
  iam_role_description          = "${var.name} RDS enhanced monitoring IAM role"
  iam_role_path                 = "/autoscaling/"
  iam_role_max_session_duration = 7200

  storage_encrypted = true

  database_name = var.name

  master_username = "chainlink" # default: root
  port            = 5432

  subnets                = module.vpc.database_subnets
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  create_db_subnet_group = false
  allowed_cidr_blocks    = [var.vpc_cidr]
  vpc_id                 = module.vpc.vpc_id
  create_security_group  = true

  backup_retention_period = 30
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = local.tags
}

resource "aws_secretsmanager_secret" "rds_url" {
  name                    = "${var.name}-${var.env}-psql-url"
  recovery_window_in_days = 0
  tags                    = local.tags
}

resource "aws_secretsmanager_secret_version" "url" {
  secret_id     = aws_secretsmanager_secret.rds_url.id
  secret_string = "postgres://chainlink:${module.rds.cluster_master_password}@${module.rds.cluster_endpoint}/${var.name}?sslmode=disable"
}


