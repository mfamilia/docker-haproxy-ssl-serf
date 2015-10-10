#!/bin/bash

# event handler script for adding Nginx servers to load-balancer
while read line
do
	ROLE=`echo $line | awk '{ print $3 }'`
	if [ "x${ROLE}" != "xweb" ]
		then
			continue
	fi
	echo $line | awk '{ printf "\tserver %s %s:80 check cookie %s\n", $1, $2, $1 }' >> /etc/haproxy/haproxy.cfg
done

# reload HAProxy configuration
HAPROXY_WRAPPER=$(cat /etc/service/haproxy/supervise/pid)
kill -USR2 $HAPROXY_WRAPPER
