#!/bin/bash

sudo apt-get update

# rofi
if ! type -p rofi > /dev/null; then
    sudo apt -y install rofi
fi

# jq
if ! type -p jq > /dev/null; then
    sudo apt -y install jq
fi

# make
if ! type -p make > /dev/null; then
    sudo apt -y install make
fi

# for xkb-switch-i3
if ! type -p cmake > /dev/null; then
    sudo apt -y install cmake
fi
if ! type -p pkg-config > /dev/null; then
    sudo apt -y install pkg-config
fi
pkgs='libxkbfile-dev libjsoncpp-dev'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt -y install $pkgs
fi
# impossible to bypass because libsigc++ is a set of libs?
if ! dpkg -s libsigc++ >/dev/null 2>&1; then
  sudo apt -y install libsigc++
fi
if ! type -p xkb-switch > /dev/null; then
    mkdir -p ~/distrib && cd ~/distrib
    git clone https://github.com/Zebradil/xkb-switch-i3.git
    cd xkb-switch-i3/
    git submodule update --init
    cmake .
    make
    sudo make install
    sudo ldconfig
    i3-msg -t command restart
fi

# gnome-terminal settings
dconf write /org/gnome/terminal/legacy/default-show-menubar false
dconf write /org/gnome/terminal/legacy/menu-accelerator-enabled false
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1}
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ exit-action 'close'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-transparency false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color 'rgb(0,0,0)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color 'rgb(0,255,0)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['rgb(46,52,54)', 'rgb(204,0,0)', 'rgb(78,154,6)', 'rgb(196,160,0)', 'rgb(52,101,164)', 'rgb(117,80,123)', 'rgb(6,152,154)', 'rgb(211,215,207)', 'rgb(85,87,83)', 'rgb(239,41,41)', 'rgb(138,226,52)', 'rgb(252,233,79)', 'rgb(114,159,207)', 'rgb(173,127,168)', 'rgb(52,226,226)', 'rgb(238,238,236)']"

# ranger
if ! type -p xsel > /dev/null; then
    sudo apt -y install xsel
fi
if ! type -p ranger > /dev/null; then
    sudo apt -y install ranger
fi

# vim
if ! type -p vim > /dev/null; then
    sudo apt -y install vim
fi
