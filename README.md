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

Outputs:

```terraform
Outputs:

all_occupied_netmasks = [
  24,
  28,
  24,
  22,
]
calculated_blocks = {
  "master" = "10.0.1.0/28"
  "pods" = "10.0.4.0/22"
  "primary" = "10.0.0.0/24"
  "services" = "10.0.2.0/24"
}
calculated_networks = {
  "master" = {
    "cidr_block" = "10.0.1.0/28"
    "mask" = 28
    "net_addr" = "10.0.1.0"
    "new_bits" = 20
  }
  "pods" = {
    "cidr_block" = "10.0.4.0/22"
    "mask" = 22
    "net_addr" = "10.0.4.0"
    "new_bits" = 14
  }
  "primary" = {
    "cidr_block" = "10.0.0.0/24"
    "mask" = 24
    "net_addr" = "10.0.0.0"
    "new_bits" = 16
  }
  "services" = {
    "cidr_block" = "10.0.2.0/24"
    "mask" = 24
    "net_addr" = "10.0.2.0"
    "new_bits" = 16
  }
}
master_ip_cidr = 10.0.1.0/28
occupied_netmasks = [
  24,
  28,
  24,
  22,
]
pods_ip_cidr = 10.0.4.0/22
primary_ip_cidr = 10.0.0.0/24
services_ip_cidr = 10.0.2.0/24
```
