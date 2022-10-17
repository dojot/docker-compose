# Telegraf
## Environment variable Configurations 

| Environment variable                        | Purpose                                                                         | Default Value           | Valid Values              |
| ------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------- | ------------------------- |
| TELEGRAF_DEBUG                              | Enabling console logger-level debugging (required)                              |                         | boolean true, false       |
| TELEGRAF_INFLUXDB_URL                       | InfluxDB URL                                                                    | http://localhost:8086   | string                    |
| TELEGRAF_INFLUXDB_TOKEN                     | InfluxDB token                                                                  |                         | string                    |
| TELEGRAF_INFLUXDB_BUCKET_NAME               | Main bucket name                                                                | devices                 | string                    |
| TELEGRAF_KAFKA_BROKER                       | Kafka broker url                                                                | http://localhost:9092   | string                    |
| TELEGRAF_KAFKA_CONSUMER_GROUP               | Kafka consumer group id                                                         | telegraf                | string                    |
| TELEGRAF_KAFKA_DATA_TOPIC                   | Data topic in kafka                                                             |                         | string, regex             |
| TELEGRAF_KAFKA_DATA_TOPIC_REFRESH_INTERVAL  | Interval to refresh topic list                                                  |                         | Intervals are durations of time and can be specified for supporting settings by combining an integer value and time unit as a string value. Valid time units are ns, us (or µs), ms, s, m, h. |
| TELEGRAF_KAFKA_DATA_OFFSET                  | Kafka Data topic offset.                                                        | newest                  | oldest, newest            |
| TELEGRAF_KAFKA_DATA_MAX_BUFFER              | kafka maximum read buffer size                                                  | 1000                    | integer                   |
| TELEGRAF_DATA_READ_INTERVAL                 | Interval between data request                                                   | 10s                     | Intervals are durations of time and can be specified for supporting settings by combining an integer value and time unit as a string value. Valid time units are ns, us (or µs), ms, s, m, h. |
| TELEGRAF_DATA_FLUSH_INTERVAL                | Interval to flush buffer                                                        | 10s                     | Intervals are durations of time and can be specified for supporting settings by combining an integer value and time unit as a string value. Valid time units are ns, us (or µs), ms, s, m, h. |
| TELEGRAF_DATA_BATCH_SIZE                    | Writing batch size                                                              | 1000          | integer                  |
| TELEGRAF_DATA_BUFFER_LIMIT                  | Maximum general buffer size                                                     | 10000         | integer                  |
| TELEGRAF_KAFKA_TENANCY_TOPIC                | Tenancy topic in kafka                                                          |               | string                  |
| TELEGRAF_KAFKA_TENANCY_OFFSET               | Kafka Data topic offset.                                                        | newest        | oldest, newest           |
| TELEGRAF_KAFKA_TENANCY_INTERVAL             | Interval for verifying a new tenant                                             | 60s           | Intervals are durations of time and can be specified for supporting settings by combining an integer value and time unit as a string value. Valid time units are ns, us (or µs), ms, s, m, h. |
||

Note: All variables are required