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
source ./azure-deployment-common.sh

# Create directory for keys.
echo "Creating directory for keys at $AZURE_SSH_DIR"
mkdir -p ${AZURE_SSH_DIR} || fail "Error creating directory $AZURE_SSH_DIR."

# Create key files.
echo "Creating key at $AZURE_KEY_FILE"
ssh-keygen -t rsa -b 2048 -f "$AZURE_KEY_FILE" -C "$AZURE_KEY_NAME" -q -N "" || fail "Error creating SSH key."
echo "--------------------------------------------------------------------------------"
echo "WARNING: Protect this key file. It has no passphrase and is stored in plaintext."
echo "--------------------------------------------------------------------------------"

echo "Creating PEM file at $AZURE_PEM_FILE"
openssl req -new -x509 -days 365 -subj "/CN=$AZURE_DEPLOYMENT_NAME/O=Web Framework Benchmarks" -key "$AZURE_KEY_FILE" -out "$AZURE_PEM_FILE" || fail "Error creating PEM file."
chmod 600 "$AZURE_PEM_FILE"

echo "Creating CER file at $AZURE_CER_FILE"
openssl x509 -outform der -in "$AZURE_PEM_FILE" -out "$AZURE_CER_FILE" || fail "Error creating CER file."
chmod 600 "$AZURE_CER_FILE"

# Get latest Ubuntu Server 12.04 daily VM image.
echo "Latest Ubuntu Server 12.04 image:"
LATEST_UBUNTU_IMAGE=$($AZURE_COMMAND vm image list | grep Ubuntu_DAILY_BUILD-precise-12_04_2-LTS-amd64-server | sort | tail -1 | cut -c 10-120)
echo $LATEST_UBUNTU_IMAGE

# Create Ubuntu server VM.
echo "Creating Linux server VM: $LINUX_SERVER_VM_NAME"
$AZURE_COMMAND vm create $LINUX_SERVER_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu --ssh-cert "$AZURE_PEM_FILE" --no-ssh-password --vm-name $LINUX_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating virtual machine $LINUX_SERVER_VM_NAME."

# Create client VM.
echo "Creating client VM: $CLIENT_VM_NAME"
$AZURE_COMMAND vm create $CLIENT_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu --ssh-cert "$AZURE_PEM_FILE" --no-ssh-password --vm-name $CLIENT_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating virtual machine $CLIENT_VM_NAME."

# Get latest Windows Server 2012 Datacenter image.
echo "Latest Windows Server 2012 Datacenter image:"
LATEST_WINDOWS_IMAGE=$($AZURE_COMMAND vm image list | grep Windows-Server-2012-Datacenter | sort | tail -1 | cut -c 10-120)
echo $LATEST_WINDOWS_IMAGE

# Create Windows server VM.
echo "Creating Windows server VM: $WINDOWS_SERVER_VM_NAME"
$AZURE_COMMAND vm create $WINDOWS_SERVER_VM_NAME $LATEST_WINDOWS_IMAGE Administrator $AZURE_WINDOWS_PASSWORD --vm-name $WINDOWS_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --rdp --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating virtual machine $WINDOWS_SERVER_VM_NAME."

# Create SQL Server VM.
echo "SQL Server image:"
echo $SQL_SERVER_IMAGE
echo "Creating SQL Server VM: $SQL_SERVER_VM_NAME"
SQL_SERVER_IMAGE="fb83b3509582419d99629ce476bcb5c8__Microsoft-SQL-Server-2012SP1-CU4-11.0.3368.0-Standard-ENU-Win2012"
$AZURE_COMMAND vm create $SQL_SERVER_VM_NAME $SQL_SERVER_IMAGE Administrator $AZURE_WINDOWS_PASSWORD --vm-name $SQL_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --rdp --affinity-group $AZURE_DEPLOYMENT_NAME || fail "Error creating virtual machine $SQL_SERVER_VM_NAME."

echo ""
