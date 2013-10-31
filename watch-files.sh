#!/bin/bash

############################################
#
# watch-files.sh - Brief script to keep track of created files in specified directory.
# Largement inspiré de : http://info.figarola.fr/2009/11/06/linux-shell-gerer-les-evenements-inotify/
# Ludovic Terrier
#
############################################

# vim: set fileencoding=utf-8 sw=4 ts=4
# Pre-requisite
###  sudo aptitude install inotify-tools

self=$(hostname)
DIR_TO_WATCH=${1}
FILE_TO_LOG="/tmp/new-files.log"

# ensure inotify-tools is installed
if [ ! -x /usr/bin/inotifywait ] ; then 
	echo "Please install inotify-tools in order to execute"
	exit 0
fi

# need one arg, dir to watch
if [ $# -ne 1 ] ; then
	echo -e "Please specify directory to monitor!"
	echo "usage: $0 [DIR TO WATCH]"
	exit 0
else echo "Starting watching files in $DIR_TO_WATCH"
fi

# start watching
inotifywait -q -m -r --exclude ".*CVS.*" \
            --format "%e|%w%f" $DIR_TO_WATCH \
| while read res
	do
	event=`echo $res | sed s/\|.*$//`
	src=`echo $res | sed s/^.*\|//`
	modifiedDir=`dirname $src`
	
	# action depending on filesystem operation type
	case "$event" in
	CREATE)
		# action when new file had been created
		;;
	CLOSE_WRITE,CLOSE)
		# action when file had been written
		newFile=`basename $src`
		if [ `echo $newFile | egrep -c "\.avi|\.mkv"` -eq "1" ] ; then
			echo $newFile >> ${FILE_TO_LOG}
			# prepare to send email
			# to be done
		fi
		;;
	MOVED_TO)
		# action when file/dir had been moved
		# echo "MOVE DETECTED on $modifiedDir"
		;;
	esac
done
