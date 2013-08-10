#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Final step: Instructions.
#
# This script prints instructions after the deployment has completed.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "******************************************************************************"
echo "Final step: Instructions"
echo "******************************************************************************"

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

echo "VMs deployed:"
$AZURE_COMMAND vm list | grep -E "DNS Name|$AZURE_DEPLOYMENT_NAME" | cut -c 10-

echo ""
echo "Connection to the client VM:"
echo "ssh ubuntu@$CLIENT_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE"

echo ""
echo "Connection to the Linux server VM:"
echo "ssh ubuntu@$LINUX_SERVER_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE"

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
echo "WARNING: For your security, remember to delete the publish settings file at:"
echo "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"
