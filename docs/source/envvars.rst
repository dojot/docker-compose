Environment variables
=====================

Data Broker
-----------

.. code-block:: bash

    # Service Port. Change DATA_BROKER_SERVICE_PORT in .env file for consistency.
    export SERVICE_PORT=80
    # Data Broker URL. Changing DATA_BROKER_SERVICE_PORT in .env file will affect this.
    export DATA_BROKER_URL="http://data-broker:80"

    # Log level. Accepted values: info, warn, error and debug.
    export LOG_LEVEL="info"