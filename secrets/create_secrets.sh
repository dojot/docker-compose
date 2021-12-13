#!/bin/sh

##############################
# Secrets minio
##############################
if [ ! -s secrets/MINIO_SECRET_KEY ]; then
  openssl passwd -5 $(uname -n)$(date +%F%H%M%S)MINIO_SECRET_KEY > secrets/MINIO_SECRET_KEY
fi

if [ ! -s secrets/MINIO_ACCESS_KEY ]; then
  openssl passwd -5 $(uname -n)$(date +%F%H%M%S)MINIO_ACCESS_KEY > secrets/MINIO_ACCESS_KEY
fi

# Valida criação secret
if [ ! -s secrets/MINIO_SECRET_KEY ] || [ ! -s secrets/MINIO_ACCESS_KEY ]; then
  exit 1
fi

##############################
# Secrets keycloak proxy
##############################
if [ ! -s secrets/.KEYCLOAK_PROXY ]; then
  openssl passwd -5 $(uname -n)$(date +%F%H%M%S).KEYCLOAK_PROXY > secrets/.KEYCLOAK_PROXY
fi

# Valida criação secret
if [ ! -s secrets/.KEYCLOAK_PROXY ] || [ ! -s secrets/.KEYCLOAK_PROXY ]; then
  exit 1
fi