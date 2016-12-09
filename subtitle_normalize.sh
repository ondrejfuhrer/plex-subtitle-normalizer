#!/bin/bash
OIFS="$IFS"
IFS=$'\n'

. lib/log.sh
. lib/config.sh

load_config

for directory in `find $config_library_root -type d`
do
	__log "Folder: $directory" $LOG_DEBUG
	
	if [ "$config_library_root" == "$directory" ];
	then
		__log 'Skipping root directory' $LOG_DEBUG
		__log '' $LOG_DEBUG
		continue;
	fi
	
	if [[ $directory == *"$config_backup_directory_name" ]]
	then 
		__log "Skipping backup directory" $LOG_DEBUG
		__log '' $LOG_DEBUG
		continue
	fi
	
	for file in `find $directory -type f -name "*.*"`
	do
		__log "Testing file: $file" $LOG_DEBUG
		extension=${file##*.}
		if [ "srt" == "$extension" ];
		then
			file_to_rename="$file"
			from_charset=$(enca -L czech -i $file)
			subtitle_extension="$extension"
			__log "File set to rename" $LOG_DEBUG
		else
			base_name="${file%.*}"
			__log "Used for base file name" $LOG_DEBUG
		fi
	done
	
	if [ -e "$file_to_rename" ]
	then
		new_filename="$base_name.$config_subtitle_lang.$subtitle_extension"
		if [ "UTF-8" == $from_charset ]
		then
			__log "Subtitle already in UTF-8, skipping iconv" $LOG_DEBUG
			cp $file_to_rename $new_filename
		else 
			__log "Changing encoding for the subtitle file from $from_charset" $LOG_DEBUG
			iconv -f windows-1250 -t utf-8 < $file_to_rename > $new_filename
		fi
		__log "New file: $new_filename from $file_to_rename"
	else
		__log "$directory: No subtitle file found for normalizing"
	fi
	__log '' $LOG_DEBUG
done
IFS="$OIFS"
