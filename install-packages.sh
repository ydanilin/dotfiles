#!/bin/bash

sudo apt-get update

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
