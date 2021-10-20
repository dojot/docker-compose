#!/bin/sh

##############################
# Secrets kafk-ws
##############################
if [ ! -s secrets/KAFKA_WS_TICKET_SECRET ]; then
  openssl passwd -5 `uname -n ``date +%F%H%M%S`KAFKA_WS_TICKET_SECRET > secrets/KAFKA_WS_TICKET_SECRET
fi

##############################
# Secrets minio
##############################
if [ ! -s secrets/MINIO_SECRET_KEY ]; then
  openssl passwd -5 `uname -n ``date +%F%H%M%S`MINIO_SECRET_KEY > secrets/MINIO_SECRET_KEY
fi

if [ ! -s secrets/MINIO_ACCESS_KEY ]; then
  openssl passwd -5 `uname -n ``date +%F%H%M%S`MINIO_ACCESS_KEY > secrets/MINIO_ACCESS_KEY
fi

##############################
# Secrets image-manager
##############################
if [ ! -s secrets/S3SECRETKEY ]; then
  openssl passwd -5 `uname -n ``date +%F%H%M%S`S3SECRETKEY > secrets/S3SECRETKEY
fi

if [ ! -s secrets/S3ACCESSKEY ]; then
  openssl passwd -5 `uname -n ``date +%F%H%M%S`S3ACCESSKEY > secrets/S3ACCESSKEY
fi