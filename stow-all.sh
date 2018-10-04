#!/usr/bin/env bash

# To uninstall
# ./home/bin/stowsh -D -s -t ~/ home
# For some reason this deletes the liquidprompt theme file, so
# git checkout HEAD
./home/bin/stowsh -s -t ~/ home

sudo ./home/bin/stowsh -s -t /usr/share/meld/ meld