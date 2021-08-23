# My Cluster 
This repository is for my kubernetes cluster configurations.

Assume you are familiar with Terraform, Kubernetes, and AWS.

Some of the information you need to know:
- I use **EKS** *(Elastic Kubernetes Service)* and Kubernetes version **1.20**.
- I deploy the cluster and what I consider to be the backbone of the cluster **(cert-manager, istio, argocd)** using Terraform.
- When deploying istio before you run "terraform apply" run **install.sh** script. I noted in **READEME.md** *(./istio/README.md)*.
- Istio version **1.9.7**.