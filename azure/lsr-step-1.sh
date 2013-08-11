#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 1: Install prerequisites.
#
echo "Host:" `hostname`
echo "Step 1: Install prerequisites"

echo ""
echo "Configuring firewall"
sudo iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
sudo iptables -A INPUT -j ACCEPT -m state --state NEW -p tcp --source 10.0.0.0/11
sudo iptables -A OUTPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
sudo iptables -L

echo ""
echo "Updating package information"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

echo ""
echo "Upgrading packages"
sudo apt-get upgrade -qq

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
