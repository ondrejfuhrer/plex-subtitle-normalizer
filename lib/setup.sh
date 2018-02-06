#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/config.sh"

# remove old config file if exists
if [ -e "$CONFIG_FILE" ]
then
	rm "$CONFIG_FILE"
fi

# ask for a library root if was not provided as a command argument
if [[ -z "${1// }" ]]
then
	read -p "Please enter your library directory (used as root directory for scanning): " d
else
	d=$1
fi

# write all values inside the config file
echo "library_root: $d" > "$CONFIG_FILE"
echo "log_level: 2" >> "$CONFIG_FILE"
echo "subtitle_lang: cze" >> "$CONFIG_FILE"
echo "enca_lang: czech" >> "$CONFIG_FILE"
echo "debug: 0" >> "$CONFIG_FILE"