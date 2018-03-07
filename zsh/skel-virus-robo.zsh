# Skel virus for zsh config
set -e
set -E
LOGFILE="/tmp/${USER}-skelvirus-zsh.log"
mkdir -p ~/code/
cp -R ~robo/code/configs ~/code
pushd ~/code/configs
./install >$LOGFILE
popd
if sudo -n -v >$LOGFILE 2>&1 ; then
  sudo -n chsh ${USER} -s $(which zsh)
fi
if [ -z "$SKELVIRUS_TERM" ]; then
  export SKELVIRUS_TERM=1
  touch ~/.z
  source ~/.zshrc >$LOGFILE 2>&1 
fi
set +E
set +e
