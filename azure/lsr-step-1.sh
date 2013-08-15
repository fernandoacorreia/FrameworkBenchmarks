#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 1: Install prerequisites.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 1: Install prerequisites"

export DEBIAN_FRONTEND=noninteractive

echo ""
echo "Creating required directories"
mkdir -p ~/.ssh
mkdir -p ~/bin

echo ""
echo "Configuring firewall"
sudo iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
sudo iptables -A INPUT -j ACCEPT -m state --state NEW -p tcp --source 10.0.0.0/11
sudo iptables -A OUTPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
sudo iptables -L

echo ""
echo "Updating package information"
sudo apt-get update

echo ""
echo "Upgrading packages"
sudo apt-get upgrade -qq

echo ""
echo "Installing packages that are not automatically installed by run-tests.py"
# TODO Remove when this issue is closed:
# https://github.com/TechEmpower/FrameworkBenchmarks/issues/417
sudo apt-get install mercurial -qq

echo ""
echo "Installing git"
sudo apt-get install git -qq

echo ""
echo "Clone FrameworkBenchmarks repository"
git clone https://github.com/TechEmpower/FrameworkBenchmarks.git ~/FrameworkBenchmarks
cd ~/FrameworkBenchmarks
git branch
git log -1 --pretty=format:"%H %s"
echo ""
pwd
ls -C

echo ""
echo "End of step 1"
