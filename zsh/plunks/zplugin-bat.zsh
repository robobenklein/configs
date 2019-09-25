
function zplg-setup-bat () {
  # bat musl x64 tarball
  if [[ $unamearch == "x86_64" ]]; then
    if [[ $unamestr == "Linux" ]]; then
      zplugin ice nocompletions from"gh-r" bpick"*-musl*" \
        as"program" mv"bat-*/bat -> bat" pick"bat" id-as'bat'
      zplugin load sharkdp/bat
    elif [[ $unamestr == "Darwin" ]]; then
      # not yet implemented
    fi
  fi

  function zplg-remove-bat () {
    zplugin unload bat
    rm -rf ${ZPLGM[PLUGINS_DIR]}/bat
    rehash
  }
}
# manage it if it's already there
[[ -d ${ZPLGM[PLUGINS_DIR]}/bat ]] && {
  zplg-setup-bat
}
