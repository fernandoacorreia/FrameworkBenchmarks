#!/bin/bash  
#
# Bash script defining common functions used by the Windows Azure deployment scripts.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

# Variables used in several steps:
export AZURE_SSH_DIR=$(eval echo ~${SUDO_USER})/.ssh
export AZURE_KEY_NAME="id_rsa-${AZURE_DEPLOYMENT_NAME}"
export AZURE_KEY_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}"
export AZURE_PEM_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.x509.pub.pem"
export AZURE_CER_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.cer"
export CLIENT_VM_NAME="${AZURE_DEPLOYMENT_NAME}cli"
export LINUX_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}lsr"
export WINDOWS_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}wsr"
export SQL_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}sql"
export AZURE_LOG_DIR="/var/log/${AZURE_DEPLOYMENT_NAME}"

# Displays error message.
error() { echo "ERROR: $@" 1>&2; }

# Displays error message and aborts.
fail() { [ $# -eq 0 ] || error "$@"; exit 1; }

# Function used to invoke Windows batch files.
# It removes cygwinisms from the PATH and the environment first
# and does some argument pre-processing.
# It also seems to fix the space problem.
# Author: Igor Pechtchanski
# http://cygwin.com/ml/cygwin/2004-09/msg00150.html
cywgin_cmd () 
{ 
    ( local c="`cygpath -w \"$1\"`";
    shift;
    local cmd=`cygpath -u $COMSPEC`;
    while [ $# != 0 ]; do
        if [ -f "$1" ]; then
            local args="$args '`cygpath -w $1`'";
        else
            if [ -d "$1" ]; then
                local args="$args '`cygpath -w $1 | sed 's@\\\\\$@@'`'";
            else
                local args="$args '$1'";
            fi;
        fi;
        shift;
    done;
    PATH=`echo $PATH |
          tr : '\n' |
          egrep -vw '^(/usr/local/bin|/usr/bin|/bin|/usr/X11R6/bin)$' |
          tr '\n' :`;
    unset BASH_ENV COLORTERM CYGWIN DISPLAY HISTCONTROL MAKE_MODE;
    unset MANPATH PKG_CONFIG_PATH PS1 PWD SHLVL TERM USER _;
    unset CVS CVSROOT CVS_RSH GEN_HOME GROOVY_HOME TOMCAT_DIR;
    eval $cmd /c "$c" $args || { status=$?; error "Status code $status executing $cmd /c \"$c\" $args"; return $status; }
    )
} # TODO azure.cmd is not returning status code from node

# Returns value of property stored in $prop on JSON object stored in $json.
# Author: Carlos Justiniano
# https://gist.github.com/cjus/1047794
function jsonval {
    local temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop | awk -F": " '{print $2}'`
    echo ${temp##*|}
}

# Waits until VM is ready.
# Parameters:
# $1: VM name.
function wait_until_vm_ready {
    local vm_name=$1
    echo "Verifying status of VM $vm_name:"
    local vm_status=""
    until [[ "$vm_status" == "ReadyRole" ]]
    do
        local vm_properties=`$AZURE_COMMAND vm show $vm_name --json`
        json=$vm_properties
        prop='InstanceStatus'
        local vm_status=`jsonval`
        echo $vm_status
        if [[ "$vm_status" != "ReadyRole" ]]; then sleep 15s; fi
    done
}

# Runs a script on a remote Linux server.
# Parameters:
# $1: Operation description.
# $2: Username.
# $3: Remote server address.
# $4: Key file.
# $5: Filename of script to be executed.
function run_remote_script {
    local log_file="$AZURE_LOG_DIR/$5.log"
    echo "$1"
    echo "Running script $5 on $3. To watch the progress, run in another terminal:"
    echo "tail -f $log_file"
    mkdir -p $AZURE_LOG_DIR
    tr -d '\r' < $5 | ssh $2@$3 -i $4 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "bash -s" &>$log_file
}
