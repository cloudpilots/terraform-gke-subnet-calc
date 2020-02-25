# Terraform GKE Subnet calculator

Calculate the subnet ip ranges and secondary block required for a GKE cluster

```terraform
module "gke_subnet" {
  source            = "github.com/cloudpilots/terraform-gke-subnet-calc"
  ip_cidr           = "10.0.0.0/8"
  host_count        = 252
  node_count        = 8
  pods_per_node     = 60
  services_count    = 252
  occupied_netmasks = [21, 21, 21]
}
output "gke_subnet" {
  description = "GKE subnets"
  value       = module.gke_subnet.calculated_blocks
}

output "gke_primary_ip_cidr" {
  description = "GKE primary nodes network"
  value       = module.gke_subnet.primary_ip_cidr
}
output "gke_pods_ip_cidr" {
  description = "GKE pods ip range"
  value       = module.gke_subnet.pods_ip_cidr
}
output "gke_services_ip_cidr" {
  description = "GKE services ip range"
  value       = module.gke_subnet.services_ip_cidr
}
output "gke_master_ip_cidr" {
  description = "GKE master ip range"
  value       = module.gke_subnet.master_ip_cidr
}

```
