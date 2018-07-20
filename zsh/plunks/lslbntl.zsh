#!/bin/zsh
### LSLBNTL: ls long, but not too long
# Complicated fix to show just what I want from ls
#
# Because I got tired of typing `l` in my home directory and getting spammed
# with the amount of hidden names filling the screen space.
# Also only shows group if different than user or between file/folder arguments
#
# Recommended usage:
#
# ```
# alias l="lslbntl" # automatic
# alias ll="$Z_LSBASE <your other args> $Z_LSARG_LONG"
# alias la="$Z_LSBASE <your other args> $Z_LSARG_LONG $Z_LSARG_ALL"
# ```
#
# BUG(s):
# Automatic hide/show of group will not check the group for file arguments
# beginning with a `-` at the beginning
#  ($@ args beginning with '-' are ignored for the call to zstat)

# stat module faster than external call
zmodload zsh/stat
autoload -U zargs

# required variables are set?
(( ${+Z_LSBASE} )) && \
(( ${+Z_LSARG_LONG} )) && \
(( ${+Z_LSARG_ALL} )) || \
printf '%b\n' "\033[0;31mlslbntl: missing a required Z_LS* envvar!\033[0m"

function lslbntl() {
  local Z_TMP_LS_DOTSHOWN
  local Z_TMP_STAT_GIDU
  local Z_TMP_GRP
  typeset -U Z_TMP_STAT_GIDU
  if [ -t 1 ]; then
    # collect list of groups for current directory and specified target args
    builtin zstat -s -A Z_TMP_STAT_GIDU +gid . "${@:#-*}"
    # display group if there are differences
    if (( ${#Z_TMP_STAT_GIDU} > 1 )) || [[ ${Z_TMP_STAT_GIDU[1]} != $USER ]]; then
      Z_TMP_GRP=''
      [[ $Z_LSBASE == 'exa' ]] && Z_TMP_GRP='-g'
    else
      Z_TMP_GRP='-g'
      [[ $Z_LSBASE == 'exa' ]] && Z_TMP_GRP=''
    fi
    # force color on
    Z_TMP_LS_DOTSHOWN=$($Z_LSBASE $Z_TMP_GRP $Z_LSARG_HUMAN $Z_LSARG_LONG $Z_LSARG_ALL $Z_LSARG_FORCE_COLOR "$@" 2>&1 )
  else
    # no color for non-tty
    Z_TMP_LS_DOTSHOWN=$($Z_LSBASE $Z_LSARG_HUMAN $Z_LSARG_LONG $Z_LSARG_ALL "$@" 2>&1 )
  fi
  local Z_TMP_LS_DOTSHOWN_SIZE
  Z_TMP_LS_DOTSHOWN_SIZE=$(echo "$Z_TMP_LS_DOTSHOWN" | wc -l)
  # does not show hidden files if the terminal height can't show everything
  if [[ "$Z_TMP_LS_DOTSHOWN_SIZE" -gt "${LINES}" ]]; then
    echo "Not showing hidden files"
    $Z_LSBASE $Z_TMP_GRP $Z_LSARG_HUMAN $Z_LSARG_LONG "$@"
  else
    printf '%b\n' "$Z_TMP_LS_DOTSHOWN"
  fi
}
