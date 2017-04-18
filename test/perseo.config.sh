## Service creation ##
curl -X POST -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d '{
       "services": [
       {
           "resource": "/inspection_service",
           "apikey": "container",
           "type": "ContainerSensor"
       }
       ]
   }' 'http://iotagent:4041/iot/services'


## Device creation ##
curl -X POST -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d '{
   "devices": [
       {
           "device_id": "maersk-lum-1",
           "entity_name": "mk-lum-1",
           "entity_type": "ContainerSensor",
           "attributes": [
                 { "object_id": "luminosity", "name": "Luminosity", "type": "string" }
           ],
           "internal_attributes":  {
               "timeout" : {
                   "sampleQueueMaxSize" : 4,
                   "waitMultiplier" : 3 ,
                   "minimumTimeoutBase" : 50
               }
           }
       }
   ]
}' 'http://iotagent:4041/iot/devices'




## Perseo's subscription in orion' ##
curl orion:1026/v1/subscribeContext -s -S -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection"  --header 'Content-Type: application/json' \
   --header 'Accept: application/json' -d '
{
   "entities": [
       {
           "type": "ContainerSensor",
           "isPattern": "false",
           "id": "mk-lum-1"
       }
   ],
   "attributes": [
       "Luminosity"
   ],
   "reference": "http://perseo-fe:9090/notices",
   "duration": "P1M",
   "notifyConditions": [
       {
           "type": "ONCHANGE",
           "condValues": [
               "Luminosity"
           ]
       }
   ]
}'


## Rules in perseo ##
curl -X POST -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection" -H "Content-Type: application/json"  -d '{
  "name":"luminosity_notif_01",
  "text":"select *, \"luminosity_notif_01\" as ruleName, *, ev2.Luminosity? as LastLuminosity, ev.Luminosity? as Luminosity, ev.id? as Meter from pattern [every ev2=iotEvent((cast(cast(Luminosity?, String), float) > 9.0) and (type=\"ContainerSensor\")) -> ev=iotEvent((cast(cast(Luminosity?, String), float) < 5.0)  and (type=\"ContainerSensor\"))]",
  "action":{
     "type":"post",
     "template":"The container was closed - ${Meter}, luminosity: ${Luminosity}, lastValue: ${LastLuminosity}",
     "parameters":{
        "url": "http://172.21.0.1:8081/dev/perseo-fe-01",
        "method": "POST",
        "headers": {
           "Content-type": "text/plain"
        }
     }
  }
}'  http://perseo-fe:9090/rules


curl -X POST -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection" -H "Content-Type: application/json"  -d '{
  "name":"luminosity_notif_02",
  "text":"select *, \"luminosity_notif_02\" as ruleName, *, ev2.Luminosity? as LastLuminosity, ev.Luminosity? as Luminosity, ev.id? as Meter from pattern [every ev2=iotEvent((cast(cast(Luminosity?, String), float) < 5.0) and (type=\"ContainerSensor\")) -> ev=iotEvent((cast(cast(Luminosity?, String), float) > 9.0) and (type=\"ContainerSensor\"))]",
  "action":{
     "type":"post",
     "template":"The container was opened - ${Meter}, luminosity: ${Luminosity}, lastValue: ${LastLuminosity}",
     "parameters":{
        "url": "http://172.21.0.1:8081/dev/perseo-fe-02",
        "method": "POST",
        "headers": {
           "Content-type": "text/plain"
        }
     }
  }
}'  http://perseo-fe:9090/rules

## Removing rules from perseo ##
# curl -X DELETE -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection"  http://perseo-fe:9090/rules/luminosity_notif_01
# curl -X DELETE -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection"  http://perseo-fe:9090/rules/luminosity_notif_02
# curl -X GET -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection"  http://perseo-fe:9090/rules/


## Publishing new values ##
mosquitto_pub -h mqtt -t /container/maersk-lum-1/attrs -m '{"luminosity" : "0"}'


## Getting data from broker ##
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Fiware-Service: inspection_service" -H "Fiware-ServicePath: /container_inspection" -d '{
   "entities": [
       {
           "isPattern": "false",
           "id": "mk-lum-1",
           "type": "ContainerSensor"
       }
   ]
}' 'http://orion:1026/NGSI10/queryContext'



