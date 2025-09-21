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
      vm_size    = "Standard_d4as_v5"
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

variable "NODE_ENV" {
  description = "Node.js environment (e.g., production, development, staging)"
  type        = string
}

variable "PORT" {
  description = "Port number for the backend application"
  type        = string
}

variable "SECRET" {
  description = "Generic secret for backend usage"
  type        = string
  sensitive   = true
}

variable "KEY" {
  description = "Backend key used for encryption or authentication"
  type        = string
  sensitive   = true
}

variable "KEY_JWT_SCHEME" {
  description = "JWT scheme key used in backend authentication"
  type        = string
}

variable "JWT_TOKEN_PREFIX" {
  description = "JWT token prefix (e.g., Bearer)"
  type        = string
}

variable "JWT_SECRET" {
  description = "JWT secret for signing tokens"
  type        = string
  sensitive   = true
}

variable "JWT_TOKEN_EXPIRATION" {
  description = "JWT token expiration time (e.g., 3600s)"
  type        = string
}

variable "JWT_TOKEN_HASH_ALGO" {
  description = "Hash algorithm for JWT tokens (e.g., HS256)"
  type        = string
}

# ===========================
# MongoDB Variables
# ===========================

variable "DATABASE" {
  description = "MongoDB connection string or database URL"
  type        = string
  sensitive   = true
}

variable "MONGO_DB" {
  description = "MongoDB database name"
  type        = string
}