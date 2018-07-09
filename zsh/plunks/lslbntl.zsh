
# ls long, but not too long

if (( ${+Z_LSBASE} )); then
  Z_LSARG_FORCE_COLOR='--color=always'
  if (( ${+commands[exa]} )); then
    Z_LSBASE="exa"
  else
    Z_LSBASE="ls"
    if [[ "$(uname)" == "Darwin" ]]; then
      export Z_LSARG_FORCE_COLOR='-G'
    fi
  fi
fi

# complicated fix to not show too many dotfiles for just 'l'
# does not show hidden files if the terminal height can't show everything
function lslbntl() {
  # TODO enforce that variables are set
  local Z_LSARGS="-lh"
  local Z_LSARGS_ALL="-lah"
  if [ -t 1 ]; then
    local Z_TMP_LS_DOTSHOWN=$($Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS_ALL $Z_LSARG_FORCE_COLOR "$@" 2>&1 )
  else
    local Z_TMP_LS_DOTSHOWN=$($Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS_ALL "$@" 2>&1 )
  fi
  local Z_TMP_LS_DOTSHOWN_SIZE=$(echo "$Z_TMP_LS_DOTSHOWN" | wc -l)
  if [[ "$Z_TMP_LS_DOTSHOWN_SIZE" -gt "$(tput lines)" ]]; then # then don't show hidden files
    echo "Not showing hidden files"
    $Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS "$@"
  else
    printf '%b\n' "$Z_TMP_LS_DOTSHOWN"
  fi
}

# recommended to `alias l=lslbntl`
