#!/bin/bash
TARGET_FILE=/usr/local/bin/subtitle_normalize
if [ ! -e "$TARGET_FILE" ]
then
	ln ./subtitle_normalize.sh "$TARGET_FILE"
fi

chmod +x "$TARGET_FILE"

SETTINGS_FILE=".settings"
if [ -e "$SETTINGS_FILE" ]
then
	rm "$SETTINGS_FILE"
fi

read -p "Please enter your library directory (used as root directory for scanning): " d
echo "library_root: $d" > "$SETTINGS_FILE"
echo "log_level: 2" >> "$SETTINGS_FILE"
echo 'backup_directory_name: "_Subtitles"' >> "$SETTINGS_FILE"