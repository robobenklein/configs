killall conky
thisdir="$(dirname "$0")"
sleep 0.1
conky -c "$thisdir/Datetime Overview" &
conky -c "$thisdir/Horizontal 1-32 CPU" &
