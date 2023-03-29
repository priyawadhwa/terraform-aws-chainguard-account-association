terraform {
  backend "gcs" {
    bucket = "priya-chainguard-terraform-state"
    prefix = "terraform/state/terraform-awst-chainguard-account-association"
  }
}