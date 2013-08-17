#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 2: Create common resources.
#
# This script creates the resources on the Windows Azure subscription which will
# be shared by all VMs, including affinity group, storage account and
# virtual network.
#
set -o nounset -o errexit

source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 2: Create common resources"
information "******************************************************************************"

# Create affinity group.
echo "Creating affinity group $AZURE_DEPLOYMENT_NAME at $AZURE_DEPLOYMENT_LOCATION"
$AZURE_COMMAND account affinity-group create $AZURE_DEPLOYMENT_NAME --location "$AZURE_DEPLOYMENT_LOCATION" || fail "Error creating affinity group $AZURE_DEPLOYMENT_NAME."

# Create storage account.
echo "Creating storage account $AZURE_DEPLOYMENT_NAME"
$AZURE_COMMAND account storage create $AZURE_DEPLOYMENT_NAME --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating storage account $AZURE_DEPLOYMENT_NAME."

# Create virtual network.
echo "Creating virtual network $AZURE_DEPLOYMENT_NAME"
$AZURE_COMMAND network vnet create $AZURE_DEPLOYMENT_NAME --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating virtual network $AZURE_DEPLOYMENT_NAME."

echo ""
