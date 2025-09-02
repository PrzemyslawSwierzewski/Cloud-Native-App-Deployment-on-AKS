resource "azurerm_resource_group" "infra_rgs" {
  for_each = local.environments

  name     = each.value.rg_name
  location = each.value.location
}

module "dev_acr" {
    source = "./environments/dev/modules/acr"

    acr-sku = var.acr-sku
    environment = local.environments.dev
}

module "dev_iam" {
    source = "./environments/dev/modules/iam"

    environment = local.environment.dev
}