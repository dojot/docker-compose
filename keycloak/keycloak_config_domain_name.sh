#! /bin/sh -x

#set -eu -o pipefail

DOJOT_DOMAIN_NAME=$(grep DOJOT_DOMAIN_NAME /opt/env | awk -F"=" '{print $2}')

echo DOJOT_DOMAIN_NAME=${DOJOT_DOMAIN_NAME}

sed "s/localhost/$DOJOT_DOMAIN_NAME/g" /opt/dojot/customRealmRepresentation.json > /opt/dojot/customRealmRepresentation.json.1
cp -f /opt/dojot/customRealmRepresentation.json.1 /opt/dojot/customRealmRepresentation.json