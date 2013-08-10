#!/bin/bash  
#
# Bash script defining common functions used by the Windows Azure deployment scripts.
#
set -o igncr  # for Cygwin on Windows
export SHELLOPTS

# Displays error message.
error() { echo "ERROR: $@" 1>&2; }

# Displays error message and aborts.
fail() { [ $# -eq 0 ] || error "$@"; exit 1; }

# Function used to invoke Windows batch files.
# It removes cygwinisms from the PATH and the environment first
# and does some argument pre-processing.
# It also seems to fix the space problem.
# Author: Igor Pechtchanski
# http://cygwin.com/ml/cygwin/2004-09/msg00150.html
cywgin_cmd () 
{ 
    ( local c="`cygpath -w \"$1\"`";
    shift;
    local cmd=`cygpath -u $COMSPEC`;
    while [ $# != 0 ]; do
        if [ -f "$1" ]; then
            local args="$args '`cygpath -w $1`'";
        else
            if [ -d "$1" ]; then
                local args="$args '`cygpath -w $1 | sed 's@\\\\\$@@'`'";
            else
                local args="$args '$1'";
            fi;
        fi;
        shift;
    done;
    PATH=`echo $PATH |
          tr : '\n' |
          egrep -vw '^(/usr/local/bin|/usr/bin|/bin|/usr/X11R6/bin)$' |
          tr '\n' :`;
    unset BASH_ENV COLORTERM CYGWIN DISPLAY HISTCONTROL MAKE_MODE;
    unset MANPATH PKG_CONFIG_PATH PS1 PWD SHLVL TERM USER _;
    unset CVS CVSROOT CVS_RSH GEN_HOME GROOVY_HOME TOMCAT_DIR;
    eval $cmd /c "$c" $args ) # TODO: seems to be losing return code; scripts don't abort when they should.
}
