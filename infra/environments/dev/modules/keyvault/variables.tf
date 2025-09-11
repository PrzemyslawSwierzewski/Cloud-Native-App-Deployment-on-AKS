variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "sku_name_key_vault" {
  type    = string
  default = "standard"
  description = "SKU for the key vault"
}