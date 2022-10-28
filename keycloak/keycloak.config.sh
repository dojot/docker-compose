#!/bin/sh

set -eu -o pipefail

KEYCLOAK_HOST=${KEYCLOAK_HOST:-"http://keycloak:8080/auth"}
KEYCLOAK_MASTER_USER=${KEYCLOAK_MASTER_USER:-"master"}
KEYCLOAK_MASTER_PASSWORD=${KEYCLOAK_MASTER_PASSWORD:-"master"}

KEYCLOAK_PROXY_CLIENT_ID=${KEYCLOAK_PROXY_CLIENT_ID:-"keycloak-proxy"}
KEYCLOAK_PROXY_CLIENT_SECRET=$(cat ../secrets/${KEYCLOAK_PROXY_SECRET_FILE:-"KEYCLOAK_PROXY"})
KEYCLOAK_PROXY_USER=${KEYCLOAK_PROXY_USER:-"user-keycloak-proxy"}
KEYCLOAK_PROXY_USER_SECRET=$(cat ../secrets/${KEYCLOAK_PROXY_PASSWORD_FILE:-"KEYCLOAK_PROXY_USER"})

CERT_SUPPORT_CLIENT_ID=${CERT_SUPPORT_CLIENT_ID:-"dojot-cert-support"}
CERT_SUPPORT_CLIENT_SECRET=$(cat ../secrets/${CERT_SUPPORT_CLIENT_SECRET_FILE:-"dojot-cert-support"})

DOJOT_DOMAIN_NAME=$(grep DOJOT_DOMAIN_NAME /opt/env | awk -F"=" '{print $2}')

echo KEYCLOAK_HOST=$KEYCLOAK_HOST
echo KEYCLOAK_MASTER_USER=$KEYCLOAK_MASTER_USER
echo KEYCLOAK_PROXY_CLIENT_ID=${KEYCLOAK_PROXY_CLIENT_ID}
echo KEYCLOAK_PROXY_USER=${KEYCLOAK_PROXY_USER}
echo CERT_SUPPORT_CLIENT_ID=${CERT_SUPPORT_CLIENT_ID}
echo DOJOT_DOMAIN_NAME=${DOJOT_DOMAIN_NAME}

# check if Keycloak is started
if curl --output /dev/null --silent --head --fail "$KEYCLOAK_HOST"; then
  echo "Keycloak is started."
else
  echo "Keycloak isn't started."
  echo "Terminating in 20s..."
  sleep 20
  exit 1
fi

JWT=''

getToken() {
  echo 'Obtaining access token...'

  JWT=$(curl -sS -X POST "${KEYCLOAK_HOST}/realms/master/protocol/openid-connect/token" \
        --data-urlencode "username=${KEYCLOAK_MASTER_USER}" \
        --data-urlencode "password=${KEYCLOAK_MASTER_PASSWORD}" \
        --data-urlencode "client_id=admin-cli" \
        --data-urlencode "grant_type=password" 2> /dev/null \
    | jq -j '.access_token')

  echo ${JWT} 

  if [ -z "${JWT}" ]; then
    echo 'Failed to get access token!'
    exit 1
  else
    echo 'Obtained access token!'
  fi
}

createKeycloakProxyClient() {
  echo "Creatting Client in realm master..."
    curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/clients" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
    -d "{
          \"enabled\":true,
          \"attributes\":{},
          \"redirectUris\":[],
          \"clientId\":\"keycloak-proxy\",
          \"rootUrl\":\"http://${DOJOT_DOMAIN_NAME}:8000/\",
          \"protocol\":\"openid-connect\",
          \"publicClient\":false,
          \"secret\":\"${KEYCLOAK_PROXY_CLIENT_SECRET}\",
          \"authorizationServicesEnabled\":true,
          \"serviceAccountsEnabled\":true
        }"

  echo "...finished client in realm create."
}

createKeycloakProxyUser() {
  echo "Creatting User in realm master..."
    curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/users" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
    -d "{
          \"username\": \"${KEYCLOAK_PROXY_USER}\",
          \"enabled\": true,
          \"credentials\": [{
              \"id\": \"786e2a76-324c-4b05-91a9-a12ce79ac8ec\",
              \"type\": \"password\",
              \"value\": \"${KEYCLOAK_PROXY_USER_SECRET}\",
              \"temporary\": false
          }],
          \"realmRoles\": [
              \"default-roles-master\",
              \"admin\"
          ]
      }" 
  
  ADMIN_ROLE=$(curl -X GET "${KEYCLOAK_HOST}/admin/realms/master/roles" \
      -H "Content-Type:application/json" \
      -H "Authorization: Bearer ${JWT}" \
    | jq  -c '.[] | select(.name | contains("admin"))')
  echo ${ADMIN_ROLE}

  KEYCLOAK_PROXY_USER_ID=$(curl -X GET "${KEYCLOAK_HOST}/admin/realms/master/users" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
  | jq  -c -j '.[] | select(.username | contains("user-keycloak-proxy")).id')
  echo ${KEYCLOAK_PROXY_USER_ID}

  curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/users/${KEYCLOAK_PROXY_USER_ID}/role-mappings/realm" \
      -H "Content-Type:application/json" \
      -H "Authorization: Bearer ${JWT}" \
    -d "[${ADMIN_ROLE}]"

  echo "...finished user create."
}

createCertSupportClient() {
  echo "Creatting Client in realm master..."
  curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/clients" \
  -H "Content-Type:application/json" \
  -H "Authorization: Bearer ${JWT}" \
  -d "{
        \"enabled\":true,
        \"attributes\":{},
        \"redirectUris\":[],
        \"clientId\":\"${CERT_SUPPORT_CLIENT_ID}\",
        \"rootUrl\":\"http://${DOJOT_DOMAIN_NAME}:8000/\",
        \"protocol\":\"openid-connect\",
        \"publicClient\":false,
        \"secret\":\"${CERT_SUPPORT_CLIENT_SECRET}\",
        \"authorizationServicesEnabled\":true,
        \"serviceAccountsEnabled\":true
      }"

  echo "...finished client in realm create."
}

getToken
createKeycloakProxyClient
createKeycloakProxyUser
createCertSupportClient