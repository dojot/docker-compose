#!/bin/bash

# ---  0.10.x
kong="http://localhost:8001"

(curl $kong/apis -sS -X PUT \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "gui",
    "uris": "/",
    "strip_uri": false,
    "upstream_url": "http://gui:80"
}
PAYLOAD

(curl $kong/apis -sS -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "metric",
    "uris": "/metric",
    "strip_uri": true,
    "upstream_url": "http://orion:1026"
}
PAYLOAD


(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "template",
    "uris": "/template",
    "strip_uri": false,
    "upstream_url": "http://devm:5000"
}
PAYLOAD
curl -X POST $kong/apis/template/plugins --data "name=jwt"

(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "device",
    "uris": "/device",
    "strip_uri": false,
    "upstream_url": "http://devm:5000"
}
PAYLOAD
curl -X POST $kong/apis/device/plugins --data "name=jwt"


(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "auth-service",
    "uris": "/auth",
    "strip_uri": true,
    "upstream_url": "http://auth:5000"
}
PAYLOAD

# (curl $kong/apis -s -S -X POST \
#     --header "Content-Type: application/json" \
#     -d @- | python -m json.tool) <<PAYLOAD
# {
#     "name": "flows",
#     "uris": "/flows",
#     "strip_uri": true,
#     "upstream_url": "http://orch:5000"
# }
# PAYLOAD
