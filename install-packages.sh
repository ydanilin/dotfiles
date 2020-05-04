#!/bin/bash


# ********************************************
#    Customization variables
# ********************************************

# This is a desired Python version to be installed
PY_VERSION=3.7.7

VSCODE_NEEDED_EXTENSIONS=(
    Anjali.clipboard-history
    HookyQR.beautify
    ms-python.python
    wmaurer.change-case
)


# ********************************************
#    Begin
# ********************************************

sudo apt-get update

# curl
if ! type -p curl > /dev/null; then
    sudo apt -y install curl
fi


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
# clipboard to be functional with Ranger
if ! type -p xsel > /dev/null; then
    sudo apt -y install xsel
fi
# Ranger itself
if ! type -p ranger > /dev/null; then
    sudo apt -y install ranger
fi


# vim
if ! type -p vim > /dev/null; then
    sudo apt -y install vim
fi


# System Python3 libraries
# python3-distutils
if ! dpkg -s python3-distutils >/dev/null 2>&1; then
  sudo apt -y install python3-distutils
fi


# Poetry
if ! type -p poetry > /dev/null; then
    mkdir -p ~/distrib && cd ~/distrib
    curl -sSL -o get-poetry.py https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py
    python3 get-poetry.py
    # this neede to point Poetry to system python3 instead of 2
    source $HOME/.poetry/env
    sed -i "s%^#\!/usr/bin/env python$%#\!/usr/bin/env python3%" $(which poetry)
fi


# PYTHON
# Evaluate current system Python into $SYS_PY_VERSION
sys_pit=$(/usr/bin/python3 --version)
read pit SYS_PY_VERSION <<< "${sys_pit// / }"
# Do install
# if ! update-alternatives --list pythonnn > /dev/null 2>&1; then
    if [ ! -f "/usr/local/bin/python${PY_VERSION::-2}" ]; then
        # https://hackersandslackers.com/multiple-versions-python-ubuntu/
        if ! dpkg -s build-essential >/dev/null 2>&1; then
          sudo apt -y install build-essential
        fi
        if ! dpkg -s checkinstall >/dev/null 2>&1; then
          sudo apt -y install checkinstall
        fi
        pkgs='libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev'
        if ! dpkg -s $pkgs >/dev/null 2>&1; then
          sudo apt -y install $pkgs
        fi
        mkdir -p ~/distrib && cd ~/distrib
        wget https://www.python.org/ftp/python/${PY_VERSION}/Python-${PY_VERSION}.tgz
        tar xzf Python-${PY_VERSION}.tgz
        cd Python-${PY_VERSION}
        ./configure --enable-optimizations
        sudo make altinstall
        # sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
        # sudo update-alternatives --install /usr/bin/python python /usr/bin/python${SYS_PY_VERSION::-2} 2
        # sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python${PY_VERSION::-2} 3
    # else
        # echo -e "\e[1;31mWarning!\e[0m \e[31mPython executable of desired version ${PY_VERSION::-2} exists but not in alternatives!\e[0m"
    fi
# fi


# VSCODE
if ! type -p code > /dev/null; then
    # code itself
    mkdir -p ~/distrib && cd ~/distrib
    echo -e "\e[34mDownloading vscode...\e[0m"
    curl -SL -o vscode-by-script.deb https://go.microsoft.com/fwlink/?LinkID=760868
    sudo apt install ./vscode-by-script.deb
fi


# Vscode extensions
# checking existing
readarray -t listing <<< $(code --list-extensions)
# bash supports dicts !!
# https://unix.stackexchange.com/a/177589
declare -A installed
# if 'listing' is non-empty, populate 'installed' array-dict
if [[ ! ${#listing[0]} -eq 0 ]]; then
    for key in "${!listing[@]}"
    do 
        installed[${listing[$key]}]="$key"
    done
fi

# install if not installed yet
for ext_name in "${VSCODE_NEEDED_EXTENSIONS[@]}"
do
    [[ ! -n "${installed[$ext_name]}" ]] && code --install-extension $ext_name
done


# Docker-shmoker
if ! type -p docker > /dev/null; then
    if ! dpkg -s apt-transport-https >/dev/null 2>&1; then
        sudo apt -y install apt-transport-https
    fi
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update
    # apt-cache policy docker-ce
    sudo apt -y install docker-ce
    # sudo systemctl status docker
    sudo usermod -aG docker ${USER}
    echo -e "\e[1;31mWarning! \e[0m\e[31mPlease reboot after Docker installation\e[0m"
fi


# Fonts
if ! dpkg -s fontforge >/dev/null 2>&1; then
    sudo apt -y install fontforge
fi
if ! dpkg -s ttf-mscorefonts-installer >/dev/null 2>&1; then
    sudo apt -y install ttf-mscorefonts-installer
fi
# My custom collection
if [ ! -d "dist/fnt/" ]; then
    unzip -d dist/fnt/ dist/fnt.zip
    echo -e "\e[1;31mWarning! \e[0m\e[31mTo link fonts, do ./install with sudo\e[0m"
    echo -e "\e[31mDo fc-cache -f -v after that\e[0m"
fi

