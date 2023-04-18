# Chainlink/Adapters Helm Charts
Note that if you want to customize your Chainlink node and adapters, you will have to update the Helm charts configuration in the [Terraform code](../tf/helm.tf).
For example if you want to set your explorer access key, you will have to update the `chainlink` Helm chart configuration in the `helm_release` resource: `helm_release.chainlink`.

```terraform
resource "helm_release" "chainlink" {
  chart   = "${path.module}/../chainlink-helm/chainlink"
  name    = "chainlink"
  version = "1.0.0"

  recreate_pods = true
  force_update  = true

  set {
    name  = "config.is_explorer_enabled"
    value = true
  }

  set {
    name  = "config.explorer_access_key"
    value = "YOUR_EXPLORER_ACCESS_KEY" # You can use SOPS to encrypt your secrets
  }

  set {
    name  = "config.explorer_secret"
    value = "YOUR_EXPLORER_SECRET" # You can use SOPS to encrypt your secrets
  }
  
  ...

  depends_on = [
    kubernetes_secret.api_secrets
  ]
}
```

## Chainlink Helm Chart

### Required Values

The values are mostly the Chainlink environment variables described in their [documentation](https://docs.chain.link/docs/configuration-variables/).

| Name                                | Chainlink Environment Variable | Type    | Default Value | Required |
|-------------------------------------|--------------------------------|---------|---------------|----------|
| `config.is_explorer_enabled`        | /                              | boolean | false         | true     |
| `config.explorer_access_key`        | EXPLORER_ACCESS_KEY            | string  | ""            | false    |
| `config.explorer_secret`            | EXPLORER_URL                   | string  | ""            | false    |
| `config.root`                       | ROOT                           | string  | "/chainlink"  | false    |
| `config.log_level`                  | LOG_LEVEL                      | string  | "debug"       | false    |
| `config.eth_chain_id`               | ETH_CHAIN_ID                   | string  | "4"           | true     |
| `config.chainlink_tls_port`         | CHAINLINK_TLS_PORT             | string  | "0"           | false    |
| `config.secure_cookies`             | SECURE_COOKIES                 | string  | "false"       | false    |
| `config.allow_origins`              | ALLOW_ORIGINS                  | string  | "*"           | false    |
| `config.eth_url`                    | ETH_URL                        | string  | ""            | true     |
| `config.database_locking_mode`      | DATABASE_LOCKING_MODE          | string  | "lease"       | false    |
| `config.p2p_bootstrap_peers`        | P2P_BOOTSTRAP_PEERS            | string  | ""            | false    |
| `config.feature_offchain_reporting` | FEATURE_OFFCHAIN_REPORTING     | string  | "true"        | false    |
| `config.chainlink_dev`              | CHAINLINK_DEV                  | string  | "true"        | true     |
| `config.p2p`                        | see below                      | object  | see below     | true     |

If you don't have an explorer access key, you must set `is_explorer_enabled` to `false`. Otherwise, if you set it to `true`, you need to set `explorer_access_key` and `explorer_secret`.

The p2p key is an object with the following default value:
```yaml
  p2p:
    enabled: true
    port: 10000
    elastic_ip_alloc_id: ''
    public_ip: ''
```

`p2p.enabled` isn't a Chainlink environment variable, but it allows you to choose whether you need the following **P2P** environment variables enabled or not.
If `p2p.enabled` is true the following environment variables will be set:
- **P2P_LISTEN_PORT** (`p2p.port`)
- **P2P_ANNOUNCE_PORT** (`p2p.port`)
- **P2P_ANNOUNCE_IP** (`p2p.public_ip`)

`p2p.elastic_ip_alloc_id` will always be used for the AWS Load Balancer EIP allocations (see [Chainlink Service](./chainlink/templates/service.yaml)).

## Chainlink Adapters Helm Chart

### Supported Adapters

- nomics
- coingecko
- coinmarketcap
- bea
- cryptocompare
- jpegd
- tiingo

### Required Values

The required values are mostly the Chainlink Adapters environment variables described [here](https://github.com/DexTrac-Devlin/Chainlink-EA-Manager).

| Name                                             | Chainlink Environment Variable          | Type    | Default Value |
|--------------------------------------------------|-----------------------------------------|---------|---------------|
| `config.enabled`                                 | /                                       | boolean | false         |
| `config.ea_port`                                 | EA_PORT                                 | string  | see below     |
| `config.api_key`                                 | API_KEY                                 | string  | ""            |
| `config.timeout`                                 | TIMEOUT                                 | string  | 30000         |
| `config.cache_enabled`                           | CACHE_ENABLED                           | string  | "false"       |
| `config.rate_limit_enabled`                      | RATE_LIMIT_ENABLED                      | string  | "true"        |
| `config.warmup_enabled`                          | WARMUP_ENABLED                          | string  | "true"        |
| `config.rate_limit_api_provider`                 | RATE_LIMIT_API_PROVIDER                 | string  | see below     |
| `config.rate_limit_api_tier`                     | RATE_LIMIT_API_TIER                     | string  | see below     |
| `config.request_coalescing_enabled`              | REQUEST_COALESCING_ENABLED              | string  | "true"        |
| `config.request_coalescing_interval`             | REQUEST_COALESCING_INTERVAL             | string  | "100"         |
| `config.request_coalescing_interval_max`         | REQUEST_COALESCING_INTERVAL_MAX         | string  | "1000"        |
| `config.request_coalescing_interval_coefficient` | REQUEST_COALESCING_INTERVAL_COEFFICIENT | string  | "2"           |
| `config.request_coalescing_entropy_max`          | REQUEST_COALESCING_ENTROPY_MAX          | string  | "0"           |
| `config.warmup_unhealthy_treshold`               | WARMUP_UNHEALTHY_THRESHOLD              | string  | "3"           |
| `config.warmup_subscription_ttl`                 | WARMUP_SUBSCRIPTION_TTL                 | string  | "360000"      |
| `config.log_level`                               | LOG_LEVEL                               | string  | "info"        |
| `config.debug`                                   | DEBUG                                   | string  | "false"       |
| `config.api_verbose`                             | API_VERBOSE                             | string  | "false"       |
| `config.experimental_metrics_enabled`            | EXPERIMENTAL_METRICS_ENABLED            | string  | "true"        |
| `config.metrics_name`                            | METRICS_NAME                            | string  | see below     |
| `config.retry`                                   | RETRY                                   | string  | "1"           |

All the above values are created inside the adapter object, e.g. with nomics:

```yaml
nomics:
  enabled: true

  config:
    ea_port: 1111
    api_key: ""
    timeout: 30000
    cache_enabled: false
    rate_limit_enabled: true
    warmup_enabled: true
    rate_limit_api_provider: 'nomics'
    rate_limit_api_tier: "https://api.nomics.com/v1"
    request_coalescing_enabled: true
    request_coalescing_interval: 100
    request_coalescing_interval_max: 1000
    request_coalescing_interval_coefficient: 2
    request_coalescing_entropy_max: 0
    warmup_unhealthy_treshold: 3
    warmup_subscription_ttl: 3600000
    log_level: "info"
    debug: false
    api_verbose: false
    experimental_metrics_enabled: true
    metrics_name: nomics
    retry: 1
```

The following keys depend on the provider, you probably won't have to change those values:
- `ea_port`, e.g.: `1111`
- `rate_limit_api_provider`, e.g.: `nomics`
- `rate_limit_api_tier`, e.g.: `https://api.nomics.com/v1`
- `metrics_name`, e.g.: `nomics`
