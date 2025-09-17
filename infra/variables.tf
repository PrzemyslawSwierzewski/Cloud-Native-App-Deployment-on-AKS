variable "acr_sku" {
  type        = string
  default     = "Premium"
  description = "SKU for every container registry across all environments"
}

variable "sku_name_key_vault" {
  type        = string
  default     = "standard"
  description = "SKU for the key vault"
}

variable "default_node_pools" {
  type = map(object({
    name       = string
    node_count = number
    vm_size    = string
  }))

  default = {
    dev = {
      name       = "nodepool"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
    stage = {
      name       = "nodepool"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
    prod = {
      name       = "nodepool"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
  }
}

variable "aks_scaling" {
  type = map(object({
    min = number
    max = number
  }))

  default = {
    dev = {
      min = 1
      max = 1
    }
    stage = {
      min = 1
      max = 1
    }
    prod = {
      min = 1
      max = 1
    }
  }
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the resource owner"
  default     = "prem@wp.pl"
}