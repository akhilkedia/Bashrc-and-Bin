export HH_CONFIG=rawhistory,hicolor                               # get more colors
export HISTCONTROL=ignorespace                                    # leading space hides commands from history
export HISTFILESIZE=20000                                         # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}                                   # increase history size (default is 500)
export PROMPT_COMMAND="${PROMPT_COMMAND}" # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
