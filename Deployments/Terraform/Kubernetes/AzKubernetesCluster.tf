provider "azurerm" {
  version = "=2.20.0"
  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.infra_resource_group_name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "bgarcial"

    ssh_key {
      key_data = file(var.ssh_public_key_base64)
      # This ssh-key was generated locally and should be shared to access to the cluster machine
    }
  }

  kubernetes_version = var.k8s_version

  default_node_pool {
    name            = "rhk"
    node_count           = var.agent_count
    vm_size         = var.vm_size
    type            = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 100
    # os_type         = "Linux"
    os_disk_size_gb = 128
    max_pods        = 250

    # Required for advanced networking
    # It means that the cluster will be hosted inside 'azurerm_subnet.testing-aks' subnet
    # created in Deployments/Terraform/Kubernetes/AzVnet.tf
    # vnet_subnet_id = azurerm_virtual_network.aks.subnet.id
    vnet_subnet_id = element(azurerm_virtual_network.aks.subnet.*.id, 0)
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  network_profile {
    network_plugin = "azure"
    # Sets up network policy to be used with Azure CNI. Currently supported values are calico and azure."
    network_policy     = "azure"
    service_cidr       = "100.0.0.0/16"
    dns_service_ip     = "100.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    # Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Use standard for when enable agent_pools availability_zones.
    load_balancer_sku = "Standard"
  }


  tags = {
    Environment = var.environment
  }
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}

