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
