#Azure resource Provider is used to configure infrastructure on Azure via azure resource manager api.
#here you can configure client_id, environment, subscription_id, tenant_id for infrastructure to be configured.

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "6310f5e0-79d6-42a5-9e74-2628a74679aa"
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.50"
    }
  }
  backend "azurerm" {
    resource_group_name   = "DWProductionUS"
    storage_account_name  = "dwcentralusdata"
    container_name        = "terraformstatedw"
    key                   = "aks-dev.tfstate"
    #key                   = "sbx-aks.tfstate"
  }
}