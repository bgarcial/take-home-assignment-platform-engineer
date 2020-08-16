#!/usr/bin/env bash
# -----------------SETTINGS VALUES BY CUSTOMER ----------------------------------------------
# Standard settings values
# The following values should be modified by customer.
# Global variables to assign name conventions to resources
customer_prefix=rhk
customer_environment=tst

# Exporting $customer_prefix and $customer_environment variables to be available from Terraform scripts
export TF_VAR_customer_environment=$customer_environment
export TF_VAR_pgw_customer_prefix=$customer_prefix
# ------------------- END SETTINGS VALUES BY CUSTOMER/ENVIRONMENT-----------------------------

# Create resource group name
# This is a general resource group, and it will be used to store the terraform
# state file. It's different to the resource group created in the
# AzResourceGroup.tf file
RESOURCE_GROUP_NAME=$customer_prefix-terraform-envs-states-rg
az group create --name $RESOURCE_GROUP_NAME --location westeurope
echo "Was created: $RESOURCE_GROUP_NAME"

# STORING TERRAFORM STATE FILES
# Create storage account
# This storage account will be used for store the terraform state files for environments deployments
STORAGE_ACCOUNT_NAME=rhkterraformstates
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l westeurope --sku Standard_LRS --encryption-services blob
# So that is why this storage account is created only once.
# It could be used for other k8s_test/dev/accp/prd.sh bash scripts

# We are getting the storage account key to access to it when we need to store the
# testing terraform state files
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Blob container inside the storage account
# We are going to create a new blob container for the testing environment
# We will have all environments terraform state files in the same
# blob container, but each environment in a different folder.
CONTAINER_NAME=rhkterraformstates
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name created: $STORAGE_ACCOUNT_NAME"
echo "$CONTAINER_NAME storage blob container created to store the terraform.tfstate testing files:"



# Creating Resource group for K8S RHK testing resources created from terraform
# This resource group is only for the terraform RHK resources scope.
# This mean that will be used to store all the infrastructure
# resources created from terraform in .tf files # (except the general resource group and
# the general storage account described previously)
INFRA_RESOURCE_GROUP_NAME=$customer_prefix-$customer_environment-rg
az group create --name $INFRA_RESOURCE_GROUP_NAME --location westeurope

# Assigning name to the resource group which would contain the K8s cluster
export TF_VAR_infra_resource_group_name=$INFRA_RESOURCE_GROUP_NAME

# Determining which subscription create the resources
export TF_VAR_subscription_id="9148bd11-f32b-4b5d-a6c0-5ac5317f29ca"
export TF_VAR_tenant_id="4e6b0716-50ea-4664-90a8-998f60996c44"

# Create an Azure KeyVault
KEYVAULT_NAME=$customer_prefix-ops-kv
echo "Creating $KEYVAULT_NAME key vault..."
az keyvault create -g $INFRA_RESOURCE_GROUP_NAME -l westeurope -n $KEYVAULT_NAME

echo "Key vault $KEYVAULT_NAME created."

# Store the Terraform State Storage Key into KeyVault
echo "Store storage access key into key vault secret..."
az keyvault secret set --name tfstate-storage-key --value $ACCOUNT_KEY --vault-name $KEYVAULT_NAME

echo "Key vault secret created."

# Getting RHK-Assessment Service Principal Client ID
# A RHK-Assessment service principal was created manually previously.
SP_KEY_VAULT_NAME=rhk-kv
SP_APP_ID_SECRET_NAME=RHK-Assessment-ClientId
# This rhk-kv keyvault instance and RHK-Assessment-ClientId secret
# were created manually before to store the appId
rhk_assessment_app_id=$(az keyvault secret show -n $SP_APP_ID_SECRET_NAME --vault-name $SP_KEY_VAULT_NAME --query value --output tsv)
echo "SP_APP_ID_SECRET_NAME" $rhk_assessment_app_id
# Exposing client_id to be readed from terraform scripts
export TF_VAR_client_id=$rhk_assessment_app_id

# Getting RHK-Assessment Service Principal ClientSecret
# A RHK-Assessment service principal was created manually previously.
SP_CLIENT_SECRET_NAME=RHK-Assessment-Client-Secret
# This rhk-kv keyvault instance and RHK-Assessment-Client-Secret secret
# were created manually before to store the client secret
rhk_assessment_client_secret=$(az keyvault secret show -n $SP_CLIENT_SECRET_NAME --vault-name $SP_KEY_VAULT_NAME --query value --output tsv)
# Exposing client_id to be readed from terraform scripts
export TF_VAR_client_secret=$rhk_assessment_client_secret

#Kubernetes clusters parameters
export TF_VAR_cluster_name=RHKTesting
export TF_VAR_dns_prefix=Rhk
export TF_VAR_agent_count=4
export TF_VAR_k8s_version=1.17.9

# -----------------VARIABLES TO BE USED IN THE ../terraform_apply_template.sh file---------------------------------------------
# We pass the variale name of the rhkterraformstates terraform storage account
# previously created to the .../terraform_apply_template.sh shell file
# export TF_VAR_storage_account_name="storage_account_name=tlpstorageaccp"
storage_account_name="storage_account_name=$STORAGE_ACCOUNT_NAME"

# Name of the terraform remote state file
# We expose the statefile variable to be used in the terraform init
# command in the ../terraform_apply_template.sh file
# This directory will be stored in the terraform state directory
# created in AzRemoteState.tf file
statefile="key=TstEnvironment/$customer_prefix-$customer_environment.tfstate"

# We expose the storage_access_key obtained to be used in the terraform
# init command in the ../terraform_apply_template.sh file
storage_access_key="access_key=$ACCOUNT_KEY"

# Name of the resource plan file
# We expose the outfile variable to be used in the terraform plan command
# in the ../terraform_apply_template.sh file
outfile=$customer_prefix-$customer_environment-resource.plan

#include apply script
source ../terraform_apply_template.sh