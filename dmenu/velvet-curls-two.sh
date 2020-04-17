#!/bin/bash


i3-msg "workspace 1; append_layout ~/.dotfiles/i3/velvetstyle.json"

gnome-terminal \
    --working-directory=$HOME/dev/pitonizm/velvet/prototypes/curls \
    --role=velvet-curls-terminal-gnome-dual \
    -- /bin/bash --rcfile $HOME/.dotfiles/dmenu/cryptcondarc

# server starts second to be focused ))
gnome-terminal \
    --working-directory=$HOME/dev/pitonizm/velvet \
    --role=velvet-server-terminal-gnome-dual \
    -- /bin/bash --rcfile $HOME/.dotfiles/dmenu/velvcondarc
