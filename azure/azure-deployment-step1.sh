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

echo "******************************************************************************"
echo "Step 1: Validate configuration"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh

if [ -z "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION" ]; then echo "AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION is not defined."; exit 1; fi
if [ ! -f $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION ]; then echo "File not found: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"; exit 1; fi
echo "Publish settings file: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"

if [ -z "$AZURE_DEPLOYMENT_SUBSCRIPTION" ]; then echo "AZURE_DEPLOYMENT_SUBSCRIPTION is not defined."; exit 1; fi
echo "Subscription: $AZURE_DEPLOYMENT_SUBSCRIPTION"

if [ -z "$AZURE_DEPLOYMENT_LOCATION" ]; then echo "AZURE_DEPLOYMENT_LOCATION is not defined."; exit 1; fi
echo "Location: $AZURE_DEPLOYMENT_LOCATION"

if [ -z "$AZURE_DEPLOYMENT_NAME" ]; then echo "AZURE_DEPLOYMENT_NAME is not defined."; exit 1; fi
if [ ${#AZURE_DEPLOYMENT_NAME} -gt 12 ]; then echo "AZURE_DEPLOYMENT_NAME must be at most 12 characters long."; exit 1; fi
echo "Deployment name: $AZURE_DEPLOYMENT_NAME"

if [ -z "$AZURE_DEPLOYMENT_VM_SIZE" ]; then echo "AZURE_DEPLOYMENT_VM_SIZE is not defined."; exit 1; fi
echo "VM size: $AZURE_DEPLOYMENT_VM_SIZE"

if [ -z "$AZURE_COMMAND" ]; then echo "AZURE_COMMAND is not defined."; exit 1; fi

echo ""
