####
# shared value
####

variable "environment_name" {
    type = string
    description = "name of environment"
    default = "null"
}

variable "client_name" {
    type = string
    description = "name of client"
    default = "null"
}

variable "infra_name" {
    type = string
    description = "name of infra"
    default = "null"
}



####
# Resource group 
####
variable "rg_name" {
  description = "name for resource group"
  type = string
}

variable "rg_location" {
  description = "location for resource group"
  type = string
}
 variable "vnet_name" {
   description = "name of the vnet"
   type = string
   default = null
 }
 
 variable "aci_subnet" {
   type = list
   description = "address prefix for subnet"
 }

####
# AKS Cluster config
####
variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
  default     = "test-eks" 
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = "1.18.14"
}

variable "private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = string
  default     = "false"
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Free"
}


variable "admin_username" {
  type = string
  description = "username for linux profile"
  default = "aks_admin"
}

variable "public_ssh_key" {
  type = string
  sensitive = true
  description = "public ssh key for cluster"
  default = null
}



######
## Identity
#####a
variable "client_id" {
  description = "(Optional) The Client ID (appId) for the Service Principal used for the AKS deployment"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "(Optional) The Client Secret (password) for the Service Principal used for the AKS deployment"
  type        = string
  default     = ""
}

variable "user_assigned_identity_id" {
  type = string
  description = "The ID of a user assigned identity."
  default = ""
}


####
## Addons
####

variable "enable_http_application_routing" {
  description = "Enable HTTP Application Routing Addon (forces recreation)."
  type        = string
  default     = "false"
}

variable "enable_kube_dashboard" {
  description = "Enable Kubernetes Dashboard."
  type        = string
  default     = "false"
}


variable "enable_azure_policy" {
  description = "Enable Azure Policy Addon."
  type        = string
  default     = "false"
}

variable "enable_aci_connector_linux" {
  type = string
  description = "Make virtual node addon enabled"
  default = false
}

variable "aci_connector_linux_subnet_name" {
  type = string
  description = "subnet name for virtual nodes with aci delegation attached"
}



#####
## RBAC
#####
variable "enable_role_based_access_control" {
  description = "Enable Role Based Access Control."
  type        = string
  default     = "false"
}

variable "rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = string
  default     = "false"
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access."
  type        = list(string)
  default     = null
}




####
# network
####

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "kubenet"
}

variable "network_policy" {
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = null
}



variable "net_profile_docker_bridge_cidr" {
  description = "(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
  default     = null
}


variable "net_profile_pod_cidr" {
  description = " (Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "load_balancer_sku" {
  type = string
  description = "set sku for loadbalancer to be used."
  default = "Standard"
}

variable "dns_service_ip" {
  type = string
  description = "IP address within the Kubernetes service address range"
  default = ""
}


####
## Pool
####

variable "enable_auto_scaling" {
  description = "Enable node pool autoscaling"
  type        = string
  default     = "false"
}

variable "agents_pool_name" {
  description = "The default Azure AKS agentpool (nodepool) name."
  type        = string
  default     = "nodepool"
}


variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool. if auto-scale enabled must b/w min & max agent count"
  default     = null
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = null
}

variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  type        = string
  default     = "1"
}

variable "agents_size" {
  default     = "Standard_DS1_v2"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}


variable "agents_labels" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default     = {}
}



#use as per the k8s used for cluster
variable "orchestrator_version" {
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

#This requires that the type is set to VirtualMachineScaleSets and that load_balancer_sku is set to Standard.
variable "agents_availability_zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = [1,2,3]
}

variable "agents_type" {
  description = "The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "availability_zones" {
  type = list
  description = "create a list of availablity zones to disrtribute nodes"
  default = []
}

variable "enable_host_encryption" {
  type = string
  description = "To enable host encryption for node pool"
  default = false
}

variable "max_pods" {
  type = string
  description = "Max number of pods on a node"
}


variable "vnet_subnet_id" {
  description = "The ID of a Subnet where the Kubernetes Node Pool should exist.Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "only_critical_addons_enabled" {
  description = "Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule taint.Changing this forces a new resource to be created."
  type        = string
  default     = false
}

variable "os_disk_size_gb" {
  type = string
  description = "specify disk size for nodes"
  default = 15
}


####
# analytics workspace
####
variable "enable_log_analytics_workspace" {
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  type = string
  default = "true" 
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}


#####
## Premission
#####
 
variable "enable_attach_acr" {
  type = string
  description = "Attach permission to pull image from ACR."
  default = false
}

variable "acr_id" {
  type = string
  description = "ACR id to attach acr permission"
  default = null
}
