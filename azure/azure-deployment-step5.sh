#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 5: Linux server setup.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Step 5: Linux server setup"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

# Wait for VMs to become ready.
wait_until_vm_ready $CLIENT_VM_NAME
wait_until_vm_ready $LINUX_SERVER_VM_NAME

echo ""
