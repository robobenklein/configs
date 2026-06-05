#!/bin/zsh
# only good for borg v1

repo_uri="$1"
shift
target_paths=($@)
extra_opts=( --stats --progress --exclude '/home/*/.cache' --exclude '/root/.cache' --exclude '/home/*/.local/share/Trash' )
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
  #extra_opts+=( --one-file-system )
  target_paths=( /boot /etc /home /opt /root /srv /usr )
  # some paths are just links into /usr (on some systems)
  if_present_paths=( /bin /lib /lib32 /lib64 /libx32 /sbin /var/lib /var/www /var/mail /var/log /var/backups )
  for dir in $if_present_paths; do
    [[ -e $dir ]] && target_paths+=("$dir")
  done
}

echo "Target paths: ${target_paths}"
echo "Archive name: ${archive_name}"
echo "Borg version: $($borg_cmd --version)"

cmd=(sudo nice $borg_cmd create ${extra_opts} "${repo_uri}"'::{hostname}-{now}-'"${archive_name//\//-}" ${target_paths})
echo "$cmd"
printf '%s' 'Run command? [y/n]'

if read -q accept; then
  echo
  ${cmd[@]}
else
  echo ""
fi
