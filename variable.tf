variable "resource_group_name" {
  type    = string
  default = "my-resource-group"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "virtual_network_name" {
  type    = string
  default = "my-vnet"
}

variable "subnet1" {
  type    = string
  default = "10.1.1.0/24"
}

variable "subnet2pv" {
  type    = string
  default = "10.1.2.0/24"
}
variable "nsg_name" {
    type = string
    default = "N-Tier-NSG"
}
variable "aks_cluster_name" {
  type    = string
  default = "my-aks-cluster"
}
variable "aks_node_count" {
  type    = number
  default = 3
}
