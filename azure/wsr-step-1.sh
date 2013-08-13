#!/bin/bash  
#
# Bash script to be executed on the Linux client to setup the Windows server.
#
# Step 1: Install prerequisites on Linux client.
#
echo "Host:" `hostname`
echo "Step 1: Install prerequisites on Linux client"

export DEBIAN_FRONTEND=noninteractive

echo ""
echo "Installing required packages"
sudo apt-get update
sudo apt-get upgrade -qq
sudo apt-get install git build-essential autoconf checkinstall python python-all python-dev python-all-dev python-setuptools -qq

echo ""
echo "Downloading winexe source code"
mkdir -p /tmp/winexe-code
git clone git://git.code.sf.net/p/winexe/code /tmp/winexe-code || { echo "Error cloning repository."; exit 1; }

echo ""
echo "Compiling and installing winexe"
cd /tmp/winexe-code/source4/
./autogen.sh
./configure
make basics idl bin/winexe || { echo "Error compiling winexe."; exit 1; }
sudo cp bin/winexe /usr/local/bin/ || { echo "Error installing winexe."; exit 1; }
winexe --version || { echo "Error executing winexe."; exit 1; }

echo ""
echo "End of step 1"
