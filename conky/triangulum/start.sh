killall conky
thisdir="$(dirname "$0")"
conky -c "$thisdir/Datetime Overview" &
conky -c "$thisdir/Horizontal 1-16 CPU" &
