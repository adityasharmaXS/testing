resource "azurerm_kubernetes_cluster" "aks_cluster" {

  name                      = "${var.prefix}"
  location                  = data.azurerm_resource_group.aks_rg.location
  resource_group_name       = data.azurerm_resource_group.aks_rg.name
  kubernetes_version        = "${var.kubernetes_version}"
  dns_prefix                = "${var.prefix}"
  sku_tier                  = "${var.sku_tier}"
  private_cluster_enabled   = "${var.private_cluster_enabled}"
#  automatic_channel_upgrade = "${var.automatic_channel_upgrade}"   #still in priview state


  addon_profile {
    aci_connector_linux {
      enabled     = var.enable_aci_connector_linux
      subnet_name = var.enable_aci_connector_linux && var.aci_connector_linux_subnet_name == "" ? azurerm_subnet.subnet_aci[0].name : var.aci_connector_linux_subnet_name
    }

    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.aks_analytics[0].id : null
    }
 }

  linux_profile {
    admin_username = var.admin_username

    ssh_key { 
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key == "" ? tls_private_key.ssh[0].public_key_openssh : var.public_ssh_key, "\n", "")
    }
  }


  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }


  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
    content {
      type = var.user_assigned_identity_id == "" ? "SystemAssigned" : "UserAssigned"
      user_assigned_identity_id = var.user_assigned_identity_id == "" ? null : var.user_assigned_identity_id
    }
  }
  


  network_profile {
    network_plugin     = var.network_plugin   
    network_policy     = var.network_plugin == "azure" ? "azure" : var.network_policy
    docker_bridge_cidr = var.network_plugin == "azure" ? var.net_profile_docker_bridge_cidr: null
    pod_cidr           = var.network_plugin == "azure" ? null : var.net_profile_pod_cidr
    service_cidr       = var.network_plugin == "azure" ? var.net_profile_service_cidr: null
    load_balancer_sku  = var.network_plugin == "azure" ? "Standard" : var.load_balancer_sku
    dns_service_ip     = var.network_plugin == "azure" ? var.dns_service_ip : null
  }

  
  role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }
  }


  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling != null ? ["default_node_pool_scaled"] : []
    content {
      orchestrator_version          = var.orchestrator_version
      name                          = var.agents_pool_name
      node_count                    = var.enable_auto_scaling == "true" ? null : var.agents_count
      vm_size                       = var.agents_size
      os_disk_size_gb               = var.os_disk_size_gb
      enable_auto_scaling           = var.enable_auto_scaling
      max_count                     = var.enable_auto_scaling == "true" ? var.agents_max_count: null
      min_count                     = var.enable_auto_scaling == "true" ? var.agents_min_count: null
      availability_zones            = var.availability_zones
      enable_host_encryption        = var.enable_host_encryption
      max_pods                      = var.max_pods
      type                          = var.availability_zones != [] ? "VirtualMachineScaleSets" : var.agents_type
      vnet_subnet_id                = var.vnet_subnet_id
      only_critical_addons_enabled  = var.only_critical_addons_enabled

      node_labels                   = var.agents_labels
      tags                          = merge(tomap({"Name" = "${var.prefix}-aks-pool"}), "${local.tags}")
    }
  }

  tags                        = merge(tomap({"Name" = "${var.prefix}-aks"}), "${local.tags}")

    lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].tags
    ]
  }
}

#Permission for azure continer registry 
resource "azurerm_role_assignment" "attach_acr" {
  count = var.enable_attach_acr ? 1 : 0

  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks" {
  count = var.enable_log_analytics_workspace == true && var.client_id != "" ? 1 : 0

  scope                = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}