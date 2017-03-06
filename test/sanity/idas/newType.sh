#!/bin/bash -x

host=${IDAS-"iotagent"}

service=${service-"devm"}
service_path=${svcpath-"/"}
entity_type=${type-"device"}

curl -v -X POST -H "Fiware-Service: $service" \
             -H "Fiware-ServicePath: $service_path" \
             -H "Content-Type: application/json" \
             -H "Cache-Control: no-cache" \
             -d "
{
  \"services\": [
    {
      \"resource\": \"\",
      \"apikey\": \"$entity_type\",
      \"entity_type\": \"$entity_type\"
    }
  ]
}
" "http://$host:4041/iot/services"
