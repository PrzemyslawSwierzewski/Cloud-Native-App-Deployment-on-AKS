module "prod" {
  source = "./environments/prod"

  # Node.js / Backend Variables
  NODE_ENV             = var.NODE_ENV
  PORT                 = var.PORT
  SECRET               = var.SECRET
  KEY                  = var.KEY
  JWT_SCHEME           = var.JWT_SCHEME
  JWT_TOKEN_PREFIX     = var.JWT_TOKEN_PREFIX
  JWT_SECRET           = var.JWT_SECRET
  JWT_TOKEN_EXPIRATION = var.JWT_TOKEN_EXPIRATION
  JWT_TOKEN_HASH_ALGO  = var.JWT_TOKEN_HASH_ALGO

  # MongoDB Variables
  DATABASE = var.DATABASE
  MONGO_DB = var.MONGO_DB
}

module "dev" {
  source = "./environments/dev"

  # Node.js / Backend Variables
  NODE_ENV             = var.NODE_ENV
  PORT                 = var.PORT
  SECRET               = var.SECRET
  KEY                  = var.KEY
  JWT_SCHEME           = var.JWT_SCHEME
  JWT_TOKEN_PREFIX     = var.JWT_TOKEN_PREFIX
  JWT_SECRET                   = var.JWT_SECRET
  JWT_TOKEN_EXPIRATION         = var.JWT_TOKEN_EXPIRATION
  JWT_TOKEN_HASH_ALGO          = var.JWT_TOKEN_HASH_ALGO

  # MongoDB Variables
  DATABASE = var.DATABASE
  MONGO_DB = var.MONGO_DB
}

module "stage" {
  source = "./environments/stage"

  # Node.js / Backend Variables
  NODE_ENV             = var.NODE_ENV
  PORT                 = var.PORT
  SECRET               = var.SECRET
  KEY                  = var.KEY
  JWT_SCHEME           = var.JWT_SCHEME
  JWT_TOKEN_PREFIX     = var.JWT_TOKEN_PREFIX
  JWT_SECRET           = var.JWT_SECRET
  JWT_TOKEN_EXPIRATION = var.JWT_TOKEN_EXPIRATION
  JWT_TOKEN_HASH_ALGO  = var.JWT_TOKEN_HASH_ALGO

  # MongoDB Variables
  DATABASE = var.DATABASE
  MONGO_DB = var.MONGO_DB
}