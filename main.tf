locals {
  start_bits         = tonumber(replace(var.ip_cidr, "/.*\\//", ""))
  base_bits          = 32 - local.start_bits
  occupied_bits      = [for mask in var.occupied_netmasks : mask - local.start_bits]
  host_bits          = ceil(log(var.host_count + 4, 2))
  service_bits       = ceil(log(var.services_count + 4, 2))
  node_bits          = ceil(log(var.node_count, 2))
  pods_per_node_bits = ceil(log(2 * var.pods_per_node + 4, 2))
  total_node_bits    = local.node_bits + local.pods_per_node_bits
  # it must be a /28 subnet
  master_bits = 32 - 28
}

module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.ip_cidr
  networks = concat(
    [
      for index in range(length(local.occupied_bits)) : {
        name     = "occupied${index}"
        new_bits = local.occupied_bits[index]
      }
    ],
    [
      {
        name     = "nodes"
        new_bits = local.base_bits - local.host_bits
      },
      {
        name     = "primary",
        new_bits = local.base_bits - local.host_bits,
      },
      {
        name     = "services",
        new_bits = local.base_bits - local.service_bits,
      },
      {
        name     = "pods",
        new_bits = local.base_bits - local.total_node_bits,
      },
      {
        name     = "master",
        new_bits = local.base_bits - local.master_bits,
      },
  ])
}
output "primary_ip_cidr" {
  description = "primary ip address range for subnet"
  value       = module.subnet_addrs.network_cidr_blocks.primary
}
output "services_ip_cidr" {
  description = "secondary ip address range for services"
  value       = module.subnet_addrs.network_cidr_blocks.services
}
output "pods_ip_cidr" {
  description = "secondary ip address range for pods"
  value       = module.subnet_addrs.network_cidr_blocks.pods
}
output "master_ip_cidr" {
  description = "private master ip address range"
  value       = module.subnet_addrs.network_cidr_blocks.master
}

output "primary_netmask" {
  description = "primary ip address netmask"
  value       = tonumber(replace(module.subnet_addrs.network_cidr_blocks.primary, "/.*\\//", ""))
}
output "services_netmask" {
  description = "services ip address netmask"
  value       = tonumber(replace(module.subnet_addrs.network_cidr_blocks.services, "/.*\\//", ""))
}
output "pods_netmask" {
  description = "pods ip address netmask"
  value       = tonumber(replace(module.subnet_addrs.network_cidr_blocks.pods, "/.*\\//", ""))
}
output "master_netmask" {
  description = "master ip address netmask"
  value       = tonumber(replace(module.subnet_addrs.network_cidr_blocks.master, "/.*\\//", ""))
}

output "occupied_netmasks" {
  description = "ocupied netmasks for this subnet"
  value = [
    tonumber(replace(module.subnet_addrs.network_cidr_blocks.primary, "/.*\\//", "")),
    tonumber(replace(module.subnet_addrs.network_cidr_blocks.services, "/.*\\//", "")),
    tonumber(replace(module.subnet_addrs.network_cidr_blocks.pods, "/.*\\//", "")),
    tonumber(replace(module.subnet_addrs.network_cidr_blocks.master, "/.*\\//", ""))
  ]

}
output "all_occupied_netmasks" {
  description = "ocupied netmasks for this subnet"
  value = concat([
    for index in range(length(local.occupied_bits)) :
    tonumber(replace(module.subnet_addrs.network_cidr_blocks["occupied${index}"], "/.*\\//", ""))
    ],
    [
      tonumber(replace(module.subnet_addrs.network_cidr_blocks.primary, "/.*\\//", "")),
      tonumber(replace(module.subnet_addrs.network_cidr_blocks.services, "/.*\\//", "")),
      tonumber(replace(module.subnet_addrs.network_cidr_blocks.pods, "/.*\\//", "")),
      tonumber(replace(module.subnet_addrs.network_cidr_blocks.master, "/.*\\//", ""))
    ]
  )
}

output "calculated_blocks" {
  value = module.subnet_addrs.network_cidr_blocks
}
