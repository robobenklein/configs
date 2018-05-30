
# ls long, but not too long

# complicated fix to not show too many dotfiles for just 'l'
# does not show hidden files if the terminal height can't show everything
# TODO figure out how to avoid running _ALL command twice if possible
function lslbntl() {
  local Z_LSARGS="-lh"
  local Z_LSARGS_ALL="-lah"
  local Z_TMP_LS_DOTSHOWN=$($Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS_ALL "$@" 2>&1 )
  local Z_TMP_LS_DOTSHOWN_SIZE=$(echo "$Z_TMP_LS_DOTSHOWN" | wc -l)
  if [[ "$Z_TMP_LS_DOTSHOWN_SIZE" -gt "$(tput lines)" ]]; then # then don't show hidden files
    echo "Not showing hidden files"
    $Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS "$@"
  else
    $Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS_ALL "$@"
  fi
}
