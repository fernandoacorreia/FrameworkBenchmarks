#!/bin/bash  
#
# Bash script defining common functions used by the Windows Azure deployment scripts.
#
set -o nounset -o errexit

source ./azure-deployment-configuration.sh

# Color display functions.
function cyan {
    echo -e "$BOLDCYAN$*$NORMAL"
}

function red {
    echo -e "$BOLDRED$*$NORMAL"
}

function yellow {
    echo -e "$BOLDYELLOW$*$NORMAL"
}

# Displays informative message.
function information { cyan "$@"; }

# Displays warning message.
function warning { yellow "$@"; }

# Displays error message.
function error { red "ERROR: $@" 1>&2; }

# Displays error message and aborts.
function fail { [ $# -eq 0 ] || error "$@"; exit 1; }

# Function used to invoke Windows batch files.
# It removes cygwinisms from the PATH and the environment first
# and does some argument pre-processing.
# It also seems to fix the space problem.
# Author: Igor Pechtchanski
# http://cygwin.com/ml/cygwin/2004-09/msg00150.html
function cywgin_cmd { 
    ( local c="`cygpath -w \"$1\"`";
    shift;
    local cmd=`cygpath -u $COMSPEC`;
    local args="";
    while [ $# != 0 ]; do
        if [ -f "$1" ]; then
            args="$args '`cygpath -w $1`'";
        else
            if [ -d "$1" ]; then
                args="$args '`cygpath -w $1 | sed 's@\\\\\$@@'`'";
            else
                args="$args '$1'";
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
    eval $cmd /c "$c" $args
    )
} # TODO azure.cmd is not returning status code from node

# Returns value of property stored in $prop on JSON object stored in $json.
# Author: Carlos Justiniano
# https://gist.github.com/cjus/1047794
function jsonval {
    local temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop | awk -F": " '{print $2}'`
    echo ${temp##*|}
}

# Waits until the VM is ready returns its internal IP address.
# Parameters:
# $1: Name of the VM.
function get_vm_ip {
    local vm_name=$1
    local vm_status=""
    until [[ "$vm_status" == "ReadyRole" ]]
    do
        local vm_properties=`$AZURE_COMMAND vm show $vm_name --json`
        json=$vm_properties
        prop='InstanceStatus'
        local vm_status=`jsonval`
        if [[ "$vm_status" != "ReadyRole" ]]; then { error "$vm_name status is '$vm_status'. Retrying in 10s..."; sleep 10s; } fi
    done
    prop='IPAddress'
    local ip_address=`jsonval`
    if [ -z "$ip_address" ]; then fail "ip_address not found."; fi
    echo $ip_address
}

# Runs a script on a remote Linux host.
# Parameters:
# $1: Operation description.
# $2: Username.
# $3: Remote host address.
# $4: Key file.
# $5: Filename of script to be executed.
function run_remote_script {
    local log_file="$AZURE_LOG_DIR/$5.log"
    echo "$1"
    echo "Running script $5 on $3. To watch the progress, run in another terminal:"
    echo "tail -f $log_file"
    mkdir -p $AZURE_LOG_DIR
    tr -d '\r' < $5 | ssh $2@$3 -i $4 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "bash -x -s" &>$log_file
}

# Uploads a file to a remote Linux host.
# Parameters:
# $1 File to upload.
# $2 Remote user.
# $3 Remote host.
# $4 Target directory.
# $5 Private key file.
function upload_file {
    local file_to_upload=$1
    local remote_user=$2
    local remote_host=$3
    local target_directory=$4
    local private_key_file=$5
    echo "Uploading file $file_to_upload to $remote_host:$target_directory"
    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "$private_key_file" "$file_to_upload" "$remote_user@$remote_host:$target_directory" || fail "Error uploading file."
}

# Check configuration.
function check_configuration {
    # Validate AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION.
    if [ -z "$AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION" ]; then fail "AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION is not defined."; fi
    if [ ! -f $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION ]; then fail "File not found: $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"; fi

    # Validate AZURE_DEPLOYMENT_SUBSCRIPTION.
    if [ -z "$AZURE_DEPLOYMENT_SUBSCRIPTION" ]; then fail "AZURE_DEPLOYMENT_SUBSCRIPTION is not defined."; fi

    # Validate AZURE_DEPLOYMENT_LOCATION.
    if [ -z "$AZURE_DEPLOYMENT_LOCATION" ]; then fail "AZURE_DEPLOYMENT_LOCATION is not defined."; fi

    # Validate AZURE_DEPLOYMENT_NAME.
    if [ -z "$AZURE_DEPLOYMENT_NAME" ]; then fail "AZURE_DEPLOYMENT_NAME is not defined."; fi
    if [ ${#AZURE_DEPLOYMENT_NAME} -gt 12 ]; then fail "AZURE_DEPLOYMENT_NAME must be at most 12 characters long."; fi

    # Validate $AZURE_WINDOWS_PASSWORD.
    if [ -z "$AZURE_WINDOWS_PASSWORD" ]; then fail "AZURE_WINDOWS_PASSWORD is not defined."; fi
    if [ ${#AZURE_WINDOWS_PASSWORD} -lt 10 ]; then fail "AZURE_WINDOWS_PASSWORD must be at least 10 characters long."; fi

    # Validate AZURE_DEPLOYMENT_VM_SIZE.
    if [ -z "$AZURE_DEPLOYMENT_VM_SIZE" ]; then fail "AZURE_DEPLOYMENT_VM_SIZE is not defined."; fi

    # Validate AZURE_COMMAND.
    if [ -z "$AZURE_COMMAND" ]; then fail "AZURE_COMMAND is not defined."; fi
}

# Set variables used in several steps.
AZURE_LINUX_USER="ubuntu"
AZURE_SSH_DIR="$HOME/.ssh"
AZURE_KEY_NAME="id_rsa-${AZURE_DEPLOYMENT_NAME}"
AZURE_KEY_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}"
AZURE_PEM_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.x509.pub.pem"
AZURE_CER_FILE="${AZURE_SSH_DIR}/${AZURE_KEY_NAME}.cer"
CLIENT_VM_NAME="${AZURE_DEPLOYMENT_NAME}cli"
LINUX_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}lsr"
WINDOWS_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}wsr"
SQL_SERVER_VM_NAME="${AZURE_DEPLOYMENT_NAME}sql"
AZURE_LOG_DIR="/var/log/${AZURE_DEPLOYMENT_NAME}"
AZURE_LINUX_CONFIGURATION_FILE="/tmp/benchmark-configuration.sh"
BENCHMARK_REPOSITORY=${BENCHMARK_REPOSITORY:-"https://github.com/TechEmpower/FrameworkBenchmarks.git"}
BENCHMARK_BRANCH=${BENCHMARK_BRANCH:-"master"}

# Under CYGWIN this script uses a helper function to call the Windows Azure command line program.
if [ "$(expr substr $(uname -s) 1 6)" == "CYGWIN" ]; then
    AZURE_COMMAND="cywgin_cmd azure.cmd"
else
    AZURE_COMMAND="azure"
fi

# Set variables used for color displays.
NORMAL=$(tput sgr0)
BOLDCYAN=$(tput setaf 6; tput bold)
BOLDYELLOW=$(tput setaf 3; tput bold)
BOLDRED=$(tput setaf 1; tput bold)

# Verify configuration to avoid starting to create some resources
# and abort later because of a misconfiguration.
check_configuration
