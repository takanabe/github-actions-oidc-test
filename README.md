# github-actions-oidc-test

Test out AssumeRoleWithWebIdentity using ID token issued by GitHub OIDC provider. All AWS resources are deployed using Terraform.

## Requirements

* tfenv
* AWS account

## Setup

### Input preparation

Prepare for your Terraform variable file.

```
cp terraform.tfvars .terraform.tfvars
```


### Configuration

Replace `YOUR_AWS_ACCOUNT_ID` in `.terrraform.tfvars` and `.github/workflows/main.yml` with your AWS account ID.

### Install Terraform

```
tfenv install
```

## Deploy AWS resources

Deploy IAM identity provider and assumed IAM role called `GitHubActions` with the command below.

```
terraform init -var-file .terraform.tfvars
terraform plan -var-file .terraform.tfvars
terraform apply -var-file .terraform.tfvars
```

## Run GitHub Actions

Trigger your GitHub Actions manually. They you can find assumed IAM role information with `aws sts get-caller-identity`.

## Reference

This is inspired by  the following materials.

* https://github.com/github/roadmap/issues/249
* https://awsteele.com/blog/2021/09/15/aws-federation-comes-to-github-actions.html
