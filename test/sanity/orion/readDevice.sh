#!/bin/bash

host=${ORION-"orion"}

service=${service-"devm"}
service_path=${svcpath-"/"}

did=${did-"dummy"}
entity_type=${type-"device"}


cat <<PAYLOAD |
{
  "entities": [
      {
          "isPattern": "false",
          "id": "$did",
          "type": "$entity_type"
      }
  ]
}
PAYLOAD
curl -X POST "http://$host:1026/NGSI10/queryContext" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Fiware-Service: $service" \
  -H "Fiware-ServicePath: $service_path" \
  -d @-
