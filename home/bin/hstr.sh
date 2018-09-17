export HSTR_CONFIG=raw-history-view,hicolor                       # show unsorted raw histroy, show colours colors
export HISTCONTROL=ignorespace                                    # leading space hides commands from history
export HISTFILESIZE=20000                                         # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}                                   # increase history size (default is 500)
export PROMPT_COMMAND="${PROMPT_COMMAND}" # mem/file sync
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
