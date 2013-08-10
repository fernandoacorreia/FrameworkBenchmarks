#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# This is the master script that executes each step in sequence.
# If a step fails, you can correct the cause and manually execute the missing steps
# without having to restart from scratch.
#
# Instructions:
# - Configure as documented in the README.md file.
# - Run this script with a command like "bash azure-deployment.sh"
#   (on Windows this requires Cygwin).
#
# Note: These scripts are designed to run both on Windows (under Cygwin) and
# on Linux and Mac. To achieve that, they have to use some workarounds that
# wouldn't seem necessary or usual in a pure Linux environment.
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

echo "Deploying Web Framework Benchmarks to Windows Azure..."
echo ""

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

bash ./azure-deployment-step1.sh || fail "Step 1 failed."
bash ./azure-deployment-step2.sh || fail "Step 2 failed."
bash ./azure-deployment-step3.sh || fail "Step 3 failed."
bash ./azure-deployment-step4.sh || fail "Step 4 failed."
bash ./azure-deployment-step5.sh || fail "Step 5 failed."

echo "******************************************************************************"
echo "Done"
echo "******************************************************************************"

echo "Deployment name: $AZURE_DEPLOYMENT_NAME"
echo "For your security, remember to delete the publish settings file at $AZURE_DEPLOYMENT_PUBLISHSETTINGS_LOCATION"
