#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/config.sh"
target_file=/usr/local/bin/subtitle_normalize

if [ -e "$INSTALL_DIR" ]
then
	rm -rf $INSTALL_DIR
fi

mkdir $INSTALL_DIR
mkdir "$INSTALL_DIR/lib"

cp "$DIR/lib/* '$INSTALL_DIR/lib'"
cp "$DIR/subtitle_normalize '$INSTALL_DIR'"

if [ -e "$target_file" ]
then
	rm $target_file
fi

ln $INSTALL_DIR/subtitle_normalize $target_file
chmod +x $target_file

sh setup.sh $1