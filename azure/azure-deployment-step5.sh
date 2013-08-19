#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 5: Linux server and client additional setup.
#
set -o nounset -o errexit

source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 5: Linux server and client additional setup"
information "******************************************************************************"

# Reboot Linux client.
echo ""
reboot_linux_host "$AZURE_LINUX_USER" "$CLIENT_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" || fail "Error rebooting $CLIENT_VM_NAME."

# Reboot Linux server.
echo ""
reboot_linux_host "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" || fail "Error rebooting $LINUX_SERVER_VM_NAME."

# Additional setup.
echo ""
run_remote_script "Completing setup." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-2.sh" || fail "Error running script."

# Verify setup
run_remote_script "Verifying setup." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-3.sh" || fail "Error running script."

echo ""
