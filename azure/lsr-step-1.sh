#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 1: Install prerequisites.
#
echo "Host:" `hostname`
echo "Step 1: Install prerequisites"

echo ""
echo "Updating package information"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

echo ""
echo "Upgrading packages"
sudo apt-get upgrade -qq

echo ""
echo "Installing git"
sudo apt-get install git-core

echo ""
echo "End of step 1"
