
# Last Command Arguments
#
# usage: `lca <new base command>`
#
# example:
#
# busy browsing with tab completion...
# $ ls /path/to/
# $ ls /path/to/long/
# $ ls /path/to/long/file.c
# oh wait you wanted to edit it now?
# $ lca vim
# replaces the current command buffer with:
# $ vim /path/to/long/file.c

function lca () {
  lastcmd=$history[$(( $HISTCMD - 1 ))]
  lastargs=$(echo "$lastcmd" | cut -d ' ' -f2-)
  print -z "$@" "$lastargs"
}
