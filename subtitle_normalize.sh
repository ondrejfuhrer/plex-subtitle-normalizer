#!/bin/bash
OIFS="$IFS"
IFS=$'\n'

for directory in `find . -type d`
	do
		echo "Folder: $directory"
	
	if [ "." == "$directory" ];
	then
		echo 'Skipping root directory'
		continue;
	fi
	
	for file in `find $directory -type f -name "*.*"`
	do
		extension=${file##*.}
		if [ "srt" == "$extension" ];
		then
			file_to_rename="$file"
		else
			base_name="${file%.*}"
		fi
	done
	
	if [ -e "$file_to_rename" ]
	then
		new_filename="$base_name.cze.srt"
		iconv -f windows-1250 -t utf-8 < $file_to_rename > $new_filename
	fi
done
IFS="$OIFS"