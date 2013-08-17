#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 4: Linux server setup.
#
set -o nounset -o errexit

source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 4: Linux server setup"
information "******************************************************************************"

# Get Linux server IP.
echo "Retrieving $LINUX_SERVER_VM_NAME IP:"
LINUX_SERVER_IP=`get_vm_ip $LINUX_SERVER_VM_NAME`
echo "$LINUX_SERVER_IP"

# Get client IP.
echo "Retrieving $CLIENT_VM_NAME IP:"
CLIENT_IP=`get_vm_ip $CLIENT_VM_NAME`
echo "$CLIENT_IP"

# Create Linux host configuration script.
echo ""
echo "Creating Linux host configuration script at $AZURE_LINUX_CONFIGURATION_FILE"
cat >$AZURE_LINUX_CONFIGURATION_FILE <<_EOF_
#!/bin/bash
export BENCHMARK_SERVER_IP=$LINUX_SERVER_IP
export BENCHMARK_CLIENT_IP=$CLIENT_IP
export BENCHMARK_KEY_PATH=~/.ssh/$AZURE_KEY_NAME
export BENCHMARK_REPOSITORY=$BENCHMARK_REPOSITORY
export BENCHMARK_BRANCH=$BENCHMARK_BRANCH
_EOF_

# Upload Linux host configuration script.
echo ""
upload_file "$AZURE_LINUX_CONFIGURATION_FILE" "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "~/bin" "$AZURE_KEY_FILE"

# Copy key to server.
echo ""
upload_file "$AZURE_KEY_FILE" "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "~/.ssh" "$AZURE_KEY_FILE"

# Install software.
echo ""
run_remote_script "Installing benchmark software on the Linux server. This may take about 2 hours." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-1.sh" || fail "Error running script."

echo ""
