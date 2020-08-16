variable "subscription_id" {
  # Default for Dev, Test, Production, Uat
}

variable "infra_resource_group_name" {
  type = string
}

variable "location" {
  default = "westeurope"
}

variable "environment" {
  type    = string
  default = "Testing"
}

variable "cluster_name" {
  type    = string
}

variable "tenant_id" {
  type    = string
}

variable "k8s_version" {
  type    = string
  # default = "1.17.9"
}

// No special chars allowed this will lead to an empty 400!
variable "dns_prefix" {
}

variable "agent_count" {
  default = 4
}

variable "vm_size" {
  default = "Standard_DS2_v2"
  # As additional information we should use VM\node SKU size with at least 7GB or 8GB memory.
  # This means to use Standard_DS2_v2 or Standard_DS2_v3 so we don’t face problems running deployments over AKS.
}


variable "ssh_public_key_base64" {
  type    = string
  default = "~/.ssh/rhk-testing_id_rsa.pub"
  # This ssh-key was generated locally and should be shared to access to the cluster machine
}

# We are using a specific service principal app registration called RHK-Assessment
# in order to access a secure way to the azure platform from Terraform
# Application (Client) ID of RHK-Assessment Azure Application Registration
variable "client_id" {
}

# service_principal_password_k8s client secret of RHK-Assessment Azure Application Registration
variable "client_secret" {
}

variable "registry_name" {
  default = "rhkContainerRegistry"
}