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

# Reboot Linux server.
# TODO

# Reboot Linux client.
# TODO

# Wait for Linux server to become available.
# TODO

# Wait for Linux client to become available.
# TODO

# Wait for services to become available.
# TODO

# Additional setup.
echo ""
run_remote_script "Completing setup." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-2.sh" || fail "Error running script."

# Verify setup
run_remote_script "Verifying setup." "$AZURE_LINUX_USER" "$LINUX_SERVER_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "lsr-step-3.sh" || fail "Error running script."

echo ""
