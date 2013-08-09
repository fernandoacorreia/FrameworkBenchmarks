#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 1: Validate configuration.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Step 1: Validate configuration"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh

if [ -z "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION" ]; then echo "AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION is not defined."; exit 1; fi
if [ ! -f $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION ]; then echo "File not found: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"; exit 1; fi

if [ -z "$AZURE_DEPLOYMENT_SUBSCRIPTION" ]; then echo "AZURE_DEPLOYMENT_SUBSCRIPTION is not defined."; exit 1; fi

if [ -z "$AZURE_COMMAND" ]; then echo "AZURE_COMMAND is not defined."; exit 1; fi

echo ""
