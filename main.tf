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

  input_networks = concat(
    [
      for index in range(length(local.occupied_bits)) : {
        name     = "occupied${index}"
        new_bits = local.occupied_bits[index]
        occupied = true
      }
    ],
    [
      {
        name     = "primary",
        new_bits = local.base_bits - local.host_bits,
        occupied = false,
      },
      {
        name     = "master",
        new_bits = local.base_bits - local.master_bits,
        occupied = false,
      },
      {
        name     = "services",
        new_bits = local.base_bits - local.service_bits,
        occupied = false,
      },
      {
        name     = "pods",
        new_bits = local.base_bits - local.total_node_bits,
        occupied = false,
      },
  ])

  # https://github.com/hashicorp/terraform/issues/22404#issuecomment-640245762
  new_bits = flatten([local.input_networks[*].new_bits])

  mask_regex = "/.*\\//"
  net_regex  = "/\\/.*/"

  # do the math

  net_blocks = cidrsubnets(var.ip_cidr, local.new_bits...)
  networks = [for i, net in local.input_networks : {
    name       = net.name
    occupied   = net.occupied
    new_bits   = net.new_bits
    cidr_block = local.net_blocks[i]
    mask       = tonumber(replace(local.net_blocks[i], local.mask_regex, ""))
    net_addr   = replace(local.net_blocks[i], local.net_regex, "")
  }]
  named_networks = { for i, net in local.networks : net.name => {
    cidr_block = net.cidr_block
    mask       = net.mask
    net_addr   = net.net_addr
    new_bits   = net.new_bits
  } if net.occupied == false }

  named_networks_cidr = { for i, net in local.networks : net.name => net.cidr_block if net.occupied == false }

  # prepare output

  occupied_netmasks     = [for net in local.networks : net.mask if net.occupied == false]
  all_occupied_netmasks = local.networks[*].mask

}
