#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 3: Additional setup.
#
function additional_setup {
    # rvm seems to abort script unless it's called within a function
    echo "Host:" `hostname`
    echo "Step 3: Additional setup"
    export DEBIAN_FRONTEND=noninteractive
    source ~/bin/benchmark-configuration.sh
    source ~/.bash_profile
    ulimit -n 8192
    cd ~/FrameworkBenchmarks/installs/jruby-rack  || { echo "ERROR on 'cd ~/FrameworkBenchmarks/installs/jruby-rack'"; exit 1; }
    rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true  || { echo "ERROR on 'rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true'"; exit 1; }
    cd target || { echo "ERROR on 'cd target'"; exit 1; }
    rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem  || { echo "ERROR on 'rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem'"; exit 1; }
    cd ~/FrameworkBenchmarks/installs || { echo "ERROR on 'cd ~/FrameworkBenchmarks/installs'"; exit 1; }
    curl -sS https://getcomposer.org/installer | php -- --install-dir=bin || { echo "ERROR on 'curl -sS https://getcomposer.org/installer | php -- --install-dir=bin'"; exit 1; }
    sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless -qq  || { echo "ERROR on 'sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless -qq'"; exit 1; }
    cd ~/FrameworkBenchmarks || { echo "ERROR on 'cd ~/FrameworkBenchmarks'"; exit 1; }
    mongo --host $BENCHMARK_CLIENT_IP < config/create.js || { echo "ERROR on 'mongo --host $BENCHMARK_CLIENT_IP < config/create.js'"; exit 1; }
    
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

additional_setup
