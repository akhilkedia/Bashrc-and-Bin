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
export MANPATH="${MANPATH:+:${MANPATH}}"
export INFOPATH="${INFOPATH:+:${INFOPATH}}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export CPATH="${CPATH:+:${CPATH}}"

# For vnc to play nice with GUIs
[ -d "$HOME/xdg_runtime_dir" ] && export XDG_RUNTIME_DIR=$HOME/xdg_runtime_dir

# Set cuda visible devices for genie
[ "$(hostname -s)" = "genie" ] && export CUDA_VISIBLE_DEVICES=3

# Supercom module options
unset TMOUT
export MODULEPATH=/apps/supercom_env_rhel7:/usr/share/Modules/modulefiles:/etc/modulefiles
export MODULESHOME=/usr/share/Modules
module ()
{
    eval `/usr/bin/modulecmd bash $*`
}
# (command -v module >/dev/null 2>&1) && module load cuda10.0 cudnn_v7.4_cuda10.0 nccl_2.4.7 openMPI_v3.1
[ "$(whoami)" = akhil.kedia ] && (command -v module >/dev/null 2>&1) && module load cuda9.0
[ "$(whoami)" = akhil.kedia ] && (command -v module >/dev/null 2>&1) && module load cudnn_v7.1

# Cuda paths
[ -d "/usr/local/cuda-9.0/" ] && export CUDA_INSTALL_DIR="/usr/local/cuda-9.0/"
[ -d "/usr/local/cuda-9.0/bin/" ] && PATH="/usr/local/cuda-9.0/bin/:${PATH}"
[ -d "/usr/local/cuda-9.0/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-9.0/lib64/:${LD_LIBRARY_PATH}"
[ -d "/usr/local/cuda-9.0/include/" ] && CPATH="/usr/local/cuda-9.0/include/:${CPATH}"
[ -d "/usr/local/cuda-9.0/extras/CUPTI/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-9.0/extras/CUPTI/lib64/:${LD_LIBRARY_PATH}"

[ -d "/usr/local/cuda-10.0/bin/" ] && PATH="/usr/local/cuda-10.0/bin/:${PATH}"
[ -d "/usr/local/cuda-10.0/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-10.0/lib64/:${LD_LIBRARY_PATH}"
[ -d "/usr/local/cuda-10.0/include/" ] && CPATH="/usr/local/cuda-10.0/include/:${CPATH}"
[ -d "/usr/local/cuda-10.0/extras/CUPTI/lib64/" ] && LD_LIBRARY_PATH="/usr/local/cuda-10.0/extras/CUPTI/lib64/:${LD_LIBRARY_PATH}"
[ -d "/usr/local/cuda-10.0/" ] && export CUDA_INSTALL_DIR="/usr/local/cuda-10.0/"

# Tensorrt
[ -d "$HOME/opt/tensorrt/lib/" ] && LD_LIBRARY_PATH="$HOME/opt/tensorrt/lib/:${LD_LIBRARY_PATH}"
[ -d "$HOME/opt/tensorrt/lib/" ] && export TENSORRT_LIB_DIR="$HOME/opt/tensorrt/lib/"
[ -d "$HOME/opt/tensorrt/include/" ] && export TENSORRT_INC_DIR="$HOME/opt/tensorrt/include/"

# NCCL
[ -d "$HOME/opt/nccl/lib/" ] && LD_LIBRARY_PATH="$HOME/opt/nccl/lib/:${LD_LIBRARY_PATH}"
[ -d "$HOME/opt/nccl/include/" ] && export CPATH="$HOME/opt/nccl/include/"

# Programs in opt
[ -d "$HOME/opt/android-sdk/platform-tools" ] && PATH=$HOME/opt/android-sdk/platform-tools:${PATH}
[ -d "$HOME/opt/bazel" ] && PATH=$HOME/opt/bazel:${PATH}
[ -d "$HOME/opt/code/bin" ] && PATH=$HOME/opt/code/bin:${PATH}
[ -d "$HOME/opt/pv" ] && PATH=$HOME/opt/pv:${PATH}
[ -d "$HOME/opt/pycharm/bin" ] && PATH=$HOME/opt/pycharm/bin:${PATH}
[ -d "$HOME/opt/qfc/bin" ] && PATH=$HOME/opt/qfc/bin:${PATH}
[ -d "$HOME/opt/shellcheck" ] && PATH=$HOME/opt/shellcheck:${PATH}
[ -d "$HOME/opt/shfmt" ] && PATH=$HOME/opt/shfmt:${PATH}
[ -d "$HOME/opt/git/bin" ] && PATH=$HOME/opt/git/bin:${PATH}
[ -d "$HOME/opt/zsh/bin" ] && PATH=$HOME/opt/zsh/bin:${PATH}
[ -d "$HOME/opt/pigz/bin" ] && PATH=$HOME/opt/pigz/bin:${PATH}
[ -d "$HOME/opt/transcrypt/" ] && PATH=$HOME/opt/transcrypt:${PATH}

# Activate Virtual env
[ -d "$HOME/opt/virt-tf-1.14/bin/" ] && source "$HOME/opt/virt-tf-1.14/bin/activate"

#PATH for Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

#PATH for Ruby Version Manager
[ -d "$HOME/.rvm/bin" ] && PATH=$HOME/.rvm/bin:${PATH}
[[ -s "$HOME/.rvm/scripts/rvm" ]] && \. "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Bleugh.
export LIBRARY_PATH="$LD_LIBRARY_PATH"

# Import colours
source "$HOME/bin/colours.sh"
[ -s "$HOME/.proxy.sh" ] && source "$HOME/.proxy.sh"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
elif [ -n "$ZSH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

if [[ $- == *i* ]] && [ -n "$BASH_VERSION" ]; then
    zsh=$(command -v zsh)
    if [ -x "$zsh" ]; then
        export SHELL="$zsh"
        # exec "$zsh"
    fi
fi
