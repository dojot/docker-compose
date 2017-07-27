var config = {};

config.mqtt = {
    host: 'mqtt',
    port: 1883,
    defaultKey: '1234',
    thinkingThingsPlugin: false,
    protocolId: 'MQIsdp',
    protocolVersion: 3,
    options: {
        keepalive: 0,
        connectTimeout: 60 * 60 * 1000
    },
    secure: false
    // tls: {
    //     key: '/opt/iotajson/certs/iotagent.key',
    //     cert: '/opt/iotajson/certs/iotagent.crt',
    //     ca: [ '/opt/iotajson/certs/ca.crt' ]
    //     // version: "TLSv1_2_method" - should be automatic
    //  }
};

config.iota = {
    logLevel: 'DEBUG',
    timestamp: true,
    contextBroker: {
        host: 'orion',
        port: '1026'
    },
    server: {
        port: 4041
    },
    deviceRegistry: {
        type: 'mongodb'
    },
    mongodb: {
        host: 'mongodb',
        port: '27017',
        db: 'iotagentjson'
    },
    types: {},
    service: 'dfl_service',
    subservice: '/dfl_service',
    providerUrl: 'http://iotagent:4041',
    deviceRegistrationDuration: 'P1M',
    defaultType: 'Thing',
    dieOnUnexpectedError: true
};

config.http = {
  port: 8080,
  host: "0.0.0.0"
}

config.timeout = {
    /** Number of messages skipped before dec   laring a device as offline */
    waitMultiplier: 3,
    /** Number of messages to calculate average message arrival time */
    sampleQueueMaxSize: 10,
    /** Timeout resolution and minimum timeout - in miliseconds.*/
    minimumTimeoutBase: 50
}

config.configRetrieval = false;

module.exports = config;
