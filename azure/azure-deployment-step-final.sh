#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Final step: Instructions.
#
# This script saves and prints instructions after the deployment has completed.
#
set -o nounset -o errexit

source ./azure-deployment-common.sh

information "******************************************************************************"
information "Final step: Instructions"
information "******************************************************************************"

echo ""
echo "Saving deployment instructions at $AZURE_DEPLOYMENT_INSTRUCTIONS_FILE"
AZURE_VMS_DEPLOYED=`$AZURE_COMMAND vm list | grep -E "DNS Name|$AZURE_DEPLOYMENT_NAME" | cut -c 10-`
cat >$AZURE_DEPLOYMENT_INSTRUCTIONS_FILE <<_EOF_
Web Framework Benchmarks deployed from the $BENCHMARK_BRANCH branch of the repository at $BENCHMARK_REPOSITORY with the base name $AZURE_DEPLOYMENT_NAME at the $AZURE_DEPLOYMENT_LOCATION Windows Azure location under the subscription $AZURE_DEPLOYMENT_SUBSCRIPTION using $AZURE_DEPLOYMENT_VM_SIZE virtual machines.

VMs deployed:
$AZURE_VMS_DEPLOYED

Log files for remote script execution were saved at:
$AZURE_LOG_DIR

To connect to the client VM:
ssh $AZURE_LINUX_USER@$CLIENT_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE

To connect to the Linux server VM:
ssh $AZURE_LINUX_USER@$LINUX_SERVER_VM_NAME.cloudapp.net -i $AZURE_KEY_FILE

To connect to the Windows server VM:
mstsc /v:$WINDOWS_SERVER_VM_NAME.cloudapp.net /admin /f
User name: $WINDOWS_SERVER_VM_NAME\Administrator

To connect to the SQL Server VM:
mstsc /v:$SQL_SERVER_VM_NAME.cloudapp.net /admin /f
User name: $SQL_SERVER_VM_NAME\Administrator

To manage the Windows Azure resources:
https://manage.windowsazure.com

For your security delete the publish settings file when you don't need it anymore:
$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION

Remember to stop the virtual machines when they're not needed anymore.
VMs in "Stopped (Deallocated)" status don't incur in computing costs.
Virtual disks (VHD) incur in storage costs until they are deleted.
_EOF_

# TODO: instructions to stop and start the VMs
# TODO: instructions to list tests available at each server
# TODO: instructions to run tests

echo ""
cat $AZURE_DEPLOYMENT_INSTRUCTIONS_FILE
