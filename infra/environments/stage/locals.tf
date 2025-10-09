locals {
  environments = {
    stage = {
      name     = "stage"
      rg_name  = "stage_cloud_native_app"
      location = "northeurope"
      tags = {
        environment = "staging"
      }
    }
  }
}