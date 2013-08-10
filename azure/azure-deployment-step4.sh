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

# Create directory for keys.
AZURE_SSH_DIR=$(eval echo ~${SUDO_USER})/.ssh
echo "Creating directory for keys at $AZURE_SSH_DIR"
mkdir -p ${AZURE_SSH_DIR} || { echo "Error creating directory $AZURE_SSH_DIR."; exit 1; }

# Create key files.
AZURE_KEY_NAME="id_rsa-${AZURE_DEPLOYMENT_NAME}"
AZURE_KEY_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}"
echo "Creating key at $AZURE_KEY_FILE"
ssh-keygen -t rsa -b 2048 -f "$AZURE_KEY_FILE" -C "$AZURE_KEY_NAME" -q -N "" || { echo "Error creating SSH key."; exit 1; }
echo "--------------------------------------------------------------------------------"
echo "WARNING: Protect this key file. It has no passphrase and is stored in plaintext."
echo "--------------------------------------------------------------------------------"

AZURE_PEM_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.x509.pub.pem"
echo "Creating PEM file at $AZURE_PEM_FILE"
openssl req -new -x509 -days 365 -subj "/CN=$AZURE_DEPLOYMENT_NAME/O=Web Framework Benchmarks" -key "$AZURE_KEY_FILE" -out "$AZURE_PEM_FILE" || { echo "Error creating PEM file."; exit 1; }
chmod 600 "$AZURE_PEM_FILE"

AZURE_CER_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.cer"
echo "Creating CER file at $AZURE_CER_FILE"
openssl x509 -outform der -in "$AZURE_PEM_FILE" -out "$AZURE_CER_FILE"
chmod 600 "$AZURE_CER_FILE"

# Get latest Ubuntu Server 12.04 daily VM image.
LATEST_UBUNTU_IMAGE=$($AZURE_COMMAND vm image list | grep Ubuntu_DAILY_BUILD-precise-12_04_2-LTS-amd64-server | sort | tail -1 | cut -c 10-120)
echo "Latest Ubuntu Server 12.04 image:"
echo $LATEST_UBUNTU_IMAGE

# Create client VM.
CLIENT_VM_NAME="${AZURE_DEPLOYMENT_NAME}cli"
echo "Creating client VM: $CLIENT_VM_NAME"
$AZURE_COMMAND vm create $CLIENT_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu --ssh-cert "$AZURE_PEM_FILE" --no-ssh-password --vm-name $CLIENT_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual machine $CLIENT_VM_NAME."; exit 1; }
echo "You can connect with SSH to this instance with this command:"
echo "ssh -l ubuntu -i $AZURE_KEY_FILE $CLIENT_VM_NAME.cloudapp.net"

# Create Ubuntu server VM.
LINUX_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}lsr"
echo "Creating Linux server VM: $LINUX_SERVER_VM_NAME"
$AZURE_COMMAND vm create $LINUX_SERVER_VM_NAME $LATEST_UBUNTU_IMAGE ubuntu --ssh-cert "$AZURE_PEM_FILE" --no-ssh-password --vm-name $LINUX_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --ssh --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual machine $LINUX_SERVER_VM_NAME."; exit 1; }
echo "You can connect with SSH to this instance with this command:"
echo "ssh -l ubuntu -i $AZURE_KEY_FILE $LINUX_SERVER_VM_NAME.cloudapp.net"

# Get latest Windows Server 2012 Datacenter image.
LATEST_WINDOWS_IMAGE=$($AZURE_COMMAND vm image list | grep Windows-Server-2012-Datacenter | sort | tail -1 | cut -c 10-120)
echo "Latest Windows Server 2012 Datacenter image:"
echo $LATEST_WINDOWS_IMAGE

# Create Windows server VM.
WINDOWS_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}wsr"
echo "Creating Windows server VM: $WINDOWS_SERVER_VM_NAME"
$AZURE_COMMAND vm create $WINDOWS_SERVER_VM_NAME $LATEST_WINDOWS_IMAGE Administrator ${WINDOWS_SERVER_VM_NAME}Password --vm-name $WINDOWS_SERVER_VM_NAME --vm-size $AZURE_DEPLOYMENT_VM_SIZE --virtual-network-name $AZURE_DEPLOYMENT_NAME --rdp --affinity-group $AZURE_DEPLOYMENT_NAME || { echo "Error creating virtual machine $WINDOWS_SERVER_VM_NAME."; exit 1; }

echo ""
