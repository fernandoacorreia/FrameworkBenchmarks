#!/bin/bash  
#
# Bash script to be executed on the Linux server.
#
# Step 4: Restart Linux server.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 4: Restart Linux server"
sudo shutdown -r now
