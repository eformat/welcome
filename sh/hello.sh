#!/bin/sh
name=${1:-World};
ip=`ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
if [ -f /etc/ssl/certs/tls.crt ]; then 
  while true; do echo -e "HTTP/1.1 200 OK\n\nHello ${name} ! Welcome to OpenShift from ${HOSTNAME}:${ip}" | nc -ll --ssl-cert /etc/ssl/certs/tls.crt --ssl-key /etc/ssl/certs/tls.key -p 8443; done
else
  while true; do echo -e "HTTP/1.1 200 OK\n\nHello ${name} ! Welcome to OpenShift from ${HOSTNAME}:${ip}" | nc -ll -p 8080; done
fi
