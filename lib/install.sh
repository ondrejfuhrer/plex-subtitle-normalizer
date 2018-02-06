#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/config.sh"

# remove installation dir if exists
if [ -e "$INSTALL_DIR" ]
then
	rm -rf $INSTALL_DIR
fi

# create installation directories
mkdir "$INSTALL_DIR"
mkdir "$INSTALL_DIR/lib"

# copy the lib folder to 
cp -R "$DIR" "$INSTALL_DIR"
cp "$DIR/../bin/subtitle_normalize" "$INSTALL_DIR"

# remove existing symlink if exists
if [ -e "$BIN_FILE" ]
then
	rm $BIN_FILE
fi

# create new symlink
ln -s $INSTALL_DIR/subtitle_normalize $BIN_FILE

# run setup
sh $DIR/setup.sh $1