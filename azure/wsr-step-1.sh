#!/bin/bash  
#
# Bash script to be executed on the Linux client to setup the Windows server.
#
# Step 1: Install prerequisites on Linux client.
#
set -o nounset -o errexit
echo "Host:" `hostname`
echo "Step 1: Install prerequisites on Linux client"

export DEBIAN_FRONTEND=noninteractive

echo ""
echo "Installing required packages"
sudo apt-get update
sudo apt-get upgrade -qq

# https://github.com/WinRb/WinRM
# sudo apt-get install build-essential libxslt-dev libxml2-dev ruby1.9.1 ruby1.9.1-dev -qq
# sudo gem install -r winrm
# sudo winrm quickconfig

# After running this on the server:
# winrm set winrm/config/client/auth @{Basic="true"}
# winrm set winrm/config/service/auth @{Basic="true"}
# winrm set winrm/config/service @{AllowUnencrypted="true"}

# This works on the client:
# require 'winrm'                                                                                                                 
# winrm = WinRM::WinRMWebService.new('http://10.32.0.20:5985/wsman', :plaintext, :user => "Administrator", :pass => 'Passxxxx', :basic_auth_only => true)                                                                                                       
# winrm.cmd('ipconfig /all') do |stdout, stderr|                                                                                  
#   STDOUT.print stdout                                                                                                           
#   STDERR.print stderr                                                                                                           
# end                        

# WinRM:
# http://stackoverflow.com/questions/18194516/test-winrm-wsman-connectivity
# http://stackoverflow.com/questions/17281224/configure-and-listen-successfully-using-winrm-in-powershell
# http://powershell.com/cs/media/p/7257.aspx#how-session-configurations-are-assigned

echo ""
echo "End of step 1"
