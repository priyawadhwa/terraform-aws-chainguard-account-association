terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    chainguard = {
      # NB: This provider is currently not public
      source = "chainguard/chainguard"
    }
  }
}

provider "chainguard" {
  console_api = "https://console-api.enforce.dev"
}

provider "aws" {}



module "aws-impersonation" {
  source = "./../../"

  enforce_domain_name = "enforce.dev"
  enforce_group_id    = "b503e31b0dd075dbbcbc9b33f3476291d8e9b9a1"
}

module "aws-auditlogs" {
  source = "./../../auditlogs"
}

data "aws_caller_identity" "current" {}

resource "chainguard_account_associations" "demo-chainguard-dev-binding" {
  group = "b503e31b0dd075dbbcbc9b33f3476291d8e9b9a1"
  name  = "aws"
  amazon {
    account = data.aws_caller_identity.current.account_id
  }
}
