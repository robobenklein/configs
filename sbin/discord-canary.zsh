#!/bin/zsh
wget 'https://discordapp.com/api/download/canary?platform=linux' -O /tmp/discord-canary.deb
sudo apt install /tmp/discord-canary.deb
