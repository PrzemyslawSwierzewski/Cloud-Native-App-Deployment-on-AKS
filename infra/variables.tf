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

variable "default_node_pool_prod" {
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
  default = {
    name       = "nodepool"
    node_count = 1
    vm_size    = "standard_a2_v2"
  }
}

variable "default_node_pool_dev_stage" {
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
  default = {
    name       = "nodepool"
    node_count = 2
    vm_size    = "standard_a2_v2"
  }
}

variable "prod_aks_scaling_max_count" {
  type = number
  default = 5
}

variable "prod_aks_scaling_min_count" {
  type = number
  default = 1
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the resource owner"
}