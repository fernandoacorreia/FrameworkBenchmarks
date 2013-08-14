#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 2: Install software on Linux server.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 2: Install software on Linux server"

export DEBIAN_FRONTEND=noninteractive

echo ""
source ~/bin/benchmark-configuration.sh
if [ -z "$BENCHMARK_SERVER_IP" ]; then echo "BENCHMARK_SERVER_IP is not defined."; exit 1; fi
echo "BENCHMARK_SERVER_IP: $BENCHMARK_SERVER_IP"
if [ -z "$BENCHMARK_CLIENT_IP" ]; then echo "BENCHMARK_CLIENT_IP is not defined."; exit 1; fi
echo "BENCHMARK_CLIENT_IP: $BENCHMARK_CLIENT_IP"
if [ -z "$BENCHMARK_KEY_PATH" ]; then echo "BENCHMARK_KEY_PATH is not defined."; exit 1; fi
echo "BENCHMARK_KEY_PATH: $BENCHMARK_KEY_PATH"

echo ""
echo "Installing software"
cd ~/FrameworkBenchmarks
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --install-software --list-tests || { echo "Error installing software."; exit 1; }

echo ""
echo "End of step 2"
