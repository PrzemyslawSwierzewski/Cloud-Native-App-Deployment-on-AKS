locals {
  environments = {
    dev = {
      name     = "dev"
      rg_name  = "dev_cloud_native_app"
      location = "northeurope"
      tags = {
        environment = "development"
      }
    }
  }
}