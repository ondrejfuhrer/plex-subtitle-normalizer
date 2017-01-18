#!/bin/bash
. lib/config.sh

if [ -e "$CONFIG_FILE" ]
then
	rm "$CONFIG_FILE"
fi

read -p "Please enter your library directory (used as root directory for scanning): " d
echo "library_root: $d" > "$CONFIG_FILE"
echo "log_level: 2" >> "$CONFIG_FILE"
echo "subtitle_lang: cze" >> "$CONFIG_FILE"
echo "enca_lang: czech" >> "$CONFIG_FILE"
echo "debug: 0" >> "$CONFIG_FILE"