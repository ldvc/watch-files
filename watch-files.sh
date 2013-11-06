#!/bin/bash

############################################
#
# watch-files.sh - Brief script to keep track of created files in specified directory.
# Largement inspiré de : http://info.figarola.fr/2009/11/06/linux-shell-gerer-les-evenements-inotify/
#
# Ludovic Terrier
#
############################################

# vim: set fileencoding=utf-8 sw=4 ts=4
# Pre-requisite
###  sudo aptitude install inotify-tools

self=$(hostname)
CONF_FILE="/etc/watch-files.conf"
LOG_DIR="/var/log/watch-files"
LOG_NEW_FILES="$LOG_DIR/new-files.log"
LOG_RUN=`awk '{ if ($1 == "LOG_RUN") print $3 }' $CONF_FILE`

# find a better way to manage it
if [ "$UID" -ne 0 ] ; then
	echo "Please run as root."
	exit 1
fi

# ensure inotify-tools is installed
if [ ! -x /usr/bin/inotifywait ] ; then 
	echo "Please install inotify-tools in order to execute"
	exit 2
fi

# create running log if not exists
if [ ! -f $LOG_RUN ] || [ ! -f $LOG_NEW_FILES ] ; then
	mkdir -p $LOG_DIR
	touch $LOG_NEW_FILES && touch $LOG_RUN
fi

# ensure $LOG_RUN is purged at each new run (as it will be read later)
# find a way to do better
echo "" > $LOG_NEW_FILES

if [ -f $CONF_FILE ] ; then
	# echo "General config file found !"
	DIR_TO_WATCH=`awk '{ if ($1 == "DIR_TO_WATCH") print $3 }' $CONF_FILE`
else 
	echo -e "No general config file found. Will use user value.\n"

	if [ $# -ne 1 ] ; then
		echo -e "Please specify directory to monitor!"
		echo "usage: $0 [DIR TO WATCH]"
		exit 3
	else 
		DIR_TO_WATCH=${1}
		echo "Starting watching files in $DIR_TO_WATCH"
	fi
fi

# need one arg : dir to watch

# start watching
inotifywait -q -d -o $LOG_RUN -r --exclude ".*CVS.*" \
            --format "%e|%w%f" $DIR_TO_WATCH

#while read RES
#	do
#	EVENT=`echo $RES | sed s/\|.*$//`
#	SRC=`echo $RES | sed s/^.*\|//`
#	MODIFIED_DIR=`dirname $SRC`
#
#	# debug
#	echo $EVENT >> /tmp/debug-watch.log
#	
#	# action depending on filesystem operation type
#	case "$EVENT" in
#	CREATE)
#		# action when new file had been created
#		;;
#	CLOSE_WRITE,CLOSE)
#		# action when file had been written
#		NEW_FILE=`basename $SRC`
#		echo $NEW_FILE >> /tmp/debug-watch.log
#		if [ `echo $NEW_FILE | egrep -c "\.avi|\.mkv"` -eq "1" ] ; then
#			echo $NEW_FILE >> ${LOG_NEW_FILES}
#			# prepare to send email
#			# to be done
#		fi
#		;;
#	MOVED_TO)
#		# action when file/dir had been moved
#		# echo "MOVE DETECTED on $MODIFIER_DIR"
#		;;
#	esac
#done < $LOG_RUN
