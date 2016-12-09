#!/bin/bash
TARGET_FILE=/usr/local/bin/subtitle_normalize
if [ ! -e "$TARGET_FILE" ]
then
	ln ./subtitle_normalize.sh "$TARGET_FILE"
fi

chmod +x "$TARGET_FILE"

sh setup.sh