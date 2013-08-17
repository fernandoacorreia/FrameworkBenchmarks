#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 1: Install software on Linux server.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 1: Install software on Linux server"

export DEBIAN_FRONTEND=noninteractive

echo ""
source ~/benchmark-configuration.sh
if [ -z "$BENCHMARK_SERVER_IP" ]; then echo "BENCHMARK_SERVER_IP is not defined."; exit 1; fi
echo "BENCHMARK_SERVER_IP: $BENCHMARK_SERVER_IP"
if [ -z "$BENCHMARK_CLIENT_IP" ]; then echo "BENCHMARK_CLIENT_IP is not defined."; exit 1; fi
echo "BENCHMARK_CLIENT_IP: $BENCHMARK_CLIENT_IP"
if [ -z "$BENCHMARK_KEY_PATH" ]; then echo "BENCHMARK_KEY_PATH is not defined."; exit 1; fi
echo "BENCHMARK_KEY_PATH: $BENCHMARK_KEY_PATH"
chmod 600 "$BENCHMARK_KEY_PATH" || { echo "Error setting key file permissions."; exit 1; }
if [ -z "$BENCHMARK_REPOSITORY" ]; then echo "BENCHMARK_REPOSITORY is not defined."; exit 1; fi
echo "BENCHMARK_REPOSITORY: $BENCHMARK_REPOSITORY"
if [ -z "$BENCHMARK_BRANCH" ]; then echo "BENCHMARK_BRANCH is not defined."; exit 1; fi
echo "BENCHMARK_BRANCH: $BENCHMARK_BRANCH"

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
git clone $BENCHMARK_REPOSITORY ~/FrameworkBenchmarks || { echo "Error cloning repository at $BENCHMARK_REPOSITORY."; exit 1; }
cd ~/FrameworkBenchmarks
git checkout $BENCHMARK_BRANCH || { echo "Error checking out $BENCHMARK_BRANCH branch."; exit 1; }
git branch
git log -1 --pretty=format:"%H %s"

echo ""
echo "Installing benchmark software"
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --install-software --list-tests || { echo "Error installing software."; exit 1; }

echo ""
echo "End of step 1"
