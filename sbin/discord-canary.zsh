#!/bin/zsh
wget 'https://discordapp.com/api/download/canary?platform=linux' -O /tmp/discord-canary.deb
#wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O /tmp/discord.deb
sudo apt install /tmp/discord-canary.deb
