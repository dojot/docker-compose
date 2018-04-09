#!/bin/sh -ex

kong="http://apigw:8001"
kerberos="http://kerberos:8080"

###### Registering APIs

# RegisterComponent
(curl  ${kong}/apis -sS -X POST \
    --header "Content-Type: application/json" \
    --data @- ) <<PAYLOAD
{
    "name": "kerberos_registerComponent",
    "uris": "/kerberos/registerComponent",
    "strip_uri": true,
    "upstream_url": "${kerberos}/kerberosintegration/rest/registry/registerComponent"
}
PAYLOAD

# UnegisterComponent
(curl  ${kong}/apis -sS -X POST \
    --header "Content-Type: application/json" \
    --data @- ) <<PAYLOAD
{
    "name": "kerberos_unregisterComponent",
    "uris": "/kerberos/unregisterComponent",
    "strip_uri": true,
    "upstream_url": "${kerberos}/kerberosintegration/rest/registry/unregisterComponent"
}
PAYLOAD

# RequestAS
(curl  ${kong}/apis -sS -X POST \
    --header "Content-Type: application/json" \
    --data @- ) <<PAYLOAD
{
    "name": "kerberos_requestAS",
    "uris": "/kerberos/requestAS",
    "strip_uri": true,
    "upstream_url": "${kerberos}/kerberosintegration/rest/protocol/requestAS"
}
PAYLOAD

# RequestAP
(curl  ${kong}/apis -s -S -X POST \
    --header "Content-Type: application/json" \
    --data @- ) <<PAYLOAD
{
    "name": "kerberos_requestAP",
    "uris": "/kerberos/requestAP",
    "strip_uri": true,
    "upstream_url": "${kerberos}/kerberosintegration/rest/protocol/requestAP"
}
PAYLOAD

###### Configuring plugin on APIs

apis="
    data-broker
    data-streams
    ws-http
    device-manager
    image
    auth-service
    auth-revoke
    user-service
    flows
    mashup
    history
    ejbca-paths
    alarm-manager-endpoints
    kerberos_registerComponent
    kerberos_unregisterComponent
    kerberos_requestAS
    kerberos_requestAP"

for api_name in ${apis}; do
    # check if the API has been regitered, if not keep waiting
    while true ; do
        (curl -X GET -i ${kong}/apis/${api_name}/plugins | grep -n "HTTP/1.1 200")
        if [ $? -eq 0 ] ; then
            echo "api ${api_name} is registered"
            break
        fi
        echo "api ${api_name} is not registered. Trying again in a few seconds."
        sleep 2
    done

    # register the plugin on API
    (curl  ${kong}/apis/${api_name}/plugins -sS -X POST \
        --header "Content-Type: application/json" \
        --data @- ) <<PAYLOAD
{
    "name": "mutualauthentication",
    "config.kerberos_url": "${kerberos}",
    "config.secure_channel_enabled": true,
    "config.redis_host": "ma-redis"
}
PAYLOAD
done

