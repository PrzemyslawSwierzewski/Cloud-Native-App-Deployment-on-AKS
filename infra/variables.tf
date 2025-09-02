variable "acr_skus" {
  type        = string
  default     = "Premium"
  description = "SKU for every container registry across all environments"
}

variable "sku_name_key_vault" {
  type        = string
  default     = "standard"
  description = "SKU for the key vault"
}

variable "default_node_pool" {
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
  default = {
    name       = "nodepool"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
}