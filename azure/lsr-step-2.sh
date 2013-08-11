#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 2: Install software on Linux server.
#
echo "Host:" `hostname`
echo "Step 2: Install software on Linux server"

echo ""
if [ -z "$server_private_ip" ]; then echo "server_private_ip is not defined."; exit 1; fi
echo "server_private_ip: $server_private_ip"
if [ -z "$client_private_ip" ]; then echo "client_private_ip is not defined."; exit 1; fi
echo "client_private_ip: $client_private_ip"
if [ -z "$path_to_key" ]; then echo "path_to_key is not defined."; exit 1; fi
echo "path_to_key: $path_to_key"

echo ""
echo "Install software"
cd ~/FrameworkBenchmarks
#./run-tests.py -s "$server_private_ip" -c "$client_private_ip" -i "$path_to_key" --install-software

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
echo "List tests"
./run-tests.py -s "$server_private_ip" -c "$client_private_ip" -i "$path_to_key" --list-tests

echo ""
echo "End of step 1"
