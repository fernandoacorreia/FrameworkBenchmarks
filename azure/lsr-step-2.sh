#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 2: Install software on Linux server.
#
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
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --install-software --list-tests

# TODO See what goes where
# 
# source ~/.bash_profile
# For your first time through the tests, set the ulimit for open files
# ulimit -n 8192
# Most software is installed autormatically by the script, but running the mongo command below from 
# the install script was causing some errors. For now this needs to be run manually.
# cd installs/jruby-rack && rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true
# cd target && rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem
# cd ../../..
# cd installs && curl -sS https://getcomposer.org/installer | php -- --install-dir=bin
# cd ..
# sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless
#   mongo --host client-private-ip < config/create.js

echo ""
echo "End of step 2"
