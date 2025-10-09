locals {
  environment = {
    prod = {
      name     = "prod"
      rg_name  = "prod-cloud-native-rg"
      location = "northeurope"
      tags = {
        environment = "production"
      }
    }
  }
}