variable "ip_cidr" {
  description = "base ip cidr range"
  default     = "10.0.0.0/8"
}

variable "host_count" {
  description = "maximum amount of VMs inside the subnetwork"
  default     = 252
  type        = number
}

variable "node_count" {
  description = "maximum amount of GKE nodes"
  default     = 16
  type        = number
}

variable "pods_per_node" {
  description = "how many pods can run on one GKE node"
  default     = 110
  type        = number
}
variable "services_count" {
  description = "how many services are available inside the cluster"
  default     = 508
  type        = number
}

variable "occupied_netmasks" {
  description = "already occupied netmasks to modify subnet calculation"
  default     = []
  type        = list(number)
}

