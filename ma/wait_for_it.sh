#!/bin/bash

echo "Waiting for cassandra on $CASSANDRA_HOSTNAME:$CASSANDRA_PORT..."
result=1
while [ $result -ne "0" ]
do
  nmap -Pn -p$CASSANDRA_PORT $CASSANDRA_HOSTNAME | awk "\$1 ~ /$CASSANDRA_PORT/ {print \$2}" | grep open
  result=$?
  sleep 10
done
echo "Cassandra is ready!"

exec "$@"
