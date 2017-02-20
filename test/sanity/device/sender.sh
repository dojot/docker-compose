#!/bin/bash


function send() {
  local msg=$(cat <<MSG
  {
    temperature: $1
  }
MSG
)

  mosquitto_pub -h $MQTT -t "/device/sample/attrs" -m "$msg"
}

i=0
while true ; do
  send i
  i=$((i + 1))
  sleep 1
done
