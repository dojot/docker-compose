#!/bin/bash

# ---  0.10.x
kong="http://localhost:8001"

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
curl -o /dev/null -sS -X POST $kong/apis/metric/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/metric/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"


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
curl -o /dev/null -sS -X POST $kong/apis/template/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/template/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"


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
curl -o /dev/null -sS -X POST $kong/apis/device/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/device/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"


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
curl -o /dev/null -sS -X POST $kong/apis/user-service/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/user-service/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"

(curl -o /dev/null $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- ) <<PAYLOAD
{
    "name": "flows",
    "uris": "/flows",
    "strip_uri": true,
    "upstream_url": "http://orch:3000"
}
PAYLOAD
curl -o /dev/null -sS -X POST $kong/apis/flows/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/flows/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"

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
curl -o /dev/null -sS -X POST $kong/apis/history/plugins --data "name=jwt"
#    --data "config.claims_to_verify=exp"

curl -o /dev/null -sS -X POST $kong/apis/history/plugins --data "name=pepkong" \
	 -d "config.pdpUrl=http://keypass:7070"

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
