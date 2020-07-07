#!/bin/zsh

repo_uri="$1"
target_path="$2"

if [[ -z $repo_uri ]] || [[ ! -d $target_path ]]; then
  echo "$0 user@host:/path/to/repo /folder"
  exit 0
fi

cmd="sudo nice borg create --stats --progress '${repo_uri}::{hostname}-{now:%Y-%m-%d}-${target_path//\//-}' $target_path"
echo "$cmd"
printf '%s' 'Run command? [y/n]'

if read -q accept; then
  echo
  zsh -ic $cmd
else
  echo ""
fi
