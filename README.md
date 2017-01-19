# Plex Subtitle Normalizer
Simple bash script for normalizing subtitles for usage in Plex Media Server

# Requirements
Currently tested only on Mac OS.

This script requires [enca](https://github.com/nijel/enca) command available on your machine (for encoding detection)

Install enca using brew
```
brew install enca
```
# Installation
There is an install script included, for installation just type following command
```
sh install.sh
```

## Library root
You will be promped to insert your library root. This directory will be used for the subtitle search. There is also an option to set the library root during the installation, just pass it as an argument to the installation script.
```
sh install.sh /Users/current_user/Movies/
```

In that case you will not be promped for the library root.

## Encoding
Currently the encoding for the enca command is set to `czech` during the installation. If you want to change it, you need to update your setting file after installation. Please note that after every installation run you need to update it again.

Your setting file location will be:
```
/Users/current_user/.plex_subtitle_normalizer/.settings
```
