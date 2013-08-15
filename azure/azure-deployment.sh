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
set -o nounset -o errexit

source ./azure-deployment-configuration.sh
source ./azure-deployment-common.sh

information "Deploying Web Framework Benchmarks to Windows Azure..."
echo ""

source ./azure-deployment-step1.sh || fail "Step 1 failed."
source ./azure-deployment-step2.sh || fail "Step 2 failed."
source ./azure-deployment-step3.sh || fail "Step 3 failed."
source ./azure-deployment-step4.sh || fail "Step 4 failed."
source ./azure-deployment-step5.sh || fail "Step 5 failed."
source ./azure-deployment-step6.sh || fail "Step 6 failed."
source ./azure-deployment-step-final.sh || fail "Final step failed."
