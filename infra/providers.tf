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
  subscription_id = "453fff99-3dc5-43fe-8c3d-92600fc84416"
}