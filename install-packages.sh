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
    tintinweb.vscode-vyper
    nobuhito.printcode
    janisdd.vscode-edit-csv
    marioschwalbe.gnuplot
    eckertalex.borealis
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


# colortest
if ! type -p colortest-16 > /dev/null; then
    sudo apt -y install colortest
fi


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


# stuff for brightness for notebook
if sudo dmidecode -s system-product-name | grep VPCEA3M1R > /dev/null; then
    if ! type -p light > /dev/null; then
        mkdir -p ~/distrib && cd ~/distrib
        curl -sSL -o light_1.2_amd64.deb https://github.com/haikarainen/light/releases/download/v1.2/light_1.2_amd64.deb
        sudo dpkg -i light_1.2_amd64.deb
        sudo usermod -a -G video $USER
        sudo chgrp video /sys/class/backlight/radeon_bl0/brightness
        sudo chmod 664 /sys/class/backlight/radeon_bl0/brightness
    fi
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


# Net-tools
if ! dpkg -s net-tools >/dev/null 2>&1; then
  sudo apt -y install net-tools
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


# Skype
if ! type -p skypeforlinux > /dev/null; then
    mkdir -p ~/distrib && cd ~/distrib
    wget https://go.skype.com/skypeforlinux-64.deb -O skypeforlinux.deb
    sudo apt -y install ./skypeforlinux.deb
fi
# Zoom
if ! type -p zoom > /dev/null; then
    mkdir -p ~/distrib && cd ~/distrib
    wget https://zoom.us/client/latest/zoom_amd64.deb -O zoom.deb
    sudo apt -y install ./zoom.deb
fi


# Gparted
if ! type -p gparted > /dev/null; then
    sudo apt -y install gparted
fi


# Keepassxc
if ! type -p keepassxc > /dev/null; then
    sudo apt -y install keepassxc
fi


# Codecs & video
if ! dpkg -s ubuntu-restricted-extras >/dev/null 2>&1; then
    sudo apt -y install ubuntu-restricted-extras
fi

if ! type -p vlc > /dev/null; then
    sudo apt -y install --no-install-recommends vlc
fi


# Team Viewer
if ! type -p teamviewer > /dev/null; then
    sudo apt -y install libqt5qml5 libqt5quick5 libqt5webkit5 qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtquick-dialogs qml-module-qtquick-window2 qml-module-qtquick-layouts
    mkdir -p ~/distrib && cd ~/distrib
    wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -O teamviewer.deb
    sudo dpkg -i ./teamviewer.deb
fi


# Inkscape
if ! type -p inkscape > /dev/null; then
    sudo add-apt-repository -y ppa:inkscape.dev/stable
    sudo apt update
    sudo apt -y install inkscape
fi

# Inkscape circuit symbols
MADE_EASY_DIR=~/.config/inkscape/extensions/inkscapeMadeEasy
MADE_EASY_GIT=https://raw.githubusercontent.com/fsmMLK/inkscapeMadeEasy/master/latest
CIRCUIT_DIR=~/.config/inkscape/extensions/circuitSymbols
CIRCUIT_GIT=https://raw.githubusercontent.com/fsmMLK/inkscapeCircuitSymbols/master/latest

mkdir -p $MADE_EASY_DIR
wget --quiet --show-progress -nc -P $MADE_EASY_DIR "$MADE_EASY_GIT/basicLatexPackages.tex"
wget --quiet --show-progress -nc -P $MADE_EASY_DIR "$MADE_EASY_GIT/inkscapeMadeEasy_Base.py"
wget --quiet --show-progress -nc -P $MADE_EASY_DIR "$MADE_EASY_GIT/inkscapeMadeEasy_Draw.py"
wget --quiet --show-progress -nc -P $MADE_EASY_DIR "$MADE_EASY_GIT/inkscapeMadeEasy_Plot.py"
sed -i -e 's/# useLatex=False/useLatex=False/g' $MADE_EASY_DIR/inkscapeMadeEasy_Draw.py

mkdir -p $CIRCUIT_DIR
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/circuitSymbols.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/circuitSymbolsPreamble.tex"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/circuitSymbols_general.inx"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/circuitSymbols_semiconductors.inx"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawAmpOp.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawArrows.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawDiodes.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawRLC.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawSignals.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawSources.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawSwitches.py"
wget --quiet --show-progress -nc -P $CIRCUIT_DIR "$CIRCUIT_GIT/drawTransistors.py"


# GIMP
if ! type -p gimp > /dev/null; then
    sudo apt -y install gimp
fi


# Java stuff
if ! dpkg -s openjdk-8-jre >/dev/null 2>&1; then
    sudo apt -y install openjdk-8-jre
fi
if ! dpkg -s openjfx >/dev/null 2>&1; then
    sudo apt -y install openjfx
fi


# Node.js via nvm
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


NVM_VERSION=0.35.3
if ! type -t nvm > /dev/null; then
    mkdir -p ~/distrib && cd ~/distrib
    curl -sL https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh -o install_nvm.sh
    chmod +x ./install_nvm.sh
    ./install_nvm.sh
    NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

NODE_VERSION=12.16.3
# up to now, do not check for specific version
if ! type -p node > /dev/null; then
    nvm install $NODE_VERSION
fi


# fbreader for epub
if ! type -p fbreader > /dev/null; then
    sudo apt -y install fbreader
fi


# gnuplot
if ! type -p gnuplot > /dev/null; then
    sudo apt -y install gnuplot
fi


# celestia
if ! type -p celestia > /dev/null; then
    sudo wget -O- https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
    echo 'deb https://dl.bintray.com/celestia/releases-deb bionic universe' | sudo tee -a /etc/apt/sources.list.d/celestia-bintray.list
    sudo apt update
    sudo apt -y install celestia
fi


# sshfs
if ! type -p sshfs > /dev/null; then
    sudo apt -y install sshfs
fi
