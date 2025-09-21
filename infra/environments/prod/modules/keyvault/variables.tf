variable "environment" {
  type = object({
    name     = string
    rg_name  = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "sku_name_key_vault" {
  type        = string
  default     = "standard"
  description = "SKU for the key vault"
}

# ===========================
# Backend Variables
# ===========================

variable "backend_NODE_ENV" {
  description = "Node.js environment (e.g., production, development, staging)"
  type        = string
}

variable "backend_PORT" {
  description = "Port number for the backend application"
  type        = string
}

variable "backend_SECRET" {
  description = "Generic secret for backend usage"
  type        = string
  sensitive   = true
}

variable "backend_KEY" {
  description = "Backend key used for encryption or authentication"
  type        = string
  sensitive   = true
}

variable "backend_JWT_SCHEME" {
  description = "JWT scheme key used in backend authentication"
  type        = string
}

variable "backend_JWT_TOKEN_PREFIX" {
  description = "JWT token prefix (e.g., Bearer)"
  type        = string
}

variable "backend_JWT_SECRET" {
  description = "JWT secret for signing tokens"
  type        = string
  sensitive   = true
}

variable "backend_JWT_TOKEN_EXPIRATION" {
  description = "JWT token expiration time (e.g., 3600s)"
  type        = string
}

variable "backend_JWT_TOKEN_HASH_ALGO" {
  description = "Hash algorithm for JWT tokens (e.g., HS256)"
  type        = string
}

# ===========================
# MongoDB Variables
# ===========================

variable "mongo_DATABASE" {
  description = "MongoDB connection string or database URL"
  type        = string
  sensitive   = true
}

variable "mongo_MONGO_DB" {
  description = "MongoDB database name"
  type        = string
}