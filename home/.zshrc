if [[ $ZSHRC_RUN!=yes ]]; then
    if [[ $- == *i* ]] && [ -n "$BASH_VERSION" ]; then
        zsh=$(command -v zsh)
        if [ -x "$zsh" ]; then
            export SHELL="$zsh"
            # exec "$zsh"
        fi
    fi
    export ZSHRC_RUN=yes
    export TMOUT=0
    setopt interactivecomments
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

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


    case "$TERM" in
        xterm*)
            precmd () {
                pre_name=''
                if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
                    print -Pn "\e]0;%m@:%~\a"
                else
                    print -Pn "\e]0;%~\a"
                fi
                }
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
    export ZSH_AUTOSUGGEST_MANUAL_REBIND=true
    export ZSH_AUTOSUGGEST_USE_ASYNC=true


    # Liquid Prompt
    source ~/opt/powerlevel10k/powerlevel10k.zsh-theme

    # ctrl+f file path completion
    [[ -s "$HOME/opt/qfc/bin/qfc.sh" ]] && source "$HOME/opt/qfc/bin/qfc.sh"

    source ~/bin/aliases.sh


    #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/akhil/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/akhil/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/home/akhil/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/akhil/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<


    # PATH="/home/akhil/perl5/bin${PATH:+:${PATH}}"; export PATH;
    # PERL5LIB="/home/akhil/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    # PERL_LOCAL_LIB_ROOT="/home/akhil/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    # PERL_MB_OPT="--install_base \"/home/akhil/perl5\""; export PERL_MB_OPT;
    # PERL_MM_OPT="INSTALL_BASE=/home/akhil/perl5"; export PERL_MM_OPT;

    source $HOME/opt/powerlevel10k/powerlevel10k.zsh-theme
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    # Syntax Highlighting
    source ~/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # Import colours
    source "$HOME/bin/colours.sh"
fi