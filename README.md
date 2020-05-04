# My settings management system
The principle is to collect real settings files in one repo and provide symlinks in `/home` subfolders where programs used to find their configurations.  
[Dotbot](https://github.com/anishathalye/dotbot) used to automate this symlink process.

One more part is to automate packages installation, `install-packages.sh` used for this. Tried to make this script idempotent.

## Repo clone
```bash
mkdir ~/.dotfiles && cd ~/.dotfiles  
git init  
git remote add origin https://github.com/ydanilin/dotfiles.git  
git fetch origin  
git merge origin/master  
git submodule update --init --recursive  
./install-packages.sh
./install  
