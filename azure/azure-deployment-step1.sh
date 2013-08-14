#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 1: Validate configuration.
#
# This scripts does some basic validation of the configuration parameters to avoid
# starting to create some resources and abort later because of a misconfiguration.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS
set -o nounset -o errexit

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 1: Validate configuration"
information "******************************************************************************"

# Validate AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION.
if [ -z "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION" ]; then fail "AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION is not defined."; fi
if [ ! -f $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION ]; then fail "File not found: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"; fi
echo "Publish settings file: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"

# Validate AZURE_DEPLOYMENT_SUBSCRIPTION.
if [ -z "$AZURE_DEPLOYMENT_SUBSCRIPTION" ]; then fail "AZURE_DEPLOYMENT_SUBSCRIPTION is not defined."; fi
echo "Subscription: $AZURE_DEPLOYMENT_SUBSCRIPTION"

# Validate AZURE_DEPLOYMENT_LOCATION.
if [ -z "$AZURE_DEPLOYMENT_LOCATION" ]; then fail "AZURE_DEPLOYMENT_LOCATION is not defined."; fi
echo "Location: $AZURE_DEPLOYMENT_LOCATION"

# Validate AZURE_DEPLOYMENT_NAME.
if [ -z "$AZURE_DEPLOYMENT_NAME" ]; then fail "AZURE_DEPLOYMENT_NAME is not defined."; fi
if [ ${#AZURE_DEPLOYMENT_NAME} -gt 12 ]; then fail "AZURE_DEPLOYMENT_NAME must be at most 12 characters long."; fi
echo "Deployment name: $AZURE_DEPLOYMENT_NAME"

# Validate $AZURE_WINDOWS_PASSWORD.
if [ -z "$AZURE_WINDOWS_PASSWORD" ]; then fail "AZURE_WINDOWS_PASSWORD is not defined."; fi
if [ ${#AZURE_WINDOWS_PASSWORD} -lt 10 ]; then fail "AZURE_WINDOWS_PASSWORD must be at least 10 characters long."; fi

# Validate AZURE_DEPLOYMENT_VM_SIZE.
if [ -z "$AZURE_DEPLOYMENT_VM_SIZE" ]; then fail "AZURE_DEPLOYMENT_VM_SIZE is not defined."; fi
echo "VM size: $AZURE_DEPLOYMENT_VM_SIZE"

# Validate AZURE_COMMAND.
if [ -z "$AZURE_COMMAND" ]; then fail "AZURE_COMMAND is not defined."; fi

echo ""
