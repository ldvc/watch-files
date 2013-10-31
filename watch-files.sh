#!/bin/bash

# Largement inspiré de : http://info.figarola.fr/2009/11/06/linux-shell-gerer-les-evenements-inotify/
# Ludovic Terrier

# vim: set fileencoding=utf-8 sw=4 ts=4 et :
# Pré-requis
###  sudo aptitude install inotify-tools

self=$(hostname)
DIR_TO_WATCH=${1}

if [ $# -ne 1 ] ; then
	echo -e "Please specify directory to monitor!"
	echo "usage: $0 [DIR TO WATCH]"
	exit 0
else echo "Starting watching files in $DIR_TO_WATCH"
fi

inotifywait -q -m -r --exclude ".*CVS.*" \
            --format "%e|%w%f" $DIR_TO_WATCH \
| while read res
	do
	event=`echo $res | sed s/\|.*$//`
	src=`echo $res | sed s/^.*\|//`
	modifiedDir=`dirname $src`
	
	case "$event" in
	CREATE)
		# Traitement sur création d'un fichier
		# echo `basename $drc`
		;;
	CLOSE_WRITE,CLOSE)
		# Fin d'écriture
		newFile=`basename $src`
		if [ `echo $newFile | egrep -c "\.avi|\.mkv"` -eq "1" ] ; then
			echo $newFile >> /tmp/new-files.log
			# prepare to send email
			# to be done
		fi
		;;
	MOVED_TO)
		# Traitement sur déplacement d'un fichier
		# echo "MOVE DETECTED on $modifiedDir"
		;;
	esac
done

