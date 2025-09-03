variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "vm_memory_bytes" {
  type        = number
  description = "Total VM memory in bytes (used for memory alert threshold)"
  default     = 4000000000
}

variable "alert_severity_cpu" {
  type        = number
  description = "Severity for CPU alerts (1=critical, 2=warning, etc.)"
  default     = 1
}

variable "alert_severity_memory" {
  type        = number
  description = "Severity for memory alerts (1=critical, 2=warning, etc.)"
  default     = 1
}
variable "kubernetes_cluster_id" {
  type        = string
  description = "ID of the Kubernetes cluster"
}

variable "acr_id" {
  type        = string
  description = "ID of the Azure Container Registry"
}

variable "nsg_id" {
  type        = string
  description = "ID of the Network Security Group"
}

variable "vnet_id" {
  type        = string
  description = "ID of the Virtual Network"
}

variable "vault_key_id" {
  type        = string
  description = "ID of the Key Vault"
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the resource owner"
  default     = "owner@example.com"
}