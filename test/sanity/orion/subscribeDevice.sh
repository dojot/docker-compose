#!/bin/bash

host=${ORION-"orion"}

service=${service-"devm"}
service_path=${svcpath-"/"}

did=${did-"dummy"}
entity_type=${type-"device"}
ref=${ref-"http://172.19.0.1:1028/accumulate"}

(curl $host:1026/v1/subscribeContext -s -S \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Fiware-Service: $service" \
    --header "Fiware-ServicePath: $service_path" \
    -d @- | python -m json.tool) <<PAYLOAD
{
    "entities": [
        {
            "type": "$entity_type",
            "isPattern": "false",
            "id": "$did"
        }
    ],
    "reference": "$ref",
    "duration": "P1M",
    "notifyConditions": [{ "type": "ONCHANGE" }]
}
PAYLOAD
