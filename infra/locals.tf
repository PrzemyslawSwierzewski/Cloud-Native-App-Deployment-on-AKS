locals {
  environments = {
    dev = {
      name = "Development"
      rg_name = "Development-cloud-native-app"
      location = "eastus"
      tags = {
        environment = "Development"
      }
    }
    prod = {
      name = "Production"
      rg_name = "Production-cloud-native-app"
      location = "eastus"
      tags = {
        environment = "Production"
      }
    }
    staging = {
      name = "Staging"
      rg_name = "Staging-cloud-native-app"
      location = "eastus"
      tags = {
        environment = "Staging"
      }
    }
  }
}
