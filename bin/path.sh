
#PATH for cuda
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}

#PATH for Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ADB path
export PATH=$HOME/opt/android-sdk/platform-tools:$PATH

# export ANDROID_HOME
export ANDROID_HOME=$HOME/opt/android-sdk/
export ANDROID_NDK=$HOME/opt/android-sdk/ndk-bundle