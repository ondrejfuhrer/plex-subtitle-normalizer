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

# Usage
After the installation you wil have following command available
```
subtitle_normalize
```

This will run the normalization procedure on your whole library. It will create a backup of all your current subtitles as `*.bck` file. The precondition is, that in the directory there needs to be just the media file and a subtitle file. When other files are involved, the result is not guaranteed.

Currently there are two other options available

```
subtitle_normalize info
```
This info argument will print a basic info about your library like:
```
Library informations
Library root: /Users/current_user/Movies/

[Media files]: 125
[Subtitles]: 122
[Missing subtitles]:
1: /Test/Serie 1
2: /Test/Serie 3
3: /Test/Serie 5/Serie 5 s01e03
```

Then there is a simple way of reverting the changes you made by the script.
**Important:** The revert command is designed right now just for a development purpose so the result is not guaranteed on your directory structure, so if you are not sure about that, do not run it.
```
subtitle_normalize revert
```