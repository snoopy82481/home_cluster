terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.30.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }
  }
}
