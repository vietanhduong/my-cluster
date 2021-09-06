# HPA Example
First of all, I think you should understand **Horizontal Pod Autoscaler (HPA)**. I strongly recommend [the official document](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).

#### Create deployment
```
# Current dirrectory 'hpa-test'
kubectl apply -k . 
```

#### Increase load
```shell
kubectl -n hpa-test run -i \
  --tty load-generator \
  --rm --image=busybox \
  --restart=Never -- sh -c "while sleep 0.01; do wget -q -O- http://hpa-test; done"  
```
Note that the first "hpa-test" is my **namespace** and the second "hpa-test" is the **service name**. 

---
A few things I want you to keep in mind to avoid wasting time:
- Make sure your K8S cluster is deployed "metric-server".
- To check if the cluster is installed "metric-server" or not:
```shell
kubectl top nodes
```
- HPA can only work when you configure "resource request" in "deployment".
- HPA will collect metric of "pod" **30s** after "pod" starts running. 
