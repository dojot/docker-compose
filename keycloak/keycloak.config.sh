#!/bin/sh

set -eu -o pipefail

KEYCLOAK_HOST=${KEYCLOAK_HOST:-"http://keycloak:8080/auth"}
KEYCLOAK_CREATE_REALM=${KEYCLOAK_CREATE_REALM:-"admin"}
KEYCLOAK_MASTER_USER=${KEYCLOAK_MASTER_USER:-"admin"}
KEYCLOAK_MASTER_PASSWORD=${KEYCLOAK_MASTER_PASSWORD:-"admin"}

# KEYCLOAK_PROXY_CLIENT_ID=${KEYCLOAK_PROXY_CLIENT_ID:-"client-proxy"}
# KEYCLOAK_PROXY_CLIENT_SECRET=$(cat .KEYCLOAK_PROXY)
# KEYCLOAK_PROXY_USER=${KEYCLOAK_PROXY_USER:-"user-proxy"}
# KEYCLOAK_PROXY_USER_SECRET=$(cat .KEYCLOAK_PROXY)


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
        --data-urlencode "grant_type=password" 2>/dev/null \
    | jq -j '.access_token')

  if [ -z "${JWT}" ]; then
    echo 'Failed to get access token!'
    exit 1
  else
    echo 'Obtained access token!'
  fi
}

createRealm() {
  echo "Creating realm ${KEYCLOAK_CREATE_REALM}..."

  curl -X POST "${KEYCLOAK_HOST}/admin/realms" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
    -d "{\"realm\": \"${KEYCLOAK_CREATE_REALM}\", \"enabled\": true}"

  echo "...finished realm ${KEYCLOAK_CREATE_REALM} create."
}

createClient() {
  echo "Creatting Client in realm master..."
    curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/clients" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
    -d "{\"enabled\":true,\"attributes\":{},\"redirectUris\":[],\"clientId\":\"${KEYCLOAK_PROXY_CLIENT_ID}\",\"rootUrl\":\"http://localhost:8000/\",\"protocol\":\"openid-connect\"}"

  echo "...finished realm Master create."
}

createUser() {
  echo "Creatting User in realm master..."
    curl -X POST "${KEYCLOAK_HOST}/admin/realms/master/users" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer ${JWT}" \
    -d "{\"username\": \"${KEYCLOAK_PROXY_USER}\",
                \"enabled\": true,
                \"credentials\": [{
                    \"id\": \"0b06ea86-efbc-4c5e-bac2-f5650397defb\",
                    \"type\": \"password\",
                    \"value\": \"${KEYCLOAK_PROXY_USER_SECRET}\",
                    \"temporary\": false
                }],
                \"realmRoles\": [
                    \"default-roles-master\",
                    \"admin\"
                ]
            }"
  echo "...finished realm Master create."
}

getToken
createRealm