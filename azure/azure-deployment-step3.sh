#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 3: Create common resources.
#
# This script creates the resources on the Windows Azure subscription which will
# be shared by all VMs, including affinity group, storage account and
# virtual network.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Step 3: Create common resources"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh

echo "Creating affinity group $AZURE_DEPLOYMENT_NAME at $AZURE_LOCATION"
$AZURE_COMMAND account affinity-group create $AZURE_DEPLOYMENT_NAME --location "$AZURE_LOCATION" || { echo "Error creating affinity group $AZURE_DEPLOYMENT_NAME."; exit 1; }

echo "Creating storage account $AZURE_DEPLOYMENT_NAME"
$AZURE_COMMAND account storage create $AZURE_DEPLOYMENT_NAME --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating storage account $AZURE_DEPLOYMENT_NAME."; exit 1; }

echo "Creating virtual network $AZURE_DEPLOYMENT_NAME"
$AZURE_COMMAND network vnet create $AZURE_DEPLOYMENT_NAME --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual network $AZURE_DEPLOYMENT_NAME."; exit 1; }

echo ""
