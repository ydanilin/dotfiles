#!/bin/bash

# Script to show current keyboard layout in i3status bar
# Requires https://github.com/Zebradil/xkb-switch-i3

i3status | while :
do
    read line

    LG=$(xkb-switch | tr -d '\n\r')
    OLDIFS=$IFS
    IFS=$'\n' LAYOUT=( $(xkb-switch -l) )
    IFS=$OLDIFS

    lastidx=$( expr ${#LAYOUT[@]} - 1 )
    res="[{ \"full_text\": \"🖮:\", \"separator\":false, \"separator_block_width\": 6 }"
    for index in "${!LAYOUT[@]}"
    do
        i="${LAYOUT[index]}"
        if [ $i == $LG ]
        then
            c=", \"color\":\"#FF0000\", \"border\":\"#AAAAAA\""
        else
            c=", \"color\":\"#444444\""
        fi

        if [[ $index -eq $lastidx ]]; then
            e=""
        else
            e=", \"separator\":false, \"separator_block_width\": 6 "
        fi
        res="$res,{ \"full_text\": \"$i\"$c$e}"
    done
    echo "${line/[/$res,}" || exit 1
done
