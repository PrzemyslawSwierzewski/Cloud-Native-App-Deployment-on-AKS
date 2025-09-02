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