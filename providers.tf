variable "vault_addr" {}
variable "vault_token" {}
variable "aws_region" {}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}


data "vault_kv_secret_v2" "awscreds" {
  mount = "aws"                  # KV engine mount path
  name  = "awscreds"            # Secret path in Vault
}

provider "aws" {
  region     = var.aws_region
  access_key = data.vault_kv_secret_v2.awscreds.data["accesskey"]
  secret_key = data.vault_kv_secret_v2.awscreds.data["secretaccesskey"]
}

