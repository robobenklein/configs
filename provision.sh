#!/bin/bash
NOW="$(date --rfc-3339=date)"
mkdir -p ~/code
pushd ~/code
git clone https://github.com/robobenklein/configs.git
pushd configs
./install
popd
popd

