#!/bin/bash
OIFS="$IFS"
IFS=$'\n'
PLEX_NORM_APP_DIR="/Users/$(whoami)/.plex_subtitle_normalizer"

if [ ! -f "$PLEX_NORM_APP_DIR/lib/log.sh" ]
then
	echo 'App not installed properly. Please use `sh install.sh` from the download directory'
	exit
fi

source "$PLEX_NORM_APP_DIR"/lib/log.sh
source "$PLEX_NORM_APP_DIR"/lib/config.sh

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
	
	for file in `find $1 -type f -depth 1 -name "*.*"`
	do
		__log "Testing file: $file"
		local extension=${file##*.}
		if [ "srt" == "$extension" ];
		then
			file_to_rename="$file"
			from_charset=$(enca -L $config_enca_lang -i $file)
			subtitle_extension="$extension"
			__log "File set to rename"
		elif [ "bck" == "$extension" ]
		then
			__log "Skipping backup file" 
		elif [ "DS_Store" == "$extension" ]
		then
			__log "Skipping .DS_Store file"
		else
			base_name="${file%.*}"
			__log "Used for base file name"
		fi
	done
}

function load_directories()
{
	echo '('; 
	find "$1" -type d -exec stat -f '"%N"' {} \;; 
	echo ')';
}

if [ "info" == "$1" ]
then
	echo "Library informations"
	echo "Library root: $config_library_root"
	echo ''
else
	__log "Library root: $config_library_root" $LOG_INFO	
fi

declare -a directories=$(load_directories "$config_library_root")

stats_subtitles=0
stats_media=0
missing_subtitles=()

for directory in "${directories[@]}"
do
	__log ''
	__log "Folder: $directory"
	
	if [ "$config_library_root" == "$directory" ];
	then
		__log 'Skipping root directory'
		continue;
	fi
	
	lookup_subtitle_file_details $directory

	if [ "info" == "$1" ] 
	then
		if [ -e "$file_to_rename" ]
		then
			stats_subtitles=$[$stats_subtitles +1]
		fi

		if [[ -n "${base_name// }" ]]
		then
			stats_media=$[$stats_media +1]
			if [[ -z "${file_to_rename// }" ]]
			then
				missing_subtitles+=("$directory")
			fi
		fi

		continue
	fi
	
	if [ -e "$file_to_rename" ]
	then
		if [[ -z "${base_name// }" ]]
		then
			__log "No media file found, skipping"
			continue
		else
			__log "Base name: $base_name"
		fi
		new_filename="$base_name.$config_subtitle_lang.$subtitle_extension"
		if [ -e "$new_filename" ]
		then
			__log "File already exists, skipping"
			continue
		fi
		if [ "UTF-8" == $from_charset ]
		then
			__log "Subtitle already in UTF-8, skipping iconv"
			if [ "$config_debug" == "0" ]
			then
				cp $file_to_rename $new_filename
			fi
		else 
			__log "Changing encoding for the subtitle file from $from_charset"
			if [ "$config_debug" == "0" ]
			then
				iconv -f $from_charset -t utf-8 < $file_to_rename > $new_filename
			fi
		fi
		if [ "$config_debug" == "0" ]
		then
			mv "$file_to_rename" "$file_to_rename.bck"
		fi
		__log "New file: ${new_filename#$config_library_root} from ${file_to_rename#$config_library_root}" $LOG_INFO
	else
		__log "$directory: No subtitle file found for normalizing"
	fi
done

if [ "info" == "$1" ]
then
	echo "[Media files]: $stats_media"
	echo "[Subtitles]: $stats_subtitles"
	echo "[Missing subtitles]:"
	c=0
	for directory in "${missing_subtitles[@]}"
	do
		c=$[$c +1]
		echo "$c: ${directory#$config_library_root}"
	done
fi

if [ "$config_debug" == "1" ]
then
	__log "Running in DEBUG mode, no changes have been made to the files" $LOG_WARNING
fi

IFS="$OIFS"
