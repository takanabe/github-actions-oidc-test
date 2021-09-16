##########################
# Providers
##########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  region              = "ap-northeast-1"
  allowed_account_ids = [var.aws_account_id]
}

##########################
# IAM identity providers
##########################

# https://github.com/github/roadmap/issues/249
resource "aws_iam_openid_connect_provider" "github_oidc_for_takanabe_github_actions_oidc_test" {
  url = "https://vstoken.actions.githubusercontent.com"
  # By default, GitHub OIDC sets a repository URL as audience in ID Token
  client_id_list = ["https://github.com/takanabe/github-actions-oidc-test"]
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}

##########################
# IAM Role
##########################

data "aws_iam_policy_document" "GitHubActions_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc_for_takanabe_github_actions_oidc_test.arn]
    }

    condition {
      test     = "StringLike"
      variable = "vstoken.actions.githubusercontent.com:sub"
      values   = ["repo:takanabe/github-actions-oidc-test:*"]
    }
  }
}

resource "aws_iam_role" "GitHubActions" {
  name               = "GitHubActions"
  assume_role_policy = data.aws_iam_policy_document.GitHubActions_assume_role_policy.json
}

##########################
# IAM Policy
##########################

data "aws_iam_policy_document" "GitHubActions" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "GitHubActions" {
  name        = "GitHubActions"
  path        = "/"
  description = "Policy for GitHubActions"
  policy      = data.aws_iam_policy_document.GitHubActions.json
}

resource "aws_iam_role_policy_attachment" "attach_GitHubActions_policy_to_GitHubActions_role" {
  role       = aws_iam_role.GitHubActions.name
  policy_arn = aws_iam_policy.GitHubActions.arn
}
