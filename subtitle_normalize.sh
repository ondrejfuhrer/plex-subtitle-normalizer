#!/bin/bash
OIFS="$IFS"
IFS=$'\n'

if [ ! -e './.settings' ]
then
	echo 'Settings not found, please run install.sh.'
	exit
fi

parse_settings() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(parse_settings '.settings' 'setting_')

LOG_DEBUG=1
LOG_INFO=2
LOG_WARNING=3
LOG_ERROR=4

__log()
{
	LEVEL=${2:-2}
	
	if [ "$LEVEL" -lt "$setting_log_level" ]
	then
		return
	fi
	
	if [ -z "$1" ]
	then
		echo ""
		return
	fi
	
	case "$LEVEL" in
		1)
			echo "[DEBUG] $1"
			;;
		2)
			echo "[INFO] $1"
			;;
		3)
			echo "[WARNING] $1"
			;;
		4)
			echo "[ERROR] $1"
			;;
		*)
			;;
	esac
}

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
		#iconv -f windows-1250 -t utf-8 < $file_to_rename > $new_filename
		__log "Created new subtitle file: $new_filename"
	else
		__log "No subtitle file found for normalising"
	fi
	__log '' $LOG_DEBUG
done
IFS="$OIFS"