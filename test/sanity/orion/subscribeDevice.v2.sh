#!/bin/bash

host=${ORION-"orion"}

service=${service-"devm"}
service_path=${svcpath-"/"}

did=${did-"dummy"}
entity_type=${type-"device"}
ref=${ref-"http://172.19.0.1:1028/accumulate"}

(curl $host:1026/v2/subscriptions -v \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Fiware-Service: $service" \
    --header "Fiware-ServicePath: $service_path" \
    -d @- ) <<PAYLOAD
{
  "description": "v2 subs",
  "subject": {
    "entities": [{
        "id": "$did",
        "type": "$entity_type"
    }]
  },
  "notification": {
    "http": { "url": "$ref" },
    "attrs": []
  }
}
PAYLOAD
