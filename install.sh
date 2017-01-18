#!/bin/bash
. lib/config.sh
target_file=/usr/local/bin/subtitle_normalize

if [ -e "$INSTALL_DIR" ]
then
	rm -rf $INSTALL_DIR
fi

mkdir $INSTALL_DIR
mkdir "$INSTALL_DIR/lib"

cp ./lib/* "$INSTALL_DIR/lib"
cp ./subtitle_normalize.sh "$INSTALL_DIR"

if [ ! -e "$target_file" ]
then
	ln $install_dir/subtitle_normalize.sh $target_file
fi

chmod +x $target_file

sh setup.sh