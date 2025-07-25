terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92.0, < 6.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0, <= 2.17.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}
