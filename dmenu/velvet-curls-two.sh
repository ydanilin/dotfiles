#!/bin/bash


i3-msg "workspace 1; append_layout ~/.dotfiles/i3/velvetstyle.json"

# curls folder starts first
gnome-terminal \
    --working-directory=$HOME/dev/pitonizm/velvet \
    --role=velvet-curls-terminal-gnome-dual \
    -- /bin/bash --rcfile $HOME/.dotfiles/dmenu/velvpoetrycurlrc

# server starts second to be focused ))
gnome-terminal \
    --working-directory=$HOME/dev/pitonizm/velvet \
    --role=velvet-server-terminal-gnome-dual \
    -- /bin/bash --rcfile $HOME/.dotfiles/dmenu/velvpoetryrc
