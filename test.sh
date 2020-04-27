#!/bin/bash


VSCODE_NEEDED_EXTENSIONS=(
    Anjali.clipboard-history
    HookyQR.beautify
    ms-python.python
    wmaurer.change-case
)

readarray -t listing <<< $(code --list-extensions)

# https://unix.stackexchange.com/a/177589
declare -A existing
for key in "${!listing[@]}"
do 
  existing[${listing[$key]}]="$key"
done

for ext_name in "${VSCODE_NEEDED_EXTENSIONS[@]}"
do
    [[ ! -n "${existing[$ext_name]}" ]] && code --install-extension $ext_name
done
