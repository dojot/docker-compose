#!/bin/sh

redis-server &
sleep 5
cat /usr/local/etc/redis/redis.conf | redis-cli

/usr/local/bin/redis-sentinel /usr/local/etc/redis/sentinel.conf
wait
