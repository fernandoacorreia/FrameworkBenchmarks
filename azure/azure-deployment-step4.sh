#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 4: Create virtual machines.
#
# This script creates virtual machines used in the benchmark.
# The virtual machine names are composed of the deployment name and a prefix:
# * "cli": Ubuntu 12.04 virtual machine for the benchmark client.
# * "lsr": Ubuntu 12.04 virtual machine for the Linux server.
# * "wsr": Windows Server 2012 virtual machine for the Windows server.
#
# The size of the VMs to be created is defined in the configuration.
# The virtual machines are created with a default OS disk and without any additional data disks.
# For more information refer to https://www.windowsazure.com/en-us/documentation/services/virtual-machines/
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Step 4: Create virtual machines"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh

LATEST_UBUNTU_IMAGE=$($AZURE_COMMAND vm image list | grep Ubuntu_DAILY_BUILD-precise-12_04_2-LTS-amd64-server | sort | tail -1 | cut -c 10-114)
echo "Latest daily Ubuntu 12.04 image:"
echo $LATEST_UBUNTU_IMAGE

CLIENT_VM_NAME="${AZURE_DEPLOYMENT_NAME}cli"
echo "Creating client VM: $CLIENT_VM_NAME"
$AZURE_COMMAND vm create $CLIENT_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu ${CLIENT_VM_NAME}Password --vm-name $CLIENT_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual machine $CLIENT_VM_NAME."; exit 1; }

LINUX_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}lsr"
echo "Creating Linux server VM: $LINUX_SERVER_VM_NAME"
$AZURE_COMMAND vm create $LINUX_SERVER_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu ${LINUX_SERVER_VM_NAME}Password --vm-name $LINUX_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual machine $LINUX_SERVER_VM_NAME."; exit 1; }

# TODO --ssh-cert <pem-file|fingerprint>  SSH certificate                              
# TODO --no-ssh-password                  remove password support when using --ssh-cert

echo ""
