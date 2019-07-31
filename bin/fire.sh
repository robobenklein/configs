#!/bin/zsh

function fire {
  (( ${+commands[firejail]} )) || {
    printf 'Nope.'
    return 1
  }

  prog="$1"
  shift
  case "$prog" in
    "discord" )
      #export GTK_IM_MODULE=xim
      firejail "$@" --join-or-start=discord --x11=xorg discord-canary --disable-smooth-scrolling
      ;;
    "steam" )
      firejail --join-or-start=steam "$@" steam
      ;;
    "steam-sc-only" )
      firejail --noprofile --join-or-start=steam '--blacklist=/dev/usb' '--blacklist=/dev/bus' '--blacklist=/dev/hidraw*' "$@" steam
      ;;
    * )
      echo "$prog" "$@"
      echo "???"
      return 1
      ;;
  esac
}

[ "$(basename "$0")" = fire.sh ] && fire "$@"
