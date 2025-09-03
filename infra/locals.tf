locals {
  environments = {
    dev = {
      name = "dev"
      rg_name = "dev_cloud_native_app"
      location = "eastus"
      tags = {
        environment = "Development"
      }
    }
    prod = {
      name = "prod"
      rg_name = "prod_cloud_native_app"
      location = "eastus"
      tags = {
        environment = "Production"
      }
    }
    stage = {
      name = "stage"
      rg_name = "stage_cloud_native_app"
      location = "eastus"
      tags = {
        environment = "Staging"
      }
    }
  }
}
