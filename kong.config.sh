#!/bin/bash

# ---  0.10.x
kong="http://localhost:8001"

authConfig() {
  curl -o /dev/null -sS -X POST $kong/apis/$1/plugins -d "name=jwt" # -d "config.claims_to_verify=exp"
  curl -o /dev/null -sS -X POST $kong/apis/$1/plugins -d "name=pepkong" -d "config.pdpUrl=http://auth:5000/pdp"
}

# remove all previously configured apis from gateway
for i in $(curl -sS localhost:8001/apis  | grep -oP '(?<="id":")[a-f0-9-]+(?=")'); do
  curl -o /dev/null -sS -X DELETE $kong/apis/$i
done

(curl -o /dev/null $kong/apis -sS -X PUT \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "gui",
    "uris": "/",
    "strip_uri": false,
    "upstream_url": "http://gui:80"
}
PAYLOAD
# no auth: serves only static front-end content

(curl -o /dev/null $kong/apis -sS -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "metric",
    "uris": "/metric",
    "strip_uri": true,
    "upstream_url": "http://orion:1026"
}
PAYLOAD
authConfig "metric"


(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "template",
    "uris": "/template",
    "strip_uri": false,
    "upstream_url": "http://devm:5000"
}
PAYLOAD
authConfig "template"


(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "device",
    "uris": "/device",
    "strip_uri": false,
    "upstream_url": "http://devm:5000"
}
PAYLOAD
authConfig "device"

(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "auth-service",
    "uris": "/auth",
    "strip_uri": true,
    "upstream_url": "http://auth:5000"
}
PAYLOAD
# no auth: this is actually the endpoint used to get a token
# rate plugin limit to avoid brute-force atacks
curl -o /dev/null -sS -X POST $kong/apis/auth-service/plugins \
    --data "name=rate-limiting" \
    --data "config.minute=5" \
    --data "config.hour=40" \
    --data "config.policy=local"


# revoke all tokens: maintence only API
(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "auth-revoke",
    "uris": "/auth/revoke",
    "strip_uri": true,
    "upstream_url": "http://auth:5000/auth/revoke"
}
PAYLOAD
curl -o /dev/null -sS -X POST  $kong/apis/auth-revoke/plugins \
    --data "name=request-termination" \
    --data "config.status_code=403" \
    --data "config.message=Not authorized"


(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "user-service",
    "uris": "/auth/user",
    "strip_uri": true,
    "upstream_url": "http://auth:5000/user"
}
PAYLOAD
authConfig "user-service"

(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "flows",
    "uris": "/flows",
    "strip_uri": true,
    "upstream_url": "http://mashup:3000"
}
PAYLOAD
authConfig "flows"

(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "history",
    "uris": "/history",
    "strip_uri": true,
    "upstream_url": "http://sth:8666"
}
PAYLOAD
authConfig "history"

# TODO it might be a good idea to merge this with the orchestrator itself
(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "mashup",
    "uris": "/mashup",
    "strip_uri": true,
    "upstream_url": "http://mashup:1880"
}
PAYLOAD
# no auth: serves only available types

(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "httpDevices",
    "uris": "/iot",
    "strip_uri": false,
    "upstream_url": "http://iotagent:8080"
}
PAYLOAD
# no auth: used for middleware <-> device communication via HTTP(s)
