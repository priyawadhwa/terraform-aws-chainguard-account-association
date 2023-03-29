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
  console_api = "https://console-api.chainguard.dev"
}

provider "aws" {}

resource "chainguard_group" "root" {
  name        = "demo root"
  description = "root group for demo"
}

module "account_association" {
  source = "./../../"

  enforce_domain_name = "chainguard.dev"
  enforce_group_id    = chainguard_group.root.id
}

data "aws_caller_identity" "current" {}

resource "chainguard_account_associations" "demo-chainguard-dev-binding" {
  group = chainguard_group.root.id
  name  = "aws account association"
  amazon {
    account = data.aws_caller_identity.current.account_id
  }
}
