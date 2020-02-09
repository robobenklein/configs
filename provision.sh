#!/bin/bash
# curl -fsSL https://raw.githubusercontent.com/robobenklein/configs/master/provision.sh | bash
NOW="$(date --rfc-3339=date)"
mkdir -p ~/code
pushd ~/code
[[ ! -d configs ]] && {
  git clone https://github.com/robobenklein/configs.git
}
pushd configs
git submodule update --init --recursive
./install
popd
popd
# this installs the bundles for first-time operation
if command -v zsh; then
  touch ~/.z
  echo | zsh -i -c -- '@zinit-scheduler burst' || true
fi
