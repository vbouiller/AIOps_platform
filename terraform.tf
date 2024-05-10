terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.88.0"
    }

  }
}


provider "hcp" {}