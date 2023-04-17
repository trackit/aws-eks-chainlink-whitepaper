# AWS EKS Chainlink whitepaper

AWS EKS Chainlink whitepaper is a Terraform project that deploys a [Chainlink](https://chain.link/) node and adapters on AWS EKS.
The steps taken by TrackIt to build a secure, reliable, and scalable Chainlink environment are outlined in this article. Multiple Terraform modules supported by the AWS community were employed to deploy the AWS infrastructure.
Note that these steps are not intended for a production environment, but they will help you set up your first Chainlink node.

## Quick Start
### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) ~> 1.3.9 (you can use [tfenv](https://github.com/tfutils/tfenv) to manager your Terraform versions)
- An ETH URL from an ETH Client (i.e.: [Infura](https://infura.io/))
- [SOPS](https://github.com/mozilla/sops)

## Usage
### Setup
#### Terraform
1. Update the [provider](./tf/providers.tf) with your Terraform S3 backend and provider configuration. For example, with `us-east-1` as the region, `terraform-state` as the S3 bucket name, and `terraform-state-lock` as the DynamoDB table name:
```terraform
terraform {
  required_version = "~> 1.3.9"
  backend "s3" {
    bucket         = "terraform-state"
    key            = "terraform.state"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "sops" {}
```
2. [Create a KMS key](https://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html) in AWS to encrypt your secrets.
3. Create a new tfvars file for your environment, i.e.: `envs/dev.tfvars` for the `dev` environment.
   1. Fill in the values for the variables (`example.tfvars` contains an example of how it could look like).
   2. Create the env folder for your secrets: `mkdir tf/secrets/dev`.

#### Secrets: SOPS
1. Create a new file `clear-dev-secrets.yaml` which is going to contain the secrets for your environment.
2. Fill in the values for the secrets (use `clear-secrets.yaml` as an example).
3. Encrypt secrets (KMS Key ARN is needed):
```shell
export SOPS_KMS_ARN=arn:aws:kms:REGION:ACCOUNT_ID:key/KMS_KEY_ID
sops -e clear-secrets.yaml > ./tf/secrets/dev/encrypted-secrets.yaml
```
> The encrypted file needs to be in the `tf/secrets/<env>` folder and named `encrypted-secrets.yaml`.

### Deployment
Once you have completed the setup, you can follow these steps to deploy the Chainlink node and adapters:

1. Open a terminal and go to the `tf` folder: `cd tf`
2. Initialize Terraform:
```shell
terraform init
```
3. (optional) If you want to use workspace, you need to create it (if the workspace does not exist) and select it:
```shell
terraform workspace new dev && terraform workspace select dev
```
4. Plan the deployment to verify that the deployment matches your configuration:
```shell
terraform plan --var-file ../envs/dev.tfvars
```
5. Deploy the Infrastructure
```shell
terraform apply --var-file ../envs/dev.tfvars
```

### Go Further
If you want to go further and customize your Chainlink node and adapters you can look at our [Chainlink Helm Charts documentation](./chainlink-helm/helm.md).

## Known Issues
### Terraform Destroy
When destroying the Terraform project, the following error may occur:
```shell
╷
│ Error: deleting EC2 EIP (eipalloc-XXXX): disassociating: AuthFailure: You do not have permission to access the specified resource.
│       status code: 400, request id: XXXX
│ 
│ 
╵
```

Temporary workaround: destroy the project again.

# Terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.9 |
| <a name="requirement_sops"></a> [sops](#requirement\_sops) | ~> 0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_sops"></a> [sops](#provider\_sops) | ~> 0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds-aurora/aws | ~>6.1.4 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> v3.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.p2p_ingress_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.p2p_ingress_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.rds_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.adapters](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.chainlink](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.api_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [sops_file.secrets](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of AWS roles to map to Kubernetes users | <pre>list(object({<br>    rolearn  = string # AWS Role<br>    username = string # Username in Kubernetes<br>    groups   = list(string) # Group in Kubernetes<br>  }))</pre> | `[]` | no |
| <a name="input_aws_auth_users"></a> [aws\_auth\_users](#input\_aws\_auth\_users) | List of AWS users to map to Kubernetes users | <pre>list(object({<br>    userarn  = string # AWS User<br>    username = string # Username in Kubernetes<br>    groups   = list(string) # Group in Kubernetes<br>  }))</pre> | `[]` | no |
| <a name="input_chainlink_acm_certificate_arn"></a> [chainlink\_acm\_certificate\_arn](#input\_chainlink\_acm\_certificate\_arn) | Your ACM Certificate ARN (Route53 and LoadBalancer unimplemented) | `string` | `"fake-acm-chainlink"` | no |
| <a name="input_chainlink_dev"></a> [chainlink\_dev](#input\_chainlink\_dev) | Whether or not to run Chainlink in dev mode | `string` | `"true"` | no |
| <a name="input_chainlink_domain_name"></a> [chainlink\_domain\_name](#input\_chainlink\_domain\_name) | Your Chainlink Domain Name (Route53 and LoadBalancer unimplemented) | `string` | n/a | yes |
| <a name="input_chainlink_eth_chain_id"></a> [chainlink\_eth\_chain\_id](#input\_chainlink\_eth\_chain\_id) | Your ETH Chain ID | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_eth_url"></a> [eth\_url](#input\_eth\_url) | Your WSS ETH URL | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Your KMS Key ID for decrypting secrets with SOPS | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Chainlink deployment | `string` | `"chainlink"` | no |
| <a name="input_p2p_bootstrap_peers"></a> [p2p\_bootstrap\_peers](#input\_p2p\_bootstrap\_peers) | Default set of bootstrap peers (see https://docs.chain.link/chainlink-nodes/v1/configuration/#p2p_bootstrap_peers) | `string` | `""` | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | RDS Instance Type (see https://aws.amazon.com/rds/instance-types/) | `string` | `"db.r6g.large"` | no |
| <a name="input_user_email"></a> [user\_email](#input\_user\_email) | Email address for the Chainlink initial user | `string` | `"user@example.com"` | no |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | VPC Availability Zones | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR | `string` | `"10.10.0.0/16"` | no |
| <a name="input_vpc_database_cidrs"></a> [vpc\_database\_cidrs](#input\_vpc\_database\_cidrs) | VPC Database Subnets CIDR | `list(string)` | <pre>[<br>  "10.10.200.0/24",<br>  "10.10.201.0/24"<br>]</pre> | no |
| <a name="input_vpc_private_cidrs"></a> [vpc\_private\_cidrs](#input\_vpc\_private\_cidrs) | VPC Private Subnets CIDR | `list(string)` | <pre>[<br>  "10.10.100.0/24",<br>  "10.10.101.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_cidrs"></a> [vpc\_public\_cidrs](#input\_vpc\_public\_cidrs) | VPC Public Subnets CIDR | `list(string)` | <pre>[<br>  "10.10.0.0/24",<br>  "10.10.1.0/24"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
