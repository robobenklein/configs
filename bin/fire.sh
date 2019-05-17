#!/bin/zsh

function fire {
  (( ${+commands[firejail]} )) || {
    printf 'Nope.'
    return 1
  }

  case "$1" in
    "discord" )
      export GTK_IM_MODULE=xim
      firejail --profile=discord --join-or-start=discord --x11=xorg discord-canary --disable-smooth-scrolling
      ;;
    "steam" )
      firejail --join-or-start=steam steam
      ;;
    "steam-nocontroller" )
      firejail --join-or-start=steam '--blacklist=/dev/usb' '--blacklist=/dev/bus' '--blacklist=/dev/hidraw*' steam
      ;;
  esac
}

[ "$(basename "$0")" = fire.sh ] && fire "$@"
