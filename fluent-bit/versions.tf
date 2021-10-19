terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
  }
}
