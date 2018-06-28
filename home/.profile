# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

#PATH for Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias sudo='sudo env PATH=$PATH:$NVM_BIN'

# export ANDROID_HOME
export ANDROID_HOME=$HOME/opt/android-sdk/
export ANDROID_NDK=$HOME/opt/android-sdk/ndk-bundle

#PATH for cuda
if [ -d "/usr/local/cuda-9.0/bin" ]; then
  export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
fi
if [ -d "/usr/local/cuda-9.1/bin" ]; then
  export PATH=/usr/local/cuda-9.1/bin${PATH:+:${PATH}}
fi

# ADB path
if [ -d "$HOME/opt/android-sdk/platform-tools" ]; then
  export PATH=$HOME/opt/android-sdk/platform-tools${PATH:+:${PATH}}
fi

# Path for shellcheck
if [ -d "$HOME/opt/shellcheck" ]; then
  export PATH=$HOME/opt/shellcheck${PATH:+:${PATH}}
fi

# Path for shfmt
if [ -d "$HOME/opt/shfmt" ]; then
  export PATH=$HOME/opt/shfmt${PATH:+:${PATH}}
fi

# Import colours
source ~/bin/colours.sh


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

