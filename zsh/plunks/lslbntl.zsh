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

typeset -A LSLBNTL

function lslbntlv2 () {
  emulate zsh

  local mode
  local -aU groups
  groups=()
  while [[ "$1" != "" ]]; do
  case "$1" in
    "--")
      # stop parsing args
      shift
      break
      ;;
    "-a")
      mode="long"
      shift
      ;;
    "-T"|"--tree")
      mode="tree"
      shift
      ;;
    "-s"|"--short")
      mode="short"
      shift
      ;;
    "-h"|"--help")
      while IFS="" read -r line; do printf '%b\n' "$line"; done << EOF
${0}: lslbntl: ls long but not too long
usage: ${0} [OPTION]... [--] [directories or files]...
EOF
      true
      return
      ;;
    -*)
      echo "lslbntl: Unknown option: $1"
      false
      return
      ;;
    *)
      # non-option arg, done
      break
      ;;
  esac
  done

  # find out how many files we could potentially list:
  local -a onelevel_all
  onelevel_all=()
  for n in ${@:-"."}; do
    if [[ -d ${n} ]]; then
      onelevel_all+=( ${n}/(*|.*) )
    elif [[ -e ${n} ]]; then
      onelevel_all+=( ${n} )
    else
      builtin printf '%b\n' "lslbntl: ${n} does not exist"
      false
      return
    fi
  done

  if [[ ! -n "${mode}" ]]; then
    # if we can show everything on one screen
    if (( ${#onelevel_all} < LINES )); then
      # if we can show it in tree mode, do so
      local -a tree_all
      tree_all=()
      for n in ${@:-"."}; do
        echo searching $n
        if [[ -d ${n} ]]; then
          tree_all+=( ${n}/**/* )
        else
          tree_all+=( ${n} )
        fi
        (( ${#tree_all} > LINES )) && break
      done

      echo tree ${#tree_all}
      if (( ${#tree_all} < LINES )); then
        # show in tree form
        mode="tree"
      else
        # show all non-recursively
        echo long form
        mode="long"
      fi
    else
      # we can't show it all on one screen, show short version
      echo short form
      mode="short"
      echo ${#onelevel_all}
    fi
  fi

  echo $mode

  ### perform automatic group detection
  # "only show group if important"
  local -aU potential_files
  potential_files=()
  if [[ ${mode} == "tree" ]]; then
    potential_files=(${onelevel_all} ${tree_all})
  else
    potential_files=(${onelevel_all})
  fi
  builtin zstat -s -L -A groups +gid ${potential_files}
  groups+=( $USER )
  echo grps: $groups

  # detect which backend and execute command
  if (( ${+commands[exa]} )); then
    exa_common_args=(--git )
    if (( ${#groups} > 1 )); then
      # show groups
      exa_common_args+=( -g )
      echo show groups
    fi
    case ${mode} in
      tree )
        exa ${exa_common_args} -lT "${@:-.}"
        ;;
      short )
        exa ${exa_common_args} -l "${@:-.}"
        ;;
      long )
        exa ${exa_common_args} -la "${@:-.}"
        ;;
    esac
  elif (( ${+commands[tree]} )); then
    #
  fi
}
