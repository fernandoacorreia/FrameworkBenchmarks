#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 4: Verify setup and restart Linux server.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 4: Verify setup and restart Linux server"

export DEBIAN_FRONTEND=noninteractive
source ~/bin/benchmark-configuration.sh

echo ""
echo "Running a smoke test"
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --max-threads 1 --name smoketest --test revel --type all -m verify

echo ""
echo "Restarting Linux server"
sudo shutdown -r now
