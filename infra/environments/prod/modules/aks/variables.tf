variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "default_node_pool" {
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
}

variable "subnet_id" {
  type = string
}

variable "prod_aks_scaling_max_count" {
  type = number
}

variable "prod_aks_scaling_min_count" {
  type = number
}

variable "user_assigned_identity_id" {
  type        = string
  description = "The ID of the user-assigned managed identity to be associated with the AKS cluster"
}