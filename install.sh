#!/bin/bash
TARGET_FILE=/usr/local/bin/subtitle_normalize
if [ ! -e "$TARGET_FILE" ]
then
	ln ./subtitle_normalize.sh "$TARGET_FILE"
fi

chmod +x "$TARGET_FILE"

SETTINGS_FILE=".settings"
if [ ! -e "$SETTINGS_FILE" ]
then
	read -p "Please enter your library directory (script cannot be used outside): " d
	echo "library_root: $d" > "$SETTINGS_FILE"
fi