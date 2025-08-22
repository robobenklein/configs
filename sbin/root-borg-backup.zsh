#!/bin/zsh

repo_uri="$1"
shift
target_paths=($@)
extra_opts=( --stats --progress --exclude '/home/*/.cache' --exclude '/root/.cache' )
borg_cmd=${BORG_COMMAND:-borg}

if [[ -z $repo_uri ]]; then
  echo "$0 user@host:/path/to/repo /folder"
  exit 0
fi
(( ${#target_paths} )) && {
  path_names=()
  for d in $target_paths ; do
    fromroot="${d#/}"
    path_names+=("${fromroot//\//_}")
  done
  archive_name="${(j.,.)path_names}"
} || {
  archive_name="robo-system-script"
  extra_opts+=( --one-file-system )
  target_paths=( /boot /etc /home /opt /root /srv /usr /var )
  # some paths are just links into /usr (on some systems)
  if_present_paths=( /bin /lib /lib32 /lib64 /libx32 /sbin )
  for dir in $if_present_paths; do
    [[ -e $dir ]] && target_paths+=("$dir")
  done
}

echo "Target paths: ${target_paths}"
echo "Archive name: ${archive_name}"

cmd=(sudo nice $borg_cmd create ${extra_opts} "${repo_uri}"'::{hostname}-{now:%Y-%m-%d}-'"${archive_name//\//-}" ${target_paths})
echo "$cmd"
printf '%s' 'Run command? [y/n]'

if read -q accept; then
  echo
  ${cmd[@]}
else
  echo ""
fi
