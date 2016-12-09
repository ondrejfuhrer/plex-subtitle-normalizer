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

for directory in `find $setting_library_root -type d`
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