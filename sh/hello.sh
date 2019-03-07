#!/bin/sh
name=${1:-World};
ip=`ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
while true; do echo -e "HTTP/1.1 200 OK\n\nHello ${name} ! Welcome to OpenShift 3 from ${HOSTNAME}:${ip}" | nc -ll -p 8080; done
