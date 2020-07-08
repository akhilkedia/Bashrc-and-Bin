# forward and backward-by-wrod shortcuts
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>"
# This is ctrl + right-arrow. Who thought of these stupid nomenclature for key-presses?!
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# Completion options
zstyle ':completion:*' completer _complete
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' original false
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

setopt completeinword autocd notify nobgnice
bindkey -e

## Rest of configs
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

setopt no_auto_menu

# pushd options
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
alias d='dirs -v'

# hstr
[[ $- = *i* ]] && source ~/bin/hstr.sh

# Zsh autosuggestions
source ~/opt/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting
source ~/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Liquid Prompt
[[ $- = *i* ]] && source ~/opt/liquidprompt/liquidprompt

# ctrl+f file path completion
[[ -s "$HOME/opt/qfc/bin/qfc.sh" ]] && source "$HOME/opt/qfc/bin/qfc.sh"

source ~/bin/aliases.sh


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
