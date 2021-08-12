output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.cluster.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.cluster.cluster_security_group_id
}
output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.cluster.config_map_aws_auth
}

output "region" {
  description = "Cluster region"
  value       = var.region
}
