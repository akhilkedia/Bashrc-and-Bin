export HSTR_CONFIG=raw-history-view,hicolor                       # show unsorted raw histroy, show colours colors

if [ -n "$BASH_VERSION" ]; then
    export HISTFILESIZE=20000                                         # increase history file size (default is 500)
    export HISTSIZE=${HISTFILESIZE}                                   # increase history size (default is 500)
    export HISTCONTROL=ignorespace:erasedups                          # leading space hides commands from history
    export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"                         # mem/file sync
    # if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
fi
if [ -n "$ZSH_VERSION" ]; then
    HISTFILE="$HOME/.bash_history"
    HISTSIZE=20000
    SAVEHIST=20000
    # Appens to histroy, no dupes, and write instantly
    setopt appendhistory inc_append_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
    if [[ $- =~ .*i.* ]]; then bindkey -s "\C-r" "\C-a hstr -- \C-j"; fi
fi
