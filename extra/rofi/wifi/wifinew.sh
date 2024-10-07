#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='style-1'

bssid=$(nmcli device wifi list | sed -n '1!P' | cut -b 9- | rofi -dmenu -theme ${dir}/${theme}.rasi -p " " -lines 10 | awk '{print $1}')
[ -z "$bssid" ] && exit 1
pass=$(echo "" | rofi -dmenu -theme-str 'textbox-prompt-colon {str: "";}' -theme ${dir}/${theme}.rasi -p "Enter password")
[ -z "$pass" ] && notify-send "🔑 Password not entered" && exit 1
nmcli device wifi connect $bssid password $pass
notify-send "📶 New WiFi Connected"