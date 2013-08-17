#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 3: Verify setup.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 3: Verify setup."

export DEBIAN_FRONTEND=noninteractive
source ~/bin/benchmark-configuration.sh

echo ""
echo "Running a smoke test..."
echo "revel (Go/MySQL), cpoll-pool(C++/Pg), rest-express(Java/Mongo)"
cd ~/FrameworkBenchmarks
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --max-threads 1 --name smoketest --test revel cpoll_cppsp-postgres-raw restexpress-mongodb --type all -m verify

# TODO: Getting errors
# bash: cpu0/cpufreq/scaling_governor: No such file or directory
# bash: cpu1/cpufreq/scaling_governor: No such file or directory
# bash: cpufreq/cpufreq/scaling_governor: No such file or directory
# bash: cpuidle/cpufreq/scaling_governor: No such file or directory
# 
# Investigate possible solutions
# sudo apt-get install cpufrequtils -qq
# http://www.pantz.org/software/cpufreq/usingcpufreqonlinux.html
# http://forums.linuxmint.com/viewtopic.php?f=90&t=99383
