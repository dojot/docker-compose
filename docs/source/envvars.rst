Environment variables
=====================

These are all the current environment variables that can be set in each
service. Remember that they are valid only for the tag that is currently
specified in docker-compose file.


History
-------

.. code-block:: bash

    # MongoDB address
    export HISTORY_DB_ADDRESS="mongodb"
    # MongoDB port
    export HISTORY_DB_PORT=27017
    # Replica set to be used (string)
    export HISTORY_DB_REPLICA_SET=None
    # How many seconds before remove an entry in MongoDB
    export HISTORY_DB_DATA_EXPIRATION=604800

    #
    # Other services
    #
    # Where Auth is
    export AUTH_URL="http://auth:5000"
    # Where Device Manager is:
    export DEVICE_MANAGER_URL="http://device-manager:5000"




Persister
---------


.. code-block:: bash

    # MongoDB address
    export HISTORY_DB_ADDRESS="mongodb"
    # MongoDB port
    export HISTORY_DB_PORT=27017
    # How many seconds before remove an entry in MongoDB
    export HISTORY_DB_DATA_EXPIRATION=604800

    #
    # dojot-module related variables
    #

    # Comma separated list of Kafka instances to be used for Kafka client
    # bootstrapping.
    export KAFKA_HOSTS="kafka:9092"
    # Kafka group ID for consumers. It is advisible that this is the same
    # for instances of the same service and different for each service.
    export KAFKA_GROUP_ID="kafka"
    # Amount of time (in seconds) that the service will wait before attempting
    # to subscribe to a set of Kafka topics.
    export DOJOT_KAFKA_SUBSCRIPTION_HOLDOFF="2"
    # Time between each poll
    export DOJOT_KAFKA_POLL_TIMEOUT="2000"
    # Where Data Broker is
    export DATA_BROKER_URL="http://data-broker"
    # Where Device Manager is
    export DEVICE_MANAGER_URL="http://device-manager:5000"
    # Where Auth is
    export AUTH_URL="http://auth:5000"

    # Tenant used for management operations and associated messages, such as
    # tenant creation
    export DOJOT_MANAGEMENT_TENANT="dojot-management"
    # User for management request, such as requesting the list of currently
    # configured tenants.
    export DOJOT_MANAGEMENT_USER="dojot-management"
    # Subject used for tenancy messages, such as tenant CRUD messages
    export DOJOT_SUBJECT_TENANCY="dojot.tenancy"
    # Subject used for device management messages, such as creation.
    export DOJOT_SUBJECT_DEVICES="dojot.device-manager.device"
    # Subject used for device messages, such as device attributes update
    export DOJOT_SUBJECT_DEVICE_DATA="device-data"


IoT agent MQTT
--------------

.. code-block:: bash

    # REDIS instance for Mosca backend
    export BACKEND_HOST="mosca-redis"
    export BACKEND_PORT=6379

    # Enable or disable unsecured mode
    # Encrypted communication is always enabled.
    export ALLOW_UNSECURED_MODE="false"

    # Log level. Accepted values: info, warn, error and debug.
    export LOG_LEVEL="info"

    # Mosca TLS configuration
    export MOSCA_TLS_SECURE_CERT="/opt/iot-agent/mosca/certs/mosca.crt"
    export MOSCA_TLS_SECURE_KEY="/opt/iot-agent/mosca/certs/mosca.key"
    export MOSCA_TLS_CA_CERT="/opt/iot-agent/mosca/certs/ca.crt"
    export MOSCA_TLS_DNS_LIST="mqtt,mosca,localhost"
    #Maximum lifetime of a connection in ms (If is 0 then is disabled)
    export MOSCA_TLS_CON_MAX_LIFETIME=7200000
    #The idle timeout for a connection in ms (If is 0 then is disabled)
    export MOSCA_TLS_CON_IDLE_TIMEOUT=1800000

    # IoT agent healthcheck configuration
    # All values are in miliseconds and indicate how much time it will
    # wait before checking a particular state again.
    export HC_UPTIME_TIMEOUT=300000
    export HC_MEMORY_USAGE_TIMEOUT=300000
    export HC_CPU_USAGE_TIMEOUT=300000
    export HC_MONGODB_TIMEOUT=30000
    export HC_KAFKA_TIMEOUT=30000

    #
    # dojot-module related variables
    #

    # Comma separated list of Kafka instances to be used for Kafka client
    # bootstrapping.
    export KAFKA_HOSTS="kafka:9092"
    # Kafka group ID for consumers. It is advisible that this is the same
    # for instances of the same service and different for each service.
    export KAFKA_GROUP_ID="kafka"
    # Amount of time (in seconds) that the service will wait before attempting
    # to subscribe to a set of Kafka topics.
    export DOJOT_KAFKA_SUBSCRIPTION_HOLDOFF="2"
    # Time between each poll
    export DOJOT_KAFKA_POLL_TIMEOUT="2000"
    # Where Data Broker is
    export DATA_BROKER_URL="http://data-broker"
    # Where Device Manager is
    export DEVICE_MANAGER_URL="http://device-manager:5000"
    # Where Auth is
    export AUTH_URL="http://auth:5000"

    # Tenant used for management operations and associated messages, such as
    # tenant creation
    export DOJOT_MANAGEMENT_TENANT="dojot-management"
    # User for management request, such as requesting the list of currently
    # configured tenants.
    export DOJOT_MANAGEMENT_USER="dojot-management"
    # Subject used for tenancy messages, such as tenant CRUD messages
    export DOJOT_SUBJECT_TENANCY="dojot.tenancy"
    # Subject used for device management messages, such as creation.
    export DOJOT_SUBJECT_DEVICES="dojot.device-manager.device"
    # Subject used for device messages, such as device attributes update
    export DOJOT_SUBJECT_DEVICE_DATA="device-data"


Data Broker
-----------

.. code-block:: bash

    # Redis instance used by Data Broker
    export DATABROKER_CACHE_HOST="data-broker-redis"

    # Kafka configuration. These are used for topic creation.
    export DATABROKER_KAFKA_ADDRESS="kafka"
    export DATABROKER_KAFKA_PORT=9092
    export DATABROKER_ZOOKEEPER_HOST="zookeeper:2181"
    # Service Port. Change SERV_PORT in .env file for consistency.
    export SERVICE_PORT=80
    # Log level. Accepted values: info, warn, error and debug.
    export LOG_LEVEL="info"

    # Data Broker healthcheck configuration
    # All values are in miliseconds and indicate how much time it will
    # wait before checking a particular state again.
    export HC_UPTIME_TIMEOUT=300000
    export HC_MEMORY_USAGE_TIMEOUT=300000
    export HC_CPU_USAGE_TIMEOUT=300000
    export HC_MONGODB_TIMEOUT=30000
    export HC_KAFKA_TIMEOUT=30000

    #
    # dojot-module related variables
    #

    # Comma separated list of Kafka instances to be used for Kafka client
    # bootstrapping.
    export KAFKA_HOSTS="kafka:9092"
    # Kafka group ID for consumers. It is advisible that this is the same
    # for instances of the same service and different for each service.
    export KAFKA_GROUP_ID="kafka"
    # Amount of time (in seconds) that the service will wait before attempting
    # to subscribe to a set of Kafka topics.
    export DOJOT_KAFKA_SUBSCRIPTION_HOLDOFF="2"
    # Time between each poll
    export DOJOT_KAFKA_POLL_TIMEOUT="2000"
    # Where Data Broker is. Changing SERV_PORT in .env file will affect this.
    export DATA_BROKER_URL="http://data-broker"
    # Where Device Manager is
    export DEVICE_MANAGER_URL="http://device-manager:5000"
    # Where Auth is
    export AUTH_URL="http://auth:5000"

    # Tenant used for management operations and associated messages, such as
    # tenant creation
    export DOJOT_MANAGEMENT_TENANT="dojot-management"
    # User for management request, such as requesting the list of currently
    # configured tenants.
    export DOJOT_MANAGEMENT_USER="dojot-management"
    # Subject used for tenancy messages, such as tenant CRUD messages
    export DOJOT_SUBJECT_TENANCY="dojot.tenancy"
    # Subject used for device management messages, such as creation.
    export DOJOT_SUBJECT_DEVICES="dojot.device-manager.device"
    # Subject used for device messages, such as device attributes update
    export DOJOT_SUBJECT_DEVICE_DATA="device-data"


Image Manager
-------------

.. code-block:: bash

    # PostgreSQL instance used by Image Manager
    export DBHOST="postgres"
    export DBUSER="postgres"
    export DBPASS=None
    export DBNAME="dojot_imgm"
    export DBDRIVER="postgresql+psycopg2"
    # Flag indicating whether the boot process should try to create the database
    # or not.
    export CREATE_DB=True
    export S3URL="minio:9000"
    export S3ACCESSKEY=""
    export S3SECRETKEY=""



Device Manager
--------------

.. code-block:: bash


    # PostgreSQL instance used by Device Manager
    export DBHOST="postgres"
    export DBUSER="postgres"
    export DBPASS=None
    export DBNAME="dojot_devm"
    export DBDRIVER="postgresql+psycopg2"
    # Flag indicating whether the boot process should try to create the database
    # or not.
    export CREATE_DB=True

    # Kafka configuration
    export KAFKA_HOST="kafka"
    export KAFKA_PORT=9092

    # Other dojot services
    # Where Data Broker is
    export BROKER="http://data-broker"
    # Subject used for emitting device management messages
    export SUBJECT="dojot.device-manager.device"
    # Subject used for consuming device attribute update messages
    export DEVICE_SUBJECT="device-data"

    # Redis instance used by Device Manager
    export REDIS_HOST="device-manager-redis"
    export REDIS_PORT="6379"

    # Device PSK configuration
    export DEV_MNGR_CRYPTO_PASS=""
    export DEV_MNGR_CRYPTO_IV=""
    export DEV_MNGR_CRYPTO_SALT=""



Auth
----

.. code-block:: bash

    # Auth PostgreSQL database configuration.
    export AUTH_DB_HOST="postgres"
    export AUTH_DB_USER="auth"
    export AUTH_DB_PWD=""
    export AUTH_DB_NAME="dojot_auth"
    # Flag indicating whether the boot process should try to create the database
    # or not.
    export AUTH_DB_CREATE=True

    # Auth Redis configuration
    export AUTH_CACHE_NAME="redis"
    export AUTH_CACHE_USER="redis"
    export AUTH_CACHE_PWD=""
    export AUTH_CACHE_HOST="redis"
    export AUTH_CACHE_TTL=720
    export AUTH_CACHE_DATABASE="0"

    # Where API gateway is
    export AUTH_KONG_URL="http://kong:8001"
    export AUTH_TOKEN_EXP=420

    # Auth e-mail configuration

    # Flag indicating whether there should be an e-mail or not. If this var
    # is anything but "NOEMAIL", then an email is sent to the user whenever
    # she/he needs to opeate the password.
    export AUTH_EMAIL_HOST="NOEMAIL"

    # Port which Auth will listen to.
    export AUTH_EMAIL_PORT=587

    # Flag indicating whether TLS should be used when sending an e-mail
    export AUTH_EMAIL_TLS="true"

    # Username associatd to the mail server.
    export AUTH_EMAIL_USER=""

    # Passowrd associated to the field right above this.
    export AUTH_EMAIL_PASSWD=""

    # ?
    export AUTH_RESET_PWD_VIEW=""

    # If not using an email, then the default password will be this one.
    export AUTH_USER_TMP_PWD="temppwd"
    # Period of time which the password request is deeemed valid (minutes).
    export AUTH_PASSWD_REQUEST_EXP=30
    # Number of itens to keep in password history (to check whether the user
    # has already set that password before)
    export AUTH_PASSWD_HISTORY_LEN=4
    # Minimum length for a valid password
    export AUTH_PASSWD_MIN_LEN=8
    # List of unwanted passwords (common, simple ones)
    export AUTH_PASSWD_BLACKLIST="password_blacklist.txt"
    # Default output for logging
    export AUTH_SYSLOG="STDOUT"
    # Kafka address
    export KAFKA_HOST="kafka:9092"
    # Tenant used for management operations and associated messages, such as
    # tenant creation
    export DOJOT_MANAGEMENT_TENANT="dojot-management"
    # User for management request, such as requesting the list of currently
    # configured tenants.
    export DOJOT_MANAGEMENT_USER="dojot-management"
    # Where Data Broker is
    export DATA_BROKER_URL="http://data-broker"


Flow Broker
-----------

.. code-block:: bash

    # Redis instance used by flowbroker
    export FLOWBROKER_CACHE_HOST="flowbroker-redis"

    # Where Device Manager is
    export DEVICE_MANAGER_HOST="http://device-manager:5000"

    # Where MongoDB is
    export MONGO_URL="mongodb://mongodb:27017"

    # MongoDB replicaset to be used
    export REPLICA_SET=""

    # Where RabbitMQ is
    export AMQP_URL="amqp://rabbitmq"

    # RabbitMQ queue configuration
    export AMQP_QUEUE="task_queue"
    export AMQP_EVENT_QUEUE="event_queue"

    # Which deploy should be used for remote nodes, "docker" or "kubernetes"
    export DEPLOY_ENGINE="kubernetes"
    export KUBERNETES_SERVICE_HOST=""
    export KUBERNETES_PORT_443_TCP_PORT=""
    export KUBERNETES_TOKEN=""
    export DOCKER_SOCKET_PATH="/var/run/docker.sock"

    # Default network for remote nodes.
    export FLOWBROKER_NETWORK="dojot"

    # Context manager configuration
    export CONTEXT_MANAGER_ADDRESS="flowbroker-context-manager"
    export CONTEXT_MANAGER_PORT=5556
    export CONTEXT_MANAGER_RESPONSE_TIMEOUT=10000


    #
    # dojot-module related variables
    #

    # Comma separated list of Kafka instances to be used for Kafka client
    # bootstrapping.
    export KAFKA_HOSTS="kafka:9092"
    # Kafka group ID for consumers. It is advisible that this is the same
    # for instances of the same service and different for each service.
    export KAFKA_GROUP_ID="flowbroker"
    # Amount of time (in seconds) that the service will wait before attempting
    # to subscribe to a set of Kafka topics.
    export DOJOT_KAFKA_SUBSCRIPTION_HOLDOFF="2"
    # Time between each poll
    export DOJOT_KAFKA_POLL_TIMEOUT="2000"
    # Where Data Broker is
    export DATA_BROKER_URL="http://data-broker"
    # Where Device Manager is
    export DEVICE_MANAGER_URL="http://device-manager:5000"
    # Where Auth is
    export AUTH_URL="http://auth:5000"

    # Tenant used for management operations and associated messages, such as
    # tenant creation
    export DOJOT_MANAGEMENT_TENANT="dojot-management"
    # User for management request, such as requesting the list of currently
    # configured tenants.
    export DOJOT_MANAGEMENT_USER="dojot-management"
    # Subject used for tenancy messages, such as tenant CRUD messages
    export DOJOT_SUBJECT_TENANCY="dojot.tenancy"
    # Subject used for device management messages, such as creation.
    export DOJOT_SUBJECT_DEVICES="dojot.device-manager.device"
    # Subject used for device messages, such as device attributes update
    export DOJOT_SUBJECT_DEVICE_DATA="device-data"


    # Healthcheck configuration
    # All values are in miliseconds and indicate how much time it will
    # wait before checking a particular state again.
    export HC_UPTIME_TIMEOUT=300000
    export HC_MEMORY_USAGE_TIMEOUT=300000
    export HC_CPU_USAGE_TIMEOUT=300000
    export HC_MONGODB_TIMEOUT=30000
    export HC_KAFKA_TIMEOUT=30000



Flow Broker - Context Manager:

.. code-block:: bash

    # Zookeeper configuration
    export ZOOKEEPER_HOST="zookeeper"
    export ZOOKEEPER_PORT=2181

    # Port used by ZeroMQ
    export ZEROMQ_PORT=5556

    # Timeout value for locked variables. After this period, the variable
    # will be automatically unlocked (time in ms)
    export HOLD_LOCK_TIMEOUT=10000

    # Timeout value for wait operations for locks. After this period, the client
    # will be automatically freed, but with no data. (time in ms)
    export WAIT_LOCK_TIMEOUT=30000



EJBCA REST
----------

.. code-block:: bash

    # Kafka host
    export EJBCA_KAFKA_HOST="kafka:9092"



Data Manager
------------

.. code-block:: bash

    # Where Flow Broker is
    export FLOW_BROKER_URL="http://flowbroker:80"

    # Where Device Manager is
    export DEVICE_MANAGER_URL="http://device-manager:5000"

    # Port which Data Manager will listen to
    export PORT=3000


Backstage
---------

.. code-block:: bash

    # Port which Backstage will listen to
    export PORT=3005

    # GraphQL config
    # Where the APIGW is
    export LOCAL_URL="http://apigw"
    export LOCAL_PORT="8000"

    # Where Auth is
    export AUTH_INTERNAL_URL="http://auth"
    export AUTH_INTERNAL_PORT="5000"


    # Database access for device handling
    export POSTGRES_USER="postgres"
    export POSTGRES_HOST="postgres"
    export POSTGRES_DATABASE="dojot_devm"
    export POSTGRES_PASSWORD="postgres"
    export POSTGRES_PORT=5432

