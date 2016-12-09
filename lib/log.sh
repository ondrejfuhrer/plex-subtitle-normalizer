#!/bin/bash
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
