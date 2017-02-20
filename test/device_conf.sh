#!/bin/bash -x

host=${host-"iotagent"}

service=${service-"svc"}
service_path=${path-"/svc/path"}

did=${did-"dummy"}
# apikey=${apikey-"dummy"}
entity_type=${type-"device"}
attrs=${attrs-"[{\"name\": \"temperature\", \"type\": \"float\"}]"}

curl -X POST -H "Fiware-Service: $service" -H "Fiware-ServicePath: /" \
             -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d "
{
    \"devices\": [
        {
            \"device_id\": \"${did}\",
            \"entity_name\": \"${did}\",
            \"entity_type\": \"$entity_type\",
            \"attributes\": $attrs
        }
    ]
}
" "http://$host:4041/iot/devices"

# topic: /apikey/device/attrs
