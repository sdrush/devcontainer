#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    zplug \
    direnv \
    sqlite3 \
    fonts-powerline \
    fzf 
    
sudo chmod 775 /usr/share/zplug
sudo chown root:vscode /usr/share/zplug