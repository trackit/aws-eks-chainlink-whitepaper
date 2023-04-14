resource "aws_eip" "p2p_ingress_a" {
  vpc = true

  tags = {
    Name = "chainlink-p2p-ingress-A-${var.env}"
  }
}

resource "aws_eip" "p2p_ingress_b" {
  vpc = true

  tags = {
    Name = "chainlink-p2p-ingress-B-${var.env}"
  }
}

resource "helm_release" "chainlink" {
  chart   = "${path.module}/../chainlink-helm/chainlink"
  name    = "chainlink"
  version = "0.1.36"

  recreate_pods = true
  force_update  = true

  set {
    name  = "config.eth_chain_id"
    value = var.chainlink_eth_chain_id
  }

  set {
    name = "config.eth_url"
    value = var.eth_url
  }

  set {
    name  = "config.chainlink_dev"
    value = var.chainlink_dev
  }

  set {
    name  = "config.db_url"
    value = sensitive("postgres://chainlink:${module.rds.cluster_master_password}@${module.rds.cluster_endpoint}/${var.name}?sslmode=disable")
  }

  set {
    name  = "ingress.host"
    value = var.chainlink_domain_name
  }

  set {
    name  = "config.p2p_bootstrap_peers"
    value = var.p2p_bootstrap_peers
  }

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "ingress.acm_certificate_arn"
    value = var.chainlink_acm_certificate_arn
  }

  set {
    name  = "config.p2p.public_ip"
    value = aws_eip.p2p_ingress_a.public_ip
  }

  set {
    name  = "config.p2p.elastic_ip_alloc_id"
    value = "${aws_eip.p2p_ingress_a.allocation_id}\\,${aws_eip.p2p_ingress_b.allocation_id}"
  }

  depends_on = [
    kubernetes_secret.api_secrets
  ]
}

resource "kubernetes_secret" "api_secrets" {
  metadata {
    name = "api-secrets"
  }

  data = {
    ".password" = templatefile(
      "${path.module}/../chainlink-helm/secrets/password.tpl",
      {
        wallet-password : sensitive(data.sops_file.secrets.data["wallet_password"]),
      }
    )
    ".api" = templatefile(
      "${path.module}/../chainlink-helm/secrets/api.tpl",
      {
        email : var.user_email
        password : sensitive(data.sops_file.secrets.data["user_password"])
      }
    )
  }
}

resource "helm_release" "adapters" {
  chart   = "${path.module}/../chainlink-helm/adapters"
  name    = "adapters"
  version = "0.1.71"

  # We are using SOPS to retrieve Adapter API Keys and put it as a value for the Chart
  set {
    name = "nomics.enabled"
    value = false
  }

  set {
    name = "tiingo.enabled"
    value = true
  }

  set {
    name = "cryptocompare.enabled"
    value = true
  }

  set {
    name  = "nomics.config.api_key"
    value = sensitive(data.sops_file.secrets.data["nomics_api_key"])
  }

  set {
    name  = "cryptocompare.config.api_key"
    value = sensitive(data.sops_file.secrets.data["cryptocompare_api_key"])
  }

  recreate_pods = true
  force_update  = true
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.8.7"
  namespace  = "default"

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "pushgateway.enabled"
    value = "false"
  }

  values = [
    file("${path.module}/../chainlink-helm/prometheus/values.yaml")
  ]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "6.29.4"
  namespace  = "default"

  set {
    name  = "ingress.hosts"
    value = "{grafana.example.com}"
  }

  values = [
    templatefile(
      "${path.module}/../chainlink-helm/grafana/values.yaml",
      {
        chainlink-ocr : indent(8, file("${path.module}/../chainlink-helm/grafana/dashboards/chainlink-ocr.json")),
        external-adapter : indent(8, file("${path.module}/../chainlink-helm/grafana/dashboards/external-adapter.json"))
        acm-certificate-arn : "fake-arn"
      }
    )
  ]
}
