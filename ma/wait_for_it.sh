#!/bin/bash

echo "Waiting for cassandra on $CASSANDRA_HOSTNAME:$CASSANDRA_PORT..."
result=1
while [ $result -ne "0" ]
do
  cqlsh $CASSANDRA_HOSTNAME $CASSANDRA_PORT -f /home/kerberos/cassandra.conf --cqlversion="3.4.4"
  result=$?
  sleep 10
done
echo "Cassandra is ready!"

exec "$@"
