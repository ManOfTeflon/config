#!/bin/bash

log="$1"
cmd="${@:2}"

# Set up the scrolling region and write into the non-scrolling line
TMUX= tmux -f "$HOME/.tmux.logged.conf" new-session "tmux_logged_output.sh '$log' $cmd"

