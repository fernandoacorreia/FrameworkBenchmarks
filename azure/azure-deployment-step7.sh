#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# Step 7: Windows server setup.
#
# Note: The Windows server setup is executed through the Linux client VM.
# First, winexe is installed on that VM then it is used to remotely execute the
# setup scripts on the Windows server.
# This may seem weird but we're taking advantage that this VM is already created and available.
# This way, the Windows server setup scripts only have to be tested in one platform (Ubuntu Server),
# avoiding the requirement for these deployment scripts to have different ways to 
# execute remote scripts on the Windows server from Windows, Linux and Mac clients.
# It also avoid users having to install any particular tool in their systems just for this
# remote execution.
# It's also more secure, since the client VM is in the same private network as the Windows server
# and we don't risk sending Windows passwords in clear text over the Internet 
# as some remoting alternatives would do.
# After the setup, there is nothing special on the Linux client tying it to the Windows server
# and no dedicated services are kept executing on the client. We just run winexe on it to 
# execute the remote scripts then we're done.
# A service called winexesvc is installed on the Windows server, but we stop it after deployment.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS
set -o nounset -o errexit

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

information "******************************************************************************"
information "Step 7: Windows server setup"
information "******************************************************************************"

# Install prerequisites on Linux client.
echo ""
echo "The Linux client is used as an intermediary for the Windows server setup."
run_remote_script "Installing prerequisites on Linux client." "$AZURE_LINUX_USER" "$CLIENT_VM_NAME.cloudapp.net" "$AZURE_KEY_FILE" "wsr-step-1.sh" || fail "Error running script."

# Setup Windows server from Linux client.

# Stop winexesvc on Windows Server.

echo ""
