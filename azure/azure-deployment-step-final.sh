#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Final step: Cleanup and instructions.
#
# This script prints instructions after the deployment has completed.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Final step: Cleanup and instructions"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

echo "Cleaning up temporary files."
[ -f "$AZURE_LINUX_CONFIGURATION_KEY_FILE" ] && rm $AZURE_LINUX_CONFIGURATION_KEY_FILE
[ -f "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION" ] && rm $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION

echo ""
echo "VMs deployed:"
$AZURE_COMMAND vm list | grep -E "DNS Name|$AZURE_DEPLOYMENT_NAME" | cut -c 10-

echo ""
echo "Connection to the client VM:"
echo "ssh $AZURE_LINUX_USER@$CLIENT_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE"

echo ""
echo "Connection to the Linux server VM:"
echo "ssh $AZURE_LINUX_USER@$LINUX_SERVER_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE"

echo ""
echo "Connection to the Windows server VM:"
echo "mstsc /v:$WINDOWS_SERVER_VM_NAME.cloudapp.net /admin /f"
echo "User name: $WINDOWS_SERVER_VM_NAME\Administrator"

echo ""
echo "Connection to the SQL Server VM:"
echo "mstsc /v:$SQL_SERVER_VM_NAME.cloudapp.net /admin /f"
echo "User name: $SQL_SERVER_VM_NAME\Administrator"

echo ""
echo "Windows Azure Management Portal:"
echo "https://manage.windowsazure.com"

echo ""
echo "Log files for remote script execution:"
echo "$AZURE_LOG_DIR"

# TODO: instructions to stop and start the VMs
# TODO: instructions to list tests available at each server
# TODO: instructions to run tests
