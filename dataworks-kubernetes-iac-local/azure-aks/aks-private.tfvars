####
# shared value
####
environment_name            = "Prod"
client_name                 = "Dataworks"
infra_name                  = "aks"


####
# Resource group 
####
rg_name = "DWProductionUS"
rg_location = "Central US"
vnet_name = "DWProductionUS-vnet"
aci_subnet = ["10.241.0.0/16"]


####
# AKS Cluster config
####
prefix = "DWProdUS"
kubernetes_version = "1.20.5" 
private_cluster_enabled = "true"
sku_tier = "Free"
admin_username = "aks_admin"
public_ssh_key = ""


######
## Identity
#####
client_id = "33d44d58-17f4-4e8c-86a2-dd1c953aa98e"
client_secret = "QRzQjXE_L6zcqIlw7Sk7uryul71MKR7Dp-"
#user_assigned_identity_id =

#####
## Addons
####
enable_http_application_routing = "false"
enable_kube_dashboard = "false"
enable_azure_policy = "false"
enable_aci_connector_linux = true
aci_connector_linux_subnet_name = "virtual-node-aci"


#####
## RBAC
#####
enable_role_based_access_control = "true"
rbac_aad_managed = "true"
rbac_aad_admin_group_object_ids = ["6e9781bf-60d9-4a03-b9bd-f632cbb24f92"]


####
## network
####
network_plugin = "azure"
network_policy = ""   
net_profile_docker_bridge_cidr = "172.17.0.1/16"
net_profile_pod_cidr = null
net_profile_service_cidr = "10.0.0.0/16"
load_balancer_sku = "Standard"
dns_service_ip = "10.0.0.10"

#####
## Pool
#####
enable_auto_scaling = "true"
agents_pool_name = "nodepool"
agents_max_count = 3
agents_min_count = 1
agents_count = 1
agents_size  = "Standard_D4s_v3"
orchestrator_version = "1.19.11"
agents_availability_zones = [1,2,3]
agents_type = "VirtualMachineScaleSets"
enable_host_encryption = false
max_pods = null
os_disk_size_gb = 50
vnet_subnet_id = "/subscriptions/6310f5e0-79d6-42a5-9e74-2628a74679aa/resourceGroups/DWProductionUS/providers/Microsoft.Network/virtualNetworks/DWProductionUS-vnet/subnets/default" 
only_critical_addons_enabled = false
agents_labels  = {
  env = "Prod"
  os = "Linux"
}

####
# analytics workspace
####
enable_log_analytics_workspace = false
log_analytics_workspace_sku = "PerGB2018"
log_retention_in_days = 75

#####
## Premission
#####
enable_attach_acr = true
acr_id = "/subscriptions/6310f5e0-79d6-42a5-9e74-2628a74679aa/resourceGroups/DWProductionUS/providers/Microsoft.ContainerRegistry/registries/dwproductioncentralus"