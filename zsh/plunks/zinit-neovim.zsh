
function zinit-setup-neovim () {
  # neovim linux appimage on x64
  if [[ $unamearch == "x86_64" ]]; then
    if [[ $unamestr == "Linux" ]]; then
      zinit ice nocompletions from"gh-r" bpick"*.appimage" \
        as"program" mv"nvim.appimage -> nvim" pick"nvim" id-as'neovim'
      zinit load neovim/neovim
    elif [[ $unamestr == "Darwin" ]]; then
      # not yet implemented
    fi
  fi

  function zinit-remove-neovim () {
    zinit unload neovim
    rm -rf ${ZINIT[PLUGINS_DIR]}/neovim
    rehash
  }
}
# manage it if it's already there
[[ -d ${ZINIT[PLUGINS_DIR]}/neovim ]] && {
  zinit-setup-neovim
}
