#!/bin/zsh
pacmd unload-module module-ladspa-sink
master="$(pacmd list-sinks | grep 'name:' | egrep -o 'alsa_output.[^>]+' | tail -1)"
echo "master: $master"
pacmd load-module module-ladspa-sink sink_name=ladspa_normalized_with_gain sink_master="$master" plugin=fast_lookahead_limiter_1913 label=fastLookaheadLimiter control=0.1,-20,1.0
pacmd set-default-sink ladspa_normalized_with_gain
