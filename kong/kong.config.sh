#!/bin/sh
kong="http://apigw:8001"
dojot_domain_name=$(grep DOJOT_DOMAIN_NAME /opt/env | awk -F"=" '{print $2}')
route_allow_only_https=${DOJOT_KONG_ROUTE_ALLOW_ONLY_HTTPS:-false}

route_allow_protocol='"http","https"'

if [ "$route_allow_only_https" = "true" ]; then
    echo "Allow onlyhttps"
    route_allow_protocol='"https"'
fi;

# check if kong is started
if curl --output /dev/null --silent --head --fail "$kong"; then
  echo "Kong is started."
else
  echo "Kong isn't started."
  echo "Terminating in 20s..."
  sleep 20
  exit 1
fi

# add authentication to an endpoint
addAuthToEndpoint() {
# $1 = Service Name
echo ""
echo ""
echo "- addAuthToEndpoint: ServiceName=${1}"

# To understand about lua patterns and its limitations http://lua-users.org/wiki/PatternsTutorial
# This regex is to guarantee whether or not it has port 443 and 80, it will be able to validate the issuer
allowed_iss_url="https?://${dojot_domain_name}:?(%d*)/auth/realms/(.+)"

curl -sS -X POST \
--url ${kong}/services/"${1}"/plugins \
--data "name=jwt-keycloak" \
--data-urlencode "config.allowed_iss=${allowed_iss_url}"

curl -sS -X POST \
--url ${kong}/services/"${1}"/plugins/ \
--data "name=pepkong" \
--data "config.resource=${1}"

}

# add a Service
# that is the name Kong uses to refer to the upstream APIs
# and microservices it manages.
createService() {
# $1 = Service Name
# $2 = URL (ex.: http://gui:80)
echo ""
echo "-- createService: ServiceName=${1} Url=${2}"
curl  -sS -X PUT \
--url ${kong}/services/"${1}" \
--data "name=${1}" \
--data "url=${2}"
}

# add a Route
# The Route represents the actual request to the Kong proxy
# endpoint to reach at Kong service.
createRoute() {
# $1 = Service Name
# $2 = Route Name
# $3 = PATHS (ex.: '"/","/x"')
# $4 = strip_path (true or false), When matching a Route via one of the paths, strip the matching prefix from the upstream request URL
echo ""
echo "-- createRoute: ServiceName=${1} Url=${2} PathS=${3} StripPath=${4}"
(curl  ${kong}/services/"${1}"/routes/"${2}" -sS -X PUT \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "paths": [${3}],
    "strip_path": ${4},
    "protocols": [${route_allow_protocol}],
    "https_redirect_status_code": 301
}
PAYLOAD
}

# Create an endpoint mapping in Kong
# ex1: createEndpoint "data-broker" "http://data-broker:80"  '"/device/(.*)/latest", "/subscription"' "false"
# ex2: createEndpoint "image" "http://image-manager:5000"  '"/fw-image"' "true"
createEndpoint(){
# $1 = Service Name
# $2 = URL (ex.: "http://gui:80")
# $3 = PATHS (ex.: '"/","/x"')
# $4 = strip_path ("true" or "false"), When matching a Route via one of the paths, strip the matching prefix from the upstream request URL.
echo ""
echo ""
echo "- createEndpoint: ServiceName=${1} Url=${2} PathS=${3} StripPath=${4}"
createService "${1}" "${2}"
createRoute "${1}" "${1}_route" "${3}" "${4}"
}

# service: letsencrypt-nginx
curl  -sS -X PUT \
--url ${kong}/services/letsencrypt-nginx \
--data "name=letsencrypt-nginx" \
--data "url=http://letsencrypt-nginx:80"

curl  -sS -X PUT \
--url ${kong}/services/letsencrypt-nginx/routes/letsencrypt-nginx_route \
--data "paths=/.well-known/acme-challenge" \
--data "strip_path=false"

# service: device-manager
createEndpoint "device-manager-template" "http://device-manager-sidecar:5000"  '"/template"' "false"
addAuthToEndpoint "device-manager-template"

createEndpoint "device-manager-devices" "http://device-manager-sidecar:5000"  '"/device"' "false"
addAuthToEndpoint "device-manager-devices"

# service: keycloak
createEndpoint "keycloak" "http://keycloak:8080/auth"  '"/auth"' "true"

# service: data-manager
createEndpoint "data-manager-import" "http://data-manager:3000/"  '"/import"' "false"
addAuthToEndpoint "data-manager-import"

createEndpoint "data-manager-export" "http://data-manager:3000/"  '"/export"' "false"
addAuthToEndpoint "data-manager-export"

# service: backstage
createEndpoint "backstage" "http://backstage:3005"  '"/backstage"' "false"

# service: cron
createEndpoint "cron" "http://cron:5000/"  '"/cron"' "false"
addAuthToEndpoint "cron"

# service: x509-identity-mgmt
createEndpoint "x509-identity-mgmt" "http://x509-identity-mgmt:3000/api"  '"/x509"' "true"
addAuthToEndpoint "x509-identity-mgmt"

# service: influx-retriever
createEndpoint "influxdb-retriever" "http://influxdb-retriever:4000/tss"  '"/tss"' "true"
addAuthToEndpoint "influxdb-retriever"

createEndpoint "influxdb-retriever-api-docs" "http://influxdb-retriever:4000/tss/v1/api-docs"  '"/tss/v1/api-docs"' "true"

# service: kafka-ws
createEndpoint "kafka-ws" "http://kafka-ws:8080/"  '"/kafka-ws"' "false"

# service: file-mgmt
createEndpoint "file-mgmt" "http://file-mgmt:7000"  '"/file-mgmt"' "true"
addAuthToEndpoint "file-mgmt"

createEndpoint "minio-files" "http://minio-files:9000"  '"/minio-files"' "true"

createEndpoint "report-manager" "http://report-manager:3791"  '"/report-manager"' "true"
addAuthToEndpoint "report-manager"

createEndpoint "container-nx" "http://container-nx:80" '"/v2"' "true"
createEndpoint "common-nx" "http://common-nx:80" '"/mfe/common"' "true"
createEndpoint "home-nx" "http://home-nx:80" '"/mfe/home"' "true"
createEndpoint "dashboard-nx" "http://dashboard-nx:80" '"/mfe/dashboard"' "true"
createEndpoint "devices-nx" "http://devices-nx:80" '"/mfe/devices"' "true"
createEndpoint "templates-nx" "http://templates-nx:80" '"/mfe/templates"' "true"
createEndpoint "security-nx" "http://security-nx:80" '"/mfe/security"' "true"
createEndpoint "reports-nx" "http://reports-nx:80" '"/mfe/reports"' "true"

# service: device-manager-batch
createEndpoint "device-manager-batch" "http://device-manager-batch:8089" '"/device-manager-batch"' "true"
addAuthToEndpoint "device-manager-batch"

# service: basic-auth
createEndpoint  "basic-auth" "http://basic-auth:3000" '"/basic-auth/v1/devices/(.*)/basic-credentials"' "false"
addAuthToEndpoint "basic-auth"

# service: http-agent
createEndpoint "http-agent-basic" "http://http-agent-basic:3001"  '"/http-agent/v1/unsecure/incoming-messages(.*)"' "false"

echo ""
echo ""
echo "- add timeout to kafka-ws"

curl -sS -X PATCH \
    --url ${kong}/services/kafka-ws \
    --data "read_timeout=300000" \
    --data "write_timeout=300000" \
    --data "connect_timeout=300000"

createEndpoint "kafka-ws-ticket" "http://kafka-ws:8080/"  '"/kafka-ws/v[0-9]+/ticket"' "false"
addAuthToEndpoint "kafka-ws-ticket"

echo ""
echo ""
echo "- add global correlation-id plugin"
curl  -s  -sS -X POST \
--url ${kong}/plugins/ \
    --data "name=correlation-id" \
    --data "config.header_name=X-Request-Id" \
    --data "config.generator=uuid" \
    --data "config.echo_downstream=false"

echo ""
echo ""
echo "*********************AUDIT*******************************"

curl -sS -X POST \
--url ${kong}/services/device-manager-devices/plugins/ \
--data "name=file-log"  \
--data "config.path=/home/kong/device.log"

curl -sS -X POST \
--url ${kong}/services/device-manager-template/plugins/ \
--data "name=file-log"  \
--data "config.path=/home/kong/template.log"

curl -sS -X POST \
--url ${kong}/services/x509-identity-mgmt/plugins/ \
--data "name=file-log"  \
--data "config.path=/home/kong/x509-identity-mgmt.log"