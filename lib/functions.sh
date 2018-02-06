#!/bin/bash
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