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

# Returns value of property stored in $prop on JSON object stored in $json.
# Author: Carlos Justiniano
# https://gist.github.com/cjus/1047794
function jsonval {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop | awk -F": " '{print $2}'`
    echo ${temp##*|}
}

# Waits until VM is ready.
# Parameters:
# $1: VM name.
function wait_until_vm_ready {
    vm_name=$1
    echo "Verifying status of VM $vm_name:"
    vm_status=""
    until [[ "$vm_status" == "ReadyRole" ]]
    do
        vm_properties=`$AZURE_COMMAND vm show $vm_name --json`
        json=$vm_properties
        prop='InstanceStatus'
        vm_status=`jsonval`
        echo $vm_status
        if [[ "$vm_status" != "ReadyRole" ]]; then sleep 15s; fi
    done
}

# Wait for VMs to become ready.
wait_until_vm_ready $CLIENT_VM_NAME
wait_until_vm_ready $LINUX_SERVER_VM_NAME

echo ""
