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

variable "JWT_SCHEME" {
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