####
# Resoruce group 
####
output "id" {
  value = data.azurerm_resource_group.aks_rg.id
}

####
# AKS output
####
output "public_ssh_key" {
  # Only output a generated ssh public key
  value = var.public_ssh_key != "" ? "" : tls_private_key.ssh[0].public_key_openssh
}


output "client_key" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
}

output "username" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].username
}

output "password" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].password
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

output "location" {
  value = azurerm_kubernetes_cluster.aks_cluster.location
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "kube_config_raw" {
  sensitive = true
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

output "http_application_routing_zone_name" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.addon_profile) > 0 && length(azurerm_kubernetes_cluster.aks_cluster.addon_profile[0].http_application_routing) > 0 ? azurerm_kubernetes_cluster.aks_cluster.addon_profile[0].http_application_routing[0].http_application_routing_zone_name : ""
}

output "system_assigned_identity" {
  value = azurerm_kubernetes_cluster.aks_cluster.identity
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity
}

output "admin_client_key" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.client_key : ""
}

output "admin_client_certificate" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.client_certificate : ""
}

output "admin_cluster_ca_certificate" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.cluster_ca_certificate : ""
}

output "admin_host" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.host : ""
}

output "admin_username" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.username : ""
}

output "admin_password" {
  value = length(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.password : ""
}