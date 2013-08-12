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
./run-tests.py -s "$BENCHMARK_SERVER_IP" -c "$BENCHMARK_CLIENT_IP" -i "$BENCHMARK_KEY_PATH" --install-software --list-tests || { echo "Error installing software."; exit 1; }

echo ""
echo "First-time setup:"

echo "source ~/.bash_profile"
source ~/.bash_profile

echo "ulimit -n 8192"
ulimit -n 8192

echo "cd installs/jruby-rack && rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true"
cd installs/jruby-rack && rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true

echo "cd target && rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem"
cd target && rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem

echo "cd ../../.."
cd ../../..

echo "cd installs && curl -sS https://getcomposer.org/installer | php -- --install-dir=bin"
cd installs && curl -sS https://getcomposer.org/installer | php -- --install-dir=bin

echo "cd .."
cd ..

echo "sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless"
sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless -qq

echo "mongo --host $BENCHMARK_CLIENT_IP < config/create.js"
mongo --host $BENCHMARK_CLIENT_IP < config/create.js

echo ""
echo "End of step 2"

echo ""
echo "Restarting " `hostname`
sudo shutdown -r now
