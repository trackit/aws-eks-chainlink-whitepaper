resource "aws_secretsmanager_secret" "user_password" {
  name                    = "${var.name}-${var.env}-user-password"
  description             = "User password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "user_password" {
  secret_id     = aws_secretsmanager_secret.user_password.id
  secret_string = sensitive(data.sops_file.secrets.data["user_password"])
}

data "sops_file" "secrets" {
  source_file = "${path.module}/secrets/${var.env}/encrypted-secrets.yaml"
}
