## Service configuration ##
curl -X POST -H "Fiware-Service: devm" -H "Fiware-ServicePath: /" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d '{
        "services": [
        {
            "resource": "/devm",
            "apikey": "nexus",
            "type": "Nexus"
        }
        ]
    }' 'http://iotagent:4041/iot/services'


## Device creation ##
curl -X POST -H "Fiware-Service: devm" -H "Fiware-ServicePath: /" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d '{ 
    "devices": [ 
        { 
            "device_id": "mobile-1", 
            "entity_name": "m1", 
            "entity_type": "Nexus", 
            "attributes": [ 
                  { "object_id": "acceleration", "name": "Acceleration", "type": "string" }
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


## Publishing new values ##
mosquitto_pub -h mqtt -t /nexus/mobile-1/attrs -m '{"acceleration" : "10"}'


## Just checking on orion if the attribute was set ##
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Fiware-Service: devm" -H "Fiware-ServicePath: /" -d '{
    "entities": [
        {
            "isPattern": "false",
            "id": "m1",
            "type": "Nexus"
        }
    ]
}' 'http://orion:1026/NGSI10/queryContext'


## Orion subscription ##
#curl orion:1026/v1/subscribeContext -s -S -H "Fiware-Service: devm" -H #"Fiware-ServicePath: /"  --header 'Content-Type: application/json' \
#    --header 'Accept: application/json' -d '
# {
#    "entities": [
#        {
#            "type": "Nexus",
#            "isPattern": "false",
#            "id": "m1"
#        }
#    ],
#    "attributes": [
#        "Acceleration"
#    ],
#    "reference": "http://172.21.0.1:8080/dev/id",
#    "duration": "P1M",
#    "notifyConditions": [
#        {
#            "type": "ONCHANGE",
#            "condValues": [
#                "Acceleration"
#            ]
#        }
#    ],
#    "throttling": "PT5S"
#}'

## Perseo's subscription in orion ##
curl orion:1026/v1/subscribeContext -s -S -H "Fiware-Service: devm" -H "Fiware-ServicePath: /"  --header 'Content-Type: application/json' \
    --header 'Accept: application/json' -d '
{
    "entities": [
        {
            "type": "Nexus",
            "isPattern": "false",
            "id": "m1"
        }
    ],
    "attributes": [
        "Acceleration"
    ],
    "reference": "http://perseo-fe:9090/notices",
    "duration": "P1M",
    "notifyConditions": [
        {
            "type": "ONCHANGE",
            "condValues": [
                "Acceleration"
            ]
        }
    ],
    "throttling": "PT5S"
}'


## Registering a new filter in perseon ##
curl -X POST http://perseo-fe:9090/rules -H "Fiware-Service: devm" -H "Fiware-ServicePath: /" -H "Content-Type: application/json"  -d '{
   "name":"acceleration_notif_09",
   "text":"select *, \"acceleration_notif_09\" as ruleName, *, ev.Acceleration? as Acceleration, ev.id? as Meter from pattern [every ev=iotEvent(cast(cast(Acceleration?, String), float) > 9 and type=\"Nexus\")]",
   "action":{
      "type":"post",
      "template":"This is another notification - 09 - ${Acceleration}",
      "parameters":{
         "url": "http://172.21.0.1:8081/dev/perseo-fe-09",
         "method": "POST",
         "headers": {
            "Content-type": "text/plain"
         }
      }
   }
}'
