# Kubernetes External Secrets Example

When reading the KES documentation, I see that there is a point that can cause readers to be confused. 

Document: https://github.com/external-secrets/kubernetes-external-secrets#hashicorp-vault

```yaml
apiVersion: "kubernetes-client.io/v1"
kind: ExternalSecret
metadata:
  name: hello-vault-service
spec:
  backendType: vault
  # Your authentication mount point, e.g. "kubernetes"
  # Overrides cluster DEFAULT_VAULT_MOUNT_POINT
  vaultMountPoint: my-kubernetes-vault-mount-point
  # The vault role that will be used to fetch the secrets
  # This role will need to be bound to kubernetes-external-secret's ServiceAccount; see Vault's documentation:
  # https://www.vaultproject.io/docs/auth/kubernetes.html
  # Overrides cluster DEFAULT_VAULT_ROLE
  vaultRole: my-vault-role
  data:
    - name: password
      # The full path of the secret to read, as in `vault read secret/data/hello-service/credentials`
      key: secret/data/hello-service/credentials
      property: password
    # Vault values are matched individually. If you have several keys in your Vault secret, you will need to add them all separately
    - name: api-key
      key: secret/data/hello-service/credentials
      property: api-key
```

**key: secret/data/hello-service/credentials** the **secret** should be **ENGINE PATH**. 

E.g:
- You enabled **KV2 Engine** with path **data/secrets** so the key should be: **data/data/secrets**.
- You enabled **AWS Engine** with paht **aws/secrets** so the key should be **aws/data/secrets**.

**Related issues:**
- https://github.com/hashicorp/vault/issues/4808

### Docker credentials
I created a **dockerconfig** with path **data/example/docker**. 
`credentials` field should be:
```json
{
  "auths": {
    "DOCKER_REGISTRY_URL": {
      "username": "DOCKER_USERNAME",
      "password": "DOCKER_TOKEN"
    }
  }
}
```
If you are using **Docker Hub**. The `DOCKER_REGISTRY_URL` should be https://index.docker.io/v1/

---
### Related documents: 
- https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
- https://github.com/external-secrets/kubernetes-external-secrets#hashicorp-vault

