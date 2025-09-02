terraform {
#   backend "remote" {
#     organization = "personal-org-prem"

#     workspaces {
#       name = "cloud-native-project"
#     }
#   }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }

  required_version = "~> 1.13.1"
}

provider "azurerm" {
  features {
  }
  subscription_id = "0610cfd0-65fa-4a7a-9d82-582300455c0a"
}