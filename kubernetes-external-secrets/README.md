# Kubernetes External Secrets
In order for a pod to obtain secrets,Vault uses the sidecar to inject the secrets into the pod. 
But one limitation of Vault is that it cannot inject secrets into a Kubernetes Secret or in other words it cannot create a Kubernetes Secret. 
Kubernetes External Secrets was created to solve this problem.
Repo: https://github.com/external-secrets/kubernetes-external-secrets
