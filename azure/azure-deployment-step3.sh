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

AZURE_AFFINITY_GROUP="$AZURE_DEPLOYMENT_NAME"
echo "Creating affinity group $AZURE_AFFINITY_GROUP at $AZURE_LOCATION"
$AZURE_COMMAND account affinity-group create $AZURE_AFFINITY_GROUP --location "$AZURE_LOCATION"

echo ""
