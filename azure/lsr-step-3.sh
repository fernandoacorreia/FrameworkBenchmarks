#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 3: First-time setup.
#
set -o nounset -o errexit

function first_time_setup {
    # rvm seems to abort script unless it's called within a function
    echo "Host:" `hostname`
    echo "Step 3: First-time setup"
    export DEBIAN_FRONTEND=noninteractive
    source ~/.bash_profile # TODO: redundant?
    source ~/bin/benchmark-configuration.sh
    ulimit -n 8192
    cd ~/FrameworkBenchmarks
    cd installs/jruby-rack
    type rvm | head -1
    rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true
    cd target
    rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem
    cd ../../..
    cd installs
    curl -sS https://getcomposer.org/installer | php -- --install-dir=bin
    cd ..
    sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless -qq
    mongo --host $BENCHMARK_CLIENT_IP < config/create.js || { echo "Error configuring mongo."; exit 1; }
    
# TODO Error
# connecting to: 10.32.0.12:27017/test
# Tue Aug 13 22:51:02 Error: couldn't connect to server 10.32.0.12:27017 shell/mongo.js:86
# exception: connect failed
# Executing later:
# connecting to: 10.32.0.12:27017/test
# switched to db hello_world

    echo ""
    echo "End of step 3"
}

first_time_setup
