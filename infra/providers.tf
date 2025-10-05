terraform {
  cloud {
    organization = "Prem_learning_org"

    workspaces {
      name = "Cloud-native-app"
    }
  }

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
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "0610cfd0-65fa-4a7a-9d82-582300455c0a"
}