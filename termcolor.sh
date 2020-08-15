#!/bin/bash


# Solarized themes from here:
# https://ethanschoonover.com/solarized/

# see colors:
# colortest-16b

# see Gnome-terminal settings:
# https://unix.stackexchange.com/questions/133914/set-gnome-terminal-background-text-color-from-bash-script

# colors on Stackoverflow:
# https://stackoverflow.com/a/33206814

# Common
S_yellow='#B58900'
S_orange='#CB4B16'
S_red='#DC322F'
S_magenta='#D33682'
S_violet='#6C71C4'
S_blue='#268BD2'
S_cyan='#2AA198'
S_green='#859900'

# Dark
# S_base03='#002B36'
# S_base02='#073642'
# S_base01='#586E75'
# S_base00='#657B83'
# S_base0='#839496'
# S_base1='#93A1A1'
# S_base2='#EEE8D5'
# S_base3='#FDF6E3'

# Light
S_base03='#FDF6E3'
S_base02='#EEE8D5'
S_base01='#93A1A1'
S_base00='#626262' #839496
S_base0='#657B83'
S_base1='#586E75'
S_base2='#073642'
S_base3='#002B36'

# Begin the magic
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1}

# echo
# echo 'Change color theme for Gnome terminal'
# echo

PS3="Select a scheme: "

select action in "Solarized Light" \
                 "Standard"
do
    case $action in
        "Solarized Light" )
            background=$S_base03
            foreground=$S_base00

            color00=$S_base02
            color01=$S_red
            color02=$S_green
            color03=$S_yellow
            color04=$S_blue
            color05=$S_magenta
            color06=$S_cyan
            color07=$S_base2

            color08='rgb(46,52,54)'
            color09='rgb(204,0,0)'
            color10='rgb(138,226,52)'
            color11='rgb(252,233,79)'
            color12='rgb(114,159,207)'
            color13='rgb(173,127,168)'
            color14='rgb(52,226,226)'
            color15='rgb(238,238,236)'
            ;;
        "Standard" )
            background='rgb(0,0,0)'
            foreground='rgb(0,255,0)'

            color00='rgb(46,52,54)'
            color01='rgb(204,0,0)'
            color02='rgb(78,154,6)'
            color03='rgb(196,160,0)'
            color04='rgb(52,101,164)'
            color05='rgb(117,80,123)'
            color06='rgb(6,152,154)'
            color07='rgb(211,215,207)'

            color08='rgb(85,87,83)'
            color09='rgb(239,41,41)'
            color10='rgb(138,226,52)'
            color11='rgb(252,233,79)'
            color12='rgb(114,159,207)'
            color13='rgb(173,127,168)'
            color14='rgb(52,226,226)'
            color15='rgb(238,238,236)'
            ;;
    esac
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color $background
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color $foreground
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['$color00', '$color01', '$color02', '$color03', '$color04', '$color05', '$color06', '$color07', '$color08', '$color09', '$color10', '$color11', '$color12', '$color13', '$color14', '$color15']"
    break
done
