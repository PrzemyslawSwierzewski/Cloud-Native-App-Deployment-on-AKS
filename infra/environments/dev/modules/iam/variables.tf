variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
    tags    = map(string)
  })
  description = "Values for a single environment, including rg_name and tags"
}