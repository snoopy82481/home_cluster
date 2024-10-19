terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.44.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}
