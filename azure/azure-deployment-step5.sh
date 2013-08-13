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
run_remote_script "Instaling prerequisites." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-1.sh" || fail "Error running script."

# Copy key to server
echo ""
upload_file "$AZURE_KEY_FILE" "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "~/.ssh" "$AZURE_KEY_FILE"

# Create Linux host configuration script.
echo ""
echo "Creating Linux host configuration script at $AZURE_LINUX_CONFIGURATION_FILE"
cat >$AZURE_LINUX_CONFIGURATION_FILE <<_EOF_
#!/bin/bash
export BENCHMARK_SERVER_IP=$LINUX_SERVER_IP
export BENCHMARK_CLIENT_IP=$CLIENT_IP
export BENCHMARK_KEY_PATH=~/.ssh/$AZURE_KEY_NAME
_EOF_

# Upload Linux host configuration script.
echo ""
upload_file "$AZURE_LINUX_CONFIGURATION_FILE" "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "~/bin" "$AZURE_KEY_FILE"

# Install software.
echo ""
run_remote_script "Installing benchmark software on the Linux server. This may take about 2 hours." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-2.sh" || fail "Error running script."

# First-time setup.
echo ""
run_remote_script "First-time setup." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-3.sh" || fail "Error running script."

# Restart Linux server due to "System restart required".
echo ""
run_remote_script "Restarting Linux server." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-4.sh" || fail "Error running script."

echo ""
