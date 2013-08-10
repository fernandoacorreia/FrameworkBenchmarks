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

# Wait for VM to become ready.
wait_until_vm_ready $LINUX_SERVER_VM_NAME

# Install prerequisites.
echo ""
run_remote_script "Instaling prerequisites." "ubuntu" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-1.sh"

# Configure firewall.
# TODO

# Clone project repository.
# TODO

# Install software.
# TODO

echo ""
