#!/bin/bash

PIDFILE=$PWD/pusher.pid
if [ -f "$PIDFILE" ]; then
	PID=$(cat $PIDFILE)
	ps -p $PID > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "websockets is already running"
		exit 1
	else
		echo $$ > $PIDFILE
		if [ $? -ne 0 ]; then
			echo "$(date +'%d %b %T -') Could not create PID file"
			exit 1
		fi
	fi
else
	echo $$ > $PIDFILE
	if [ "$?" -ne "0" ]; then
		echo "$(date +'%d %b %T -') could not create PID file"
		exit 1
	fi
fi

php bin/php-server.php
