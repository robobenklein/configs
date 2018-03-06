# Skel virus for zsh config
set -e
mkdir -p ~/code/
cp -R ~robo/code/configs ~/code
pushd ~/code/configs
./install
popd
if [ -z "$SKELVIRUS_TERM" ]; then
  export SKELVIRUS_TERM=1
  touch ~/.z
  source ~/.zshrc
fi

