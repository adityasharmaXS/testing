resource "azurerm_subnet" "subnet_aci" {
  count                = var.enable_aci_connector_linux == true && var.aci_connector_linux_subnet_name == ""  ? 1 : 0

  name                 = "aci-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.aci_subnet

  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_user_assigned_identity" "aci_network" {
  count                = var.enable_aci_connector_linux == true && var.aci_connector_linux_subnet_name == "" ? 1 : 0
  
  resource_group_name = var.rg_name
  location            = data.azurerm_resource_group.aks_rg.location

  name = "identity-${var.rg_name}-aks"
}

resource "azurerm_role_assignment" "aci_network" {
  count                = var.enable_aci_connector_linux == true && var.aci_connector_linux_subnet_name == "" ? 1 : 0
  scope                = data.azurerm_resource_group.aks_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aci_network[0].principal_id
}