
if (( ! ${+commands[nvim]} )) || [[ ! -z ZSHRC_MANAGE_NVIM ]]; then
  # neovim linux appimage on x64
  if [[ $unamearch == "x86_64" ]]; then
    if [[ $unamestr == "Linux" ]]; then
      zplugin ice nocompletions from"gh-r" bpick"*.appimage" \
        as"program" mv"nvim.appimage -> nvim" pick"nvim" id-as'neovim'
      zplugin load neovim/neovim
    fi
  fi
fi
