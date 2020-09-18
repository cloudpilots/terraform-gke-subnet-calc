
output "primary_ip_cidr" {
  description = "primary ip address range for subnet"
  value       = local.named_networks.primary.cidr_block
}
output "services_ip_cidr" {
  description = "secondary ip address range for services"
  value       = local.named_networks.services.cidr_block
}
output "pods_ip_cidr" {
  description = "secondary ip address range for pods"
  value       = local.named_networks.pods.cidr_block
}
output "master_ip_cidr" {
  description = "private master ip address range"
  value       = local.named_networks.master.cidr_block
}

output "occupied_netmasks" {
  description = "ocupied netmasks for this subnet"
  value       = local.occupied_netmasks

}
output "all_occupied_netmasks" {
  description = "ocupied netmasks for this subnet"
  value       = local.all_occupied_netmasks
}

output "calculated_blocks" {
  value = local.named_networks
}
