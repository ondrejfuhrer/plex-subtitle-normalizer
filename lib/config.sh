#!/bin/bash
INSTALL_DIR="/Users/$(whoami)/.plex_subtitle_normalizer"
CONFIG_FILE="$INSTALL_DIR/config.yml"
BIN_FILE=/usr/local/bin/subtitle_normalize

parse_config_file() {
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

check_config_exists()
{
	if [ ! -e "$CONFIG_FILE" ]
	then
		echo 'Config file not found, please run install.sh.'
		exit
	fi
}

load_config()
{
	check_config_exists
	eval $(parse_config_file "$CONFIG_FILE" 'config_')
}
