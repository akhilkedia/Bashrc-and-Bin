# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export SHELLCHECK_OPTS="-e SC1090"

# export ANDROID_HOME
export ANDROID_HOME=$HOME/opt/android-sdk/
export ANDROID_NDK=$HOME/opt/android-sdk/ndk-bundle

# set PATH so it includes user's private bin directories
export PATH="$HOME/bin:$HOME/.local/bin${PATH:+:${PATH}}"

#PATH for Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[ -d "/usr/local/cuda-9.0/bin" ] && PATH=/usr/local/cuda-9.0/bin:${PATH}
[ -d "/usr/local/cuda-9.1/bin" ] && PATH=/usr/local/cuda-9.1/bin:${PATH}
[ -d "$HOME/opt/android-sdk/platform-tools" ] && PATH=$HOME/opt/android-sdk/platform-tools:${PATH}
[ -d "$HOME/opt/shellcheck" ] && PATH=$HOME/opt/shellcheck:${PATH}
[ -d "$HOME/opt/shfmt" ] && PATH=$HOME/opt/shfmt:${PATH}
[ -d "$HOME/opt/code/bin" ] && PATH=$HOME/opt/code/bin:${PATH}
[ -d "$HOME/opt/pycharm/bin" ] && PATH=$HOME/opt/pycharm/bin:${PATH}

# Import colours
source ~/bin/colours.sh

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
