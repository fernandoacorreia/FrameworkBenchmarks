@echo off
echo "Running azure-deployment.sh..."
:: The -o igncr flag avoids errors with CR characters when the files are downloaded with Windows line terminators.
bash -o igncr azure-deployment.sh
