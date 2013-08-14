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
echo "revel (Go/MySQL), cpoll-pool(C++/Pg), rest-express(Java/Mongo)"
cd ~/FrameworkBenchmarks
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --max-threads 1 --name smoketest --test revel cpoll_cppsp-postgres-raw restexpress-mongodb --type all -m verify

# TODO Error with Pg
#-----------------------------------------------------
#  Verifying URLs for cpoll_cppsp-postgres-raw
#-----------------------------------------------------
# VERIFYING DB (/db_pg_async) ...
# curl: (22) The requested URL returned error: 500
# VERIFYING Query (/db_pg_async?queries=2) ...
# curl: (22) The requested URL returned error: 500
# /home/ubuntu/FrameworkBenchmarks/cpoll_cppsp/cppsp_0.2/run_application: line 5:  5489 Killed                  ./cppsp_standalone
# -f -l 0.0.0.0:16969 -c -fPIC -c -I"$(pwd)"/include -c -pthread -c -Ofast -c -march=native -c "$(pwd)"/cpoll.o -c "$(pwd)"/cppsp.o -t "$num_cpus" -r "$@"

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

echo ""
echo "Restarting Linux server"
sudo shutdown -r now
