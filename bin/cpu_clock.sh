#!/bin/zsh

echo "CPU Freq Range $(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq | uniq) - $(cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq | uniq)"
echo "Scaling Range $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq | uniq) - $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq | uniq)"

# prompt to set clockspeed
echo -n "New clockspeed? : "
read new_clock
echo $new_clock | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
