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
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export CPATH="${CPATH:+:${CPATH}}"

# Supercom module options
(command -v module >/dev/null 2>&1) && module load cuda9.0
(command -v module >/dev/null 2>&1) && module load cudnn_v7.1

# Cuda paths
[ -d "/usr/local/cuda-9.1/bin" ] && PATH=/usr/local/cuda-9.1/bin:${PATH}
[ -d "/usr/local/cuda-9.0/" ] && export CUDA_INSTALL_DIR="/usr/local/cuda-9.0/"
[ -d "/usr/local/cuda-9.0/bin/" ] && PATH="/usr/local/cuda-9.0/bin/:${PATH}"
[ -d "/usr/local/cuda-9.0/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-9.0/lib64/:${LD_LIBRARY_PATH}"
[ -d "/usr/local/cuda-9.0/include/" ] && CPATH="/usr/local/cuda-9.0/include/:${CPATH}"
[ -d "/usr/local/cuda-9.0/extras/CUPTI/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-9.0/extras/CUPTI/lib64/:${LD_LIBRARY_PATH}"

# Tensorrt
[ -d "$HOME/opt/tensorrt/lib/" ] && LD_LIBRARY_PATH="$HOME/opt/tensorrt/lib/:${LD_LIBRARY_PATH}"
[ -d "$HOME/opt/tensorrt/lib/" ] && export TENSORRT_LIB_DIR="$HOME/opt/tensorrt/lib/"
[ -d "$HOME/opt/tensorrt/include/" ] && export TENSORRT_INC_DIR="$HOME/opt/tensorrt/include/"

# NCCL
[ -d "$HOME/opt/nccl/lib/" ] && LD_LIBRARY_PATH="$HOME/opt/nccl/lib/:${LD_LIBRARY_PATH}"
[ -d "$HOME/opt/nccl/include/" ] && export CPATH="$HOME/opt/nccl/include/"

#PATH for Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Programs in opt
[ -d "$HOME/opt/android-sdk/platform-tools" ] && PATH=$HOME/opt/android-sdk/platform-tools:${PATH}
[ -d "$HOME/opt/shellcheck" ] && PATH=$HOME/opt/shellcheck:${PATH}
[ -d "$HOME/opt/shfmt" ] && PATH=$HOME/opt/shfmt:${PATH}
[ -d "$HOME/opt/pv" ] && PATH=$HOME/opt/pv:${PATH}
[ -d "$HOME/opt/code/bin" ] && PATH=$HOME/opt/code/bin:${PATH}
[ -d "$HOME/opt/pycharm/bin" ] && PATH=$HOME/opt/pycharm/bin:${PATH}

# Import colours
source ~/bin/colours.sh

# Set cuda visible devices for genie
[ "$(hostname -s)" = "genie" ] && export CUDA_VISIBLE_DEVICES=3

# Activate Virtual env
[ -d "$HOME/opt/virt-tf-1.5/bin/" ] && source "$HOME/opt/virt-tf-1.5/bin/activate"

# Bleugh.
export LIBRARY_PATH="$LD_LIBRARY_PATH"

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
