#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 2: Configure Windows Azure command line tools
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Step 2: Configure Windows Azure command line tools"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh

AZURE_HOME=$(eval echo ~${SUDO_USER})/.azure
echo "Creating Windows Azure configuration directory at $AZURE_HOME"
mkdir -p ${AZURE_HOME} || { echo "Error creating directory directory $AZURE_HOME."; exit 1; }

echo "Importing publish settings at $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"
$AZURE_COMMAND account import $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION || { echo "Error importing publish settings."; exit 1; }

echo "Setting default subscription to $AZURE_DEPLOYMENT_SUBSCRIPTION"
$AZURE_COMMAND account set "$AZURE_DEPLOYMENT_SUBSCRIPTION" || { echo "Error setting default subscription."; exit 1; }

echo ""
