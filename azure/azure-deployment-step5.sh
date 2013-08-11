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

# Get Linux server IP.
echo "Retrieving $LINUX_SERVER_VM_NAME IP:"
LINUX_SERVER_IP=`get_vm_ip $LINUX_SERVER_VM_NAME`
echo "$LINUX_SERVER_IP"

# Get client IP.
echo "Retrieving $CLIENT_VM_NAME IP:"
CLIENT_IP=`get_vm_ip $CLIENT_VM_NAME`
echo "$CLIENT_IP"

# Install prerequisites.
echo ""
run_remote_script "Instaling prerequisites." "ubuntu" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-1.sh" "" || fail "Error running script."

# Copy key to server
echo ""
echo "Uploading key file to $LINUX_SERVER_VM_NAME.cloudapp.net:$AZURE_SSH_DIR_ON_SERVER"
scp -i $AZURE_KEY_FILE $AZURE_KEY_FILE "ubuntu@$LINUX_SERVER_VM_NAME.cloudapp.net:$AZURE_SSH_DIR_ON_SERVER" || fail "Error uploading key."

# TODO
# Create a script on server that sets:
#server_private_ip: 10.32.0.4                     
#client_private_ip: 10.32.0.12                    
#path_to_key: /home/ubuntu/.ssh/id_rsa-wfb08102205

# Install software.
echo ""
run_remote_script "Instaling software." "ubuntu" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-2.sh" "server_private_ip=$LINUX_SERVER_IP client_private_ip=$CLIENT_IP path_to_key=$AZURE_KEY_ON_SERVER" || fail "Error running script."

echo ""
