# EKS Cluster
- This directory is used to provision an EKS cluster using **Terraform**. 
- I use the "terraform-aws-eks" module. 
- I use "worker_group" (unmanaged node group) instead of "node_group" (managed node group) because there are some things I think "node_group" is not as good as "worker_group". You can read it [here](https://eksctl.io/usage/eks-managed-nodes/#feature-parity-with-unmanaged-nodegroups). 
