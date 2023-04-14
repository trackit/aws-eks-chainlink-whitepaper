# AWS EKS Chainlink whitepaper

AWS EKS Chainlink whitepaper is a Terraform project that deploys a [Chainlink](https://chain.link/) node and adapters on AWS EKS.
The steps taken by TrackIt to build a secure, reliable, and scalable Chainlink environment are outlined in this article. Multiple Terraform modules supported by the AWS community were employed to deploy the AWS infrastructure.
Note that these steps are not intended for a production environment, but they will help you set up your first Chainlink node.

## Quick Start
### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) ~> 1.3.9 (you can use [tfenv](https://github.com/tfutils/tfenv) to manager your Terraform versions)
- An ETH URL from an ETH Client (i.e.: [Infura](https://infura.io/))

## Usage
### Setup
#### Terraform
- update tf/providers.tf with your Terraform S3 backend and provider configuration (region, s3/dynamodb name...)
- create KMS Key in AWS
- create a new tfvars file for an environment (i.e.: envs/dev.tfvars)
  - fill in the values for the variables in the created file (`example.tfvars` contains an example of how it could look like) 
  - create env folder for secrets: `mkdir tf/secrets/dev`

#### Secrets: SOPS
- update clear-secrets.yaml with good values for secrets
- encrypt secrets:
  - export KMS Key: `export SOPS_KMS_ARN=arn:aws:kms:REGION:ACCOUNT_ID:key/KMS_KEY_ID`
  - encrypt: `sops -e clear-secrets.yaml > ./tf/secrets/dev/encrypted-secrets.yaml` (dev because it's our env here)

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
