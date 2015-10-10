#!/bin/bash

# event handler script for removing Nginx servers from load-balancer
while read line
do
	ROLE=`echo $line | awk '{ print $3 }'`
	if [ "x${ROLE}" != "xweb" ]
		then
			continue
	fi

	NAME=$(echo $line | awk '{ print $1 }')
	echo $line >> /tmp/serf_leaves
	sed -i "/${NAME} /d" /etc/haproxy/haproxy.cfg
done

# reload HAProxy configuration
HAPROXY_WRAPPER=$(cat /etc/service/haproxy/supervise/pid)
kill -USR2 $HAPROXY_WRAPPER
