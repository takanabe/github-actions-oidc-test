**CAUTION!! GitHub does not announce ID token for GitHub Actions as GA. Please don't use this feature in production. Breaking changes could be introduced at any moment.**

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
Also, replace [`client_id_list`](https://github.com/takanabe/github-actions-oidc-test/blob/e88aea863fe586515709969dc7d4917bdbbef959/main.tf#L27) with your repository URL.

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
