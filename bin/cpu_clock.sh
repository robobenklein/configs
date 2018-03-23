#!/bin/zsh

hwrange="$(($(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq | uniq) / 1000 )) - $(($(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq | uniq) / 1000 ))"
scalerange="$(($(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq | uniq) / 1000)) - $(($(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq | uniq) / 1000))"

eval "$(resize)"

# prompt to set clockspeed
if [ -z "$cpuprog" ]; then
cpuprog=$(whiptail --title "Choose Action" \
  --menu "Hardware: ${hwrange} Scaling: ${scalerange}" \
  $(( LINES - 4 )) $(( COLUMNS - 18 )) $(( $LINES - 12 )) \
  "cancel" "Do nothing." \
  "set_minfreq" "Set the minimum scale frequency." \
  "set_maxfreq" "Set the maximum scale frequency." \
  3>&1 1>&2 2>&3
)
fi

case $cpuprog in
  set_minfreq)
    echo -n "New min clockspeed? (MHz) : "
    read new_clock
    echo $(($new_clock * 1000)) | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq
    ;;
  set_maxfreq)
    echo -n "New max clockspeed? (MHz) : "
    read new_clock
    echo $(($new_clock * 1000)) | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
    ;;
  cancel)
    ;;
esac

hwrange="$(($(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq | uniq) / 1000 )) - $(($(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq | uniq) / 1000 ))"
scalerange="$(($(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq | uniq) / 1000)) - $(($(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq | uniq) / 1000))"

echo "HWRANGE $hwrange"
echo "SFRANGE $scalerange"

