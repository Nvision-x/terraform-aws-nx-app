terraform {
  #   backend "s3" {
  #   }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

provider "kubectl" {
  alias                  = "eks"
  host                   = module.nx.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.nx.eks_cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.nx.eks_cluster_name]
  }
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = module.nx.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.nx.eks_cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.nx.eks_cluster_name]
    }
  }
}
