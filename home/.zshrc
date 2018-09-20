# forward and backward-by-wrod shortcuts
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>"
# This is ctrl + right-arrow. Who thought of these stupid nomenclature for key-presses?!
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

# Completion options
zstyle ':completion:*' completer _complete
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' original false
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename '/home/akhil/.zshrc'

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

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

# # Zsh autosuggestions
# source ~/opt/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting
source ~/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Liquid Prompt
[[ $- = *i* ]] && source ~/opt/liquidprompt/liquidprompt

export REPORTTIME=3

source ~/bin/aliases.sh
[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"

