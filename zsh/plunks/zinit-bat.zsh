
function zinit-setup-bat () {
  # bat musl x64 tarball
  if [[ $unamearch == "x86_64" ]]; then
    if [[ $unamestr == "Linux" ]]; then
      zinit ice nocompletions from"gh-r" bpick"*-musl*" \
        as"program" mv"bat-*/bat -> bat" pick"bat" id-as'bat'
      zinit load sharkdp/bat
    elif [[ $unamestr == "Darwin" ]]; then
      # not yet implemented
    fi
  fi

  function zplg-remove-bat () {
    zinit unload bat
    rm -rf ${ZPLGM[PLUGINS_DIR]}/bat
    rehash
  }
}
# manage it if it's already there
[[ -d ${ZPLGM[PLUGINS_DIR]}/bat ]] && {
  zinit-setup-bat
}
