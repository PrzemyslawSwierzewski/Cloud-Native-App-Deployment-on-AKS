locals {
  environments = {
    dev = {
      name = "dev"
      rg_name = "dev_cloud_native_app"
      location = "northeurope"
      tags = {
        environment = "development"
      }
    }
    prod = {
      name = "prod"
      rg_name = "prod_cloud_native_app"
      location = "northeurope"
      tags = {
        environment = "production"
      }
    }
    stage = {
      name = "stage"
      rg_name = "stage_cloud_native_app"
      location = "northeurope"
      tags = {
        environment = "staging"
      }
    }
  }
}
