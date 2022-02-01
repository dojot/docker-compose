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
if [ ! -s secrets/KEYCLOAK_PROXY ]; then
  openssl passwd -5 $(uname -n)$(date +%F%H%M%S)KEYCLOAK_PROXY > secrets/KEYCLOAK_PROXY
fi

if [ ! -s secrets/KEYCLOAK_PROXY_USER ]; then
  openssl passwd -5 $(uname -n)$(date +%F%H%M%S)KEYCLOAK_PROXY_USER > secrets/KEYCLOAK_PROXY_USER
fi

###########################################################
# Secrets clients keycloak 
#
# The create secrets using to json do Realm Representation 
###########################################################

# Install JQ
apt-get install jq -y

for NAME in $(jq ".clients[].clientId" /opt/dojot/customRealmRepresentation.json |  grep 'dojot' | sed "s/\"/ /g" )
do
    if [ ! -s secrets/${NAME} ]; then
        openssl passwd -5 $(uname -n)$(date +%F%H%M%S)${NAME} > secrets/${NAME}
    fi
done 

# Valida criação secret
if [ ! -s secrets/KEYCLOAK_PROXY ] || [ ! -s secrets/KEYCLOAK_PROXY_USER ]; then
  exit 1
fi