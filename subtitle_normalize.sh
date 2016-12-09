#!/bin/bash
OIFS="$IFS"
IFS=$'\n'

if [ ! -e './.settings' ]
then
	echo 'Settings not found, please run install.sh.'
	exit
fi

. lib/parse_settings.sh

eval $(parse_settings '.settings' 'setting_')

. lib/log.sh

for directory in `find $setting_library_root -type d`
do
	__log "Folder: $directory" $LOG_DEBUG
	
	if [ "." == "$directory" ];
	then
		__log 'Skipping root directory' $LOG_DEBUG
		__log '' $LOG_DEBUG
		continue;
	fi
	
	if [[ $directory == *"$setting_backup_directory_name" ]]
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
			__log "File set to rename" $LOG_DEBUG
		else
			base_name="${file%.*}"
			__log "Used for base file name" $LOG_DEBUG
		fi
	done
	
	if [ -e "$file_to_rename" ]
	then
		new_filename="$base_name.cze.srt"
		iconv -f windows-1250 -t utf-8 < $file_to_rename > $new_filename
		__log "Created new subtitle file: $new_filename"
	else
		__log "No subtitle file found for normalising"
	fi
	__log '' $LOG_DEBUG
done
IFS="$OIFS"