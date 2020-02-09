#!/bin/zsh

# AUTHOR:   (c) Rob W 2012, modified by MHC (http://askubuntu.com/users/81372/mhc), modified by Robobenklein (2018-2020)
# NAME:     GIFRecord 0.1
# DESCRIPTION:  A script to record GIF screencasts.
# LICENSE:  GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)
# DEPENDENCIES:   byzanz,gdialog,notify-send (install via sudo add-apt-repository ppa:fossfreedom/byzanz; sudo apt-get update && sudo apt-get install byzanz gdialog notify-osd)

# Time and date
TIME=$(date +"%Y-%m-%d_%H%M%S")

# Delay before starting
DELAY=10

# Standard screencast folder
FOLDER="/tmp/gif-recordings"
mkdir -p /tmp/gif-recordings

# Default recording duration
DEFDUR=10

# Sound notification to let one know when recording is about to start (and ends)
beep() {
  paplay /usr/share/sounds/freedesktop/stereo/window-attention.oga &
}

# Custom recording duration as set by user
USERDUR=$(gdialog --title "Duration?" --inputbox "Please enter the screencast duration in seconds" 200 100 2>&1)

# Duration and output file
if (( USERDUR > 0 )); then
  D=$USERDUR
else
  D=$DEFDUR
fi

# Region geometry
slop=$(slop -f "%x %y %w %h %g %i") || exit 1
read -r X Y W H G ID < <(echo $slop)

# Notify the user of recording time and delay
notify-send "GIFRecorder" "Recording duration set to $D seconds. Recording will start in $DELAY seconds."

#Actual recording
while (( DELAY > 0 )); do echo $DELAY ...; sleep 1; (( DELAY-- )); done
beep
byzanz-record -c --verbose --delay=0 --duration=$D --x=$X --y=$Y --width=$W --height=$H "$FOLDER/GIFrecord_$TIME.gif"
beep

# Notify the user of end of recording.
notify-send "GIFRecorder" "Screencast saved to $FOLDER/GIFrecord_$TIME.gif"

