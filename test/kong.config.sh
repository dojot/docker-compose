#!/bin/bash

payload=$(cat <<'EOF'
  {
    "name": "gui",
    "request_host": "localhost.com",
    "request_path": "/gui",
    "strip_request_path": true,
    "preserve_host": false,
    "upstream_url": "http://172.18.0.1:8888"
  }
EOF
)

echo "$payload"  | (curl -X PUT localhost:8001/apis -H 'content-type: application/json' -d @-)

payload=$(cat <<'EOF'
  {
    "name": "devm",
    "request_host": "devm.localhost.com",
    "request_path": "/devm",
    "strip_request_path": true,
    "preserve_host": false,
    "upstream_url": "http://172.18.0.1:5000"
  }
EOF
)
echo "$payload"  | (curl -X PUT localhost:8001/apis -H 'content-type: application/json' -d @-)


# configuration for jwt verification on webservices
kong="http://172.18.0.3:8001"
(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "auth-service",
    "request_host": "devm.localhost.com",
    "request_path": "/auth",
    "strip_request_path": true,
    "preserve_host": false,
    "upstream_url": "http://172.18.0.1:5000"
}
PAYLOAD

(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "test",
    "request_host": "devm.localhost.com",
    "request_path": "/svc",
    "strip_request_path": true,
    "preserve_host": false,
    "upstream_url": "http://172.18.0.1:5050"
}
PAYLOAD

---  0.9.x
kong="http://172.19.0.10:8001"
devm="http://devm:5000"
(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "auth-service",
    "request_path": "/auth",
    "strip_request_path": true,
    "upstream_url": "http://auth:5000"
}
PAYLOAD

(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "template",
    "request_path": "/template",
    "strip_request_path": false,
    "upstream_url": "$devm"
}
PAYLOAD

(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "device",
    "request_path": "/device",
    "strip_request_path": false,
    "upstream_url": "$devm"
}
PAYLOAD

curl -X POST $kong/apis/device/plugins --data "name=jwt"
curl -X POST $kong/apis/template/plugins --data "name=jwt"

(curl $kong/apis -sS -X PUT \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "gui",
    "request_path": "/",
    "strip_request_path": false,
    "upstream_url": "http://172.19.0.1:8888"
}
PAYLOAD



---  0.10.x

kong="http://172.18.0.3:8001"
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

kong="http://localhost:8001"
(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "flows",
    "uris": "/flows",
    "strip_uri": true,
    "upstream_url": "http://orch:5000"
}
PAYLOAD


(curl $kong/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "name": "test",
    "uris": "/svc",
    "strip_uri": true,
    "upstream_url": "http://172.18.0.1:5050"
}
PAYLOAD


{
    "created_at": 1490191689000,
    "id": "0baa239e-d43d-483c-98f4-f0a69678fb07",
    "name": "test",
    "preserve_host": false,
    "request_host": "devm.localhost.com",
    "request_path": "/jwt/svc",
    "strip_request_path": true,
    "upstream_url": "http://172.18.0.1:5000"
}

{
  "secret": "a31ec44ca2ac442698ed31f09f63c747",  # used as secret when issueing the jwt
  "id": "e6fba145-d980-4682-877a-1a1d2bae15be",
  "algorithm": "HS256",
  "created_at": 1490196875000,
  "key": "cb95ab28a77c47e286eda48d503843f6",  # becomes the iss when issueing the jwt
  "consumer_id": "0784b8d2-6038-4b17-a713-b6b48c1b2042"
}
