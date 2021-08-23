# My Cluster 
This repository is for my kubernetes cluster configurations.

Assume you are familiar with Terraform, Kubernetes, and AWS.

Some of the information you need to know:
- I use **EKS** *(Elastic Kubernetes Service)* and Kubernetes version **1.20**.
- I deploy the cluster and what I consider to be the backbone of the cluster **(cert-manager, istio, argocd)** using Terraform.
- When deploying istio before you run "terraform apply" run **install.sh** script. I noted in **READEME.md** *(./istio/README.md)*.
- Istio version **1.9.7**.

### Notes
- If you use Cloudflare and Cert Manager to order a Certificate, the "Always use HTTPS" mode must be disabled. 
- If you use Istio, Gateway cannot be force request to HTTPS (443) `httpsRedirect: true`. You can change it after the challenge is over.
