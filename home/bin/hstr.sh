export HSTR_CONFIG=raw-history-view,hicolor                       # show unsorted raw histroy, show colours colors

if [ -n "$BASH_VERSION" ]; then
    export HISTFILESIZE=20000                                         # increase history file size (default is 500)
    export HISTSIZE=${HISTFILESIZE}                                   # increase history size (default is 500)
    export HISTCONTROL=ignorespace:erasedups                          # leading space hides commands from history
    export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"                         # mem/file sync
    # if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
    # if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
fi
if [ -n "$ZSH_VERSION" ]; then
    export HISTFILE="$HOME/.bash_history"
    export HISTSIZE=20000
    export SAVEHIST=20000
    # Appens to histroy, no dupes, and write instantly
    setopt appendhistory inc_append_history hist_expire_dups_first hist_find_no_dups hist_ignore_all_dups hist_ignore_space hist_reduce_blanks

    fzf_history() {
    local selected
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
    IFS=$'\n' selected=($(fc -nlr 1 | fzf --reverse --exact --expect=ctrl-v --no-sort --height=100% --query="$BUFFER"))
    if [[ "$selected" ]]; then
        LBUFFER="$selected"
        if [[ ${#selected[@]} -eq 2 ]]; then
        LBUFFER="${selected[2]}"
        zle accept-line
        fi
    fi
    zle reset-prompt
    }
    zle -N fzf-history fzf_history
    bindkey "^R" fzf-history
fi
