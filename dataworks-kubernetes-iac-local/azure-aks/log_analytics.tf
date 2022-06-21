resource "azurerm_log_analytics_workspace" "aks_analytics" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  
  name                = "${var.prefix}-workspace"
  location            = data.azurerm_resource_group.aks_rg.location
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days
  
  tags                = "${merge(tomap({"Name" = "${var.prefix}-workspace"}), "${local.tags}")}"
}

resource "azurerm_log_analytics_solution" "aks_analytics_solution" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.aks_rg.location
  resource_group_name   = data.azurerm_resource_group.aks_rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.aks_analytics[0].id
  workspace_name        = azurerm_log_analytics_workspace.aks_analytics[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags                  = "${merge(tomap({"Name" = "${var.prefix}-solution"}), "${local.tags}")}"
}