#!/bin/bash -x

host=${IDAS-"iotagent"}

service=${service-"devm"}
service_path=${svcpath-"/"}

entity_type=${type-"device"}

did=${did-"dummy"}
attrs=${attrs-"[{\"name\": \"temperature\", \"type\": \"float\"}]"}

curl -X POST -H "Fiware-Service: $service" \
             -H "Fiware-ServicePath: $service_path" \
             -H "Content-Type: application/json" \
             -H "Cache-Control: no-cache" \
             -d "
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
