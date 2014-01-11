#!/bin/bash
#
# Installs Windows Azure Command-Line Tools on a Fedora-based OS.
#
# http://www.windowsazure.com/en-us/develop/nodejs/how-to-guides/command-line-tools/
# http://www.windowsazure.com/en-us/manage/linux/other-resources/command-line-tools/
# https://github.com/WindowsAzure/azure-sdk-tools-xplat
#
# It will install the latest Node.js from sources to make sure an up-to-date version is installed.
#
# Tested on CentOS 6.3, 6.4.
# It should probably work on other Fedora and RHEL-based distributions.
#
set -o nounset -o errexit

fail() {
  echo "ERROR: $1"
  exit 1
}

install_prerequisites() {
    echo "Installing Node.js prerequisites"
    sudo yum -y --quiet install yum-plugin-fastestmirror
    sudo yum -y --quiet --disableexcludes=main install kernel-headers kernel-devel # Required for Azure. See http://nathanahlstrom.wordpress.com/2013/09/13/installing-windows-azure-command-line-tools-on-centos/ and http://superuser.com/a/596899/110856
    sudo yum -y --quiet install wget gcc-c++ python openssl-devel
    sudo yum -y --quiet groupinstall "Development Tools"
    sudo yum -y --quiet remove nodejs # This package is typically outdated
}

create_tmp_dir() {
    echo "Creating temporary directory"
    current_time=`date +%Y%m%d-%H%M%S`
    tmp_dir="/tmp/$current_time"
    mkdir -p "$tmp_dir"
}

download_nodejs() {
    echo "Downloading Node.js source code"
    cd "$tmp_dir"
    nodejs_archive=node-latest.tar.gz
    wget --quiet "http://nodejs.org/dist/$nodejs_archive"
    nodejs_source_dir=${nodejs_archive%.tar*}
    mkdir "$nodejs_source_dir"
    tar --extract --file=${nodejs_archive} --strip-components=1 --directory="$nodejs_source_dir"
}

install_nodejs() {
    echo "Compiling Node.js"
    cd "$nodejs_source_dir"
    ./configure &> configure.log
    make &> make.log
    echo "Installing Node.js"
    sudo make install &> install.log
    node --version > /dev/null || fail "node was not installed"
    npm --version > /dev/null || fail "npm was not installed"
}

install_azure_cli() {
    echo "Installing Windows Azure Command-Line Tools"
    local npm_path=`which npm`
    sudo "$npm_path" install azure-cli -g &> /tmp/azure-cli-install.log
    azure || fail "azure-cli was not installed"
}

install_prerequisites || fail "There was a problem installing prerequisites. See logs for details."
create_tmp_dir || fail "There was a problem creating the temporary directory. See logs for details."
download_nodejs || fail "There was a problem downloading Node.js. See logs for details."
install_nodejs || fail "There was a problem installing Node.js. See logs for details."
install_azure_cli || fail "There was a problem installing Windows Azure Command-Line Tools. See logs for details."
