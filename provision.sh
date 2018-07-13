#!/bin/bash
NOW="$(date --rfc-3339=date)"
mkdir -p ~/code
pushd ~/code
git clone https://github.com/robobenklein/configs.git
pushd configs
./install
popd
popd
# this installs the bundles for first-time operation
if command -v zsh; then
  touch ~/.z
  zsh -i -c -- '-zplg-scheduler burst'
fi
