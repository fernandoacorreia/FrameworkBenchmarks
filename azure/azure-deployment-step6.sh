#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 6: Windows server setup.
#
# Note: The Windows server setup is executed through the Linux client VM
# using WinRM / wsman / wsl.
# See wsman.txt.
#
set -o nounset -o errexit

source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 6: Windows server setup"
information "******************************************************************************"

# Install prerequisites on Linux client.
# echo ""
# echo "The Linux client is used as an intermediary for the Windows server setup."
# run_remote_script "Installing prerequisites on Linux client." "$AZURE_LINUX_USER" "$CLIENT_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "wsr-step-1.sh" || fail "Error running script."

# Setup Windows server from Linux client.

echo ""
