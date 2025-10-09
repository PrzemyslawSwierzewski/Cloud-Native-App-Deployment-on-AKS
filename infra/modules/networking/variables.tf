variable "environment" {
  type = object({
    name     = string
    rg_name  = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}