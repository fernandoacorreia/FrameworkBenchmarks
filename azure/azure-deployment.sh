#!/bin/bash  
#
# Bash script to deploy Web Framework Benchmarks on Windows Azure.
#
# This is the master script that executes each step in sequence.
# If a step fails, you can correct the cause and manually execute the missing steps.
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

bash ./azure-deployment-step1.sh || { echo "Step 1 failed."; exit 1; }
bash ./azure-deployment-step2.sh || { echo "Step 2 failed."; exit 1; }
