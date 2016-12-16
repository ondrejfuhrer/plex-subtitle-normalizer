#!/bin/bash
OIFS="$IFS"
IFS=$'\n'

. lib/log.sh
. lib/config.sh

load_config

if [ "revert" == "$1" ]
then
	__log 'Reverting changes' $LOG_INFO
	find $config_library_root -type f -name "*.$config_subtitle_lang.???" -exec rm {} \;
	for bck_file in `find $config_library_root -type f -name "*.bck"`
	do
		length=${#bck_file}-4
		target=${bck_file:0:$length}
		mv $bck_file $target
	done
	exit
fi

function lookup_subtitle_file_details()
{
	file_to_rename=''
	from_charset=''
	base_name=''
	
	for file in `find $1 -type f -name "*.*"`
	do
		__log "Testing file: $file"
		local extension=${file##*.}
		if [ "srt" == "$extension" ];
		then
			file_to_rename="$file"
			from_charset=$(enca -L $config_enca_lang -i $file)
			subtitle_extension="$extension"
			__log "File set to rename"
		else
			base_name="${file%.*}"
			__log "Used for base file name"
		fi
	done
}

function load_directories()
{
	for directory in `find $config_library_root -type d`
	do
		directories=( "${directories[@]}" "$directory" )
	done
}

load_directories

for directory in "${directories[@]}"
do
	__log "Folder: $directory"
	
	if [ "$config_library_root" == "$directory" ];
	then
		__log 'Skipping root directory'
		__log ''
		continue;
	fi
	
	if [[ $directory == *"$config_backup_directory_name" ]]
	then 
		__log "Skipping backup directory"
		__log ''
		continue
	fi
	
	lookup_subtitle_file_details $directory
	
	if [ -e "$file_to_rename" ]
	then
		new_filename="$base_name.$config_subtitle_lang.$subtitle_extension"
		if [ -e "$new_filename" ]
		then
			__log "File already exists, skipping"
			continue
		fi
		if [ "UTF-8" == $from_charset ]
		then
			__log "Subtitle already in UTF-8, skipping iconv"
			cp $file_to_rename $new_filename
		else 
			__log "Changing encoding for the subtitle file from $from_charset"
			iconv -f $from_charset -t utf-8 < $file_to_rename > $new_filename
		fi
		__log "New file: $new_filename from $file_to_rename" $LOG_INFO
		mv "$file_to_rename" "$file_to_rename.bck"
	else
		__log "$directory: No subtitle file found for normalizing"
	fi
	__log ''
done
IFS="$OIFS"
