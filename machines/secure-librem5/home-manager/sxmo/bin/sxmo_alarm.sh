#!/bin/sh
# title="$icon_clk Alarm/Timer"
# Description: Alarm/Timer/Stopwatch
# Author: magdesign
# Notes: v0.1.8

# check for dependencies
if ! command -v at >/dev/null 2>&1; then
	notify-send "Error: no at installed." "read: pmos magdesign wiki"
# https://wiki.postmarketos.org/wiki/User:Magdesign#Alarm_Clock
	exit 1
fi

warnings(){
if [ ! -e "/usr/share/sxmo/notify.ogg" ]; then
	notify-send "Error: /usr/share/sxmo/notify.ogg" "does not exist!"
fi

if [ ! -e "$XDG_CACHE_HOME/sxmo/sxmo.nosuspend" ]; then
	notify-send -u critical "Disable Auto-Suspend!" "in menu"
fi

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | cut -d'/' -f2 | sed 's/ //g' | sed 's/\%//')

if [ "$VOLUME" -lt 50 ]; then
	notify-send -u critical "Volume is low!" "its only $VOLUME %"	
fi
}

menu() {
		NALARMS="$(atq | wc -l)"
		MENUINPUT="$(sxmo_dmenu.sh -p "Select" <<EOF
Alarm
Countdown
Stopwatch

Show Alarms ($NALARMS)
Delete All

Exit
EOF
	)" || exit
	case "$MENUINPUT" in
		"Alarm")
			enteralarmtime
			setalarm
			validate
			exit 0
			;;
		"Countdown")
			entertime
			convert_to_minutes
			settimer
			validate
			exit 0
			;;
		"Stopwatch")
			notify-send -w -t 99999 -u critical "click me" "to Start"
			sxmo_terminal.sh --font=sxmo:size=20 "$0" 'stopwatch'
			;;
		"Show Alarms ($NALARMS)")
			validate
			menu
			;;
		"Delete All")
			deleteall
			validate
			exit 0
			;;
		"Abort")
			exit 0
			;;
		*)
			# wrong/no input
			echo "no selection"
			;;
	esac
}

stopwatch() {
	# Start time in seconds & milliseconds
	start_time=$(date +%s%3N)

	while true; do
		# Get the current time in seconds and milliseconds
		current_time=$(date +%s%3N)
		# Calculate the elapsed time in milliseconds
		milliseconds_elapsed=$(expr $current_time - $start_time)
		# Calculate seconds, minutes, hours, and days from milliseconds
		seconds_elapsed=$(expr $milliseconds_elapsed / 1000)
		milliseconds=$(expr $milliseconds_elapsed % 1000)
		# Convert seconds into days, hours, minutes, and remaining seconds
		day=$(expr $seconds_elapsed / 86400)
		hour=$(expr \( $seconds_elapsed % 86400 \) / 3600)
		minute=$(expr \( $seconds_elapsed % 3600 \) / 60)
		second=$(expr $seconds_elapsed % 60)
		# Print the formatted time including milliseconds
		printf "\r%02d:%02d:%02d.%03d" $hour $minute $second $milliseconds
		# Higher value to save CPU, lower to get precision
		sleep 0.01
	done
}

entertime(){
	options="\nAbort"
	while true; do
		timevalue=$(echo -e "$options" | sxmo_dmenu.sh -p "Enter hh:mm or mm")    
		case "$timevalue" in
			"Abort")
				exit 0
				;;
			*)
				# Check if input is in mm format (e.g., 130)
				if [[ "$timevalue" =~ ^[0-9]+$ ]]; then
					total_minutes=$timevalue
					if [ "$total_minutes" -ge 0 ]; then
						break
					else
						notify-send -u critical "Error. Enter a valid number of minutes."
					fi
				# Validate input in hh:mm format
				elif [[ "$timevalue" =~ ^[0-9]{1,2}:[0-9]{2}$ ]]; then
					hour=$(echo "$timevalue" | cut -d: -f1)
					minute=$(echo "$timevalue" | cut -d: -f2)
					if [ "$hour" -ge 0 ] && [ "$hour" -le 23 ] && [ "$minute" -ge 0 ] && [ "$minute" -le 59 ]; then
						break 
					else
						notify-send -u critical "Error. Enter time in hh:mm format."
					fi
				else
					notify-send -u critical "Error. Enter time in hh:mm or mm format."
				fi
				;;
		esac
	done
}

enteralarmtime(){
	options="\nAbort"
	while true; do
		timevalue=$(echo -e "$options" | sxmo_dmenu.sh -p "Enter hh:mm")
		case "$timevalue" in
			"Abort")
			exit 0
			;;
			*)
				hour=$(echo "$timevalue" | cut -d: -f1)
				minute=$(echo "$timevalue" | cut -d: -f2)
				if [ "$hour" -ge 0 ] && [ "$hour" -le 23 ] && [ "$minute" -ge 0 ] && [ "$minute" -le 59 ]; then
					#echo "Valid time entered"
					break 
				else
					notify-send -u critical "Error. Enter time in hh:mm format."
				fi
				;;
		esac
	done
}

convert_to_minutes() {
	if [[ "$1" == *":"* ]]; then
		hour=$(echo "$1" | cut -d: -f1)
		minute=$(echo "$1" | cut -d: -f2)
		total_minutes=$(( hour * 60 + minute ))
	else
		total_minutes=$1
	fi
	echo "$total_minutes"
}

setalarm(){
	doas rc-service atd start
	echo "mpv --loop /usr/share/sxmo/notify.ogg & sxmo_vibrate 1000 20000 & notify-send -t 9999999 -w -u critical '(▀̿Ĺ̯▀̿ ̿)' 'ALARM' && { pkill -f 'mpv --loop /usr/share/sxmo/notify.ogg'; pkill 'sxmo_vibrate.sh'; }" | at "$timevalue"
	warnings
}


settimer() {
	total_minutes=$(convert_to_minutes "$timevalue")
	doas rc-service atd start
	echo "mpv --loop /usr/share/sxmo/notify.ogg & sxmo_vibrate 1000 20000 & notify-send -t 9999999 -w -u critical '(▀̿Ĺ̯▀̿ ̿)' 'ALARM' && { pkill -f 'mpv --loop /usr/share/sxmo/notify.ogg'; pkill 'sxmo_vibrate.sh'; }" | at now + "$total_minutes" minutes
	warnings
}


settimer


validate(){
	# show jobs without username
	notify-send "Pending Alarms" "$(atq | awk '{print $2, $3, $4, $5, $6 }' | cut -d: -f1,2)"
#	notify-send "Pending Jobs" "$(atq | awk '{$NF=""; print $0}' | sed 's/[[:space:]]+$//')"
}

deleteall(){
	#to do: list all jobs and select the ones to delete
	atrm $(atq | awk '{print $1}')	
	doas rc-service atd stop
}

if [ $# -gt 0 ]
then
	"$@"
else
	menu
fi
