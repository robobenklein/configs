#!/bin/bash
set -e
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir -p ~/code
cd ~/code
git clone https://github.com/robobenklein/configs.git
mv ~/.zshrc ~/.zshrc.old
ln -s ~/code/configs/zsh/.zshrc ~/.zshrc
echo "Linked new zshrc"

