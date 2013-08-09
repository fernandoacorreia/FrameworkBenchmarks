#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 1: Validate configuration.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************"
echo "Step 1: Validate configuration"
echo "******************************"

source ./azure-deployment-configuration.sh
echo "$AZURE_DEPLOYMENT_SUBSCRIPTION"

echo ""
