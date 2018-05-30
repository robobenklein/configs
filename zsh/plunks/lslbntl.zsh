
# ls long, but not too long

# complicated fix to not show too many dotfiles for just 'l'
# does not show hidden files if the terminal height can't show everything
function lslbntl() {
  local Z_TMP_LS_DOTSHOWN_SIZE=$($Z_LSBASE $Z_LSARGEXTRA -lah $@ 2>/dev/null | wc -l)
  if [[ $Z_TMP_LS_DOTSHOWN_SIZE -gt $(tput lines) ]]; then # then don't show hidden files
    echo "Not showing hidden files"
    Z_LSARGS="-lh"
  else
    Z_LSARGS="-lah"
  fi
  $Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS $@
}
