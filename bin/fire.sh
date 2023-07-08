#!/bin/zsh

function fire {
  (( ${+commands[firejail]} )) || {
    printf 'Nope. No firejail.'
    return 1
  }

  # fix Error: too long environment variables
  unset LS_COLORS

  prog="$1"
  shift
  case "$prog" in
    "discord" )
      export GTK_IM_MODULE=uim
      if (( ${+commands[discord-canary]} )); then
        firejail "$@" --join-or-start=discord discord-canary --disable-smooth-scrolling
      else
        firejail "$@" --join-or-start=discord discord --disable-smooth-scrolling
      fi
      ;;
    "steam" )
      firejail --join-or-start=steam "$@" steam
      ;;
    "steam-sc-only" )
      # prevents usb device access
      firejail --join-or-start=steam \
       '--blacklist=/dev/usb' \
       '--blacklist=/dev/bus' \
       '--blacklist=/dev/hidraw*' \
       "$@" steam
      ;;
    * )
      echo "$prog" "$@"
      echo "???"
      return 1
      ;;
  esac
}

[ "$(basename "$0")" = fire.sh ] && fire "$@"
