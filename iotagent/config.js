var config = {};

config.mqtt = {
    host: 'mqtt',
    port: 1883,
    defaultKey: '1234',
    thinkingThingsPlugin: false
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

config.configRetrieval = false;

module.exports = config;
