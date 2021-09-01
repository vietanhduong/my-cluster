# My Cluster 
This repository is for my kubernetes cluster configurations.

Assume you are familiar with Terraform, Kubernetes, and AWS.

Some of the information you need to know:
- I use **EKS** *(Elastic Kubernetes Service)* and Kubernetes version **1.20**.
- I deploy the cluster what I consider to be the backbone of the cluster **(cert-manager, istio, argocd, vault)** by using **Terraform**.
- When deploying istio before you run "terraform apply" run **install.sh** script. I noted in [READEME.md](./istio/README.md).
- Istio version **1.9.7**.
- I manage Secrets with [Hashicorp Vault](https://www.vaultproject.io/). 

### Notes
- If you use Cloudflare and Cert Manager to order a Certificate, the "Always use HTTPS" mode must be disabled. 
- If you use Istio, Gateway cannot be force request to HTTPS (443) `httpsRedirect: true`. You can change it after the challenge is over.
- When working with Istio I had a lot of problems ordering the Let's Encrypt Certificate using http01 so I switched to using dns01 method by providing Cloudflare API Key. You can find related documents [here](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/). 
- The answer to the question **"What is the different between 'node_groups' and 'worker_groups'?"** in [here](https://github.com/terraform-aws-modules/terraform-aws-eks/issues/895).
