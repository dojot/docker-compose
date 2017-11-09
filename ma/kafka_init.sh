#!/bin/sh

exec /start.sh &

{ tail -n +1 -f /kafka/logs/server.log & } | sed -n '/started/q'

unset JMX_PORT
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugcomponent.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugcryptochannel.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugpageprotection.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugreleasetransaction.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugtransaction.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic loggingprocessing.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic loggingtransaction.A --partitions 10 --replication-factor 1

kafka-topics.sh --zookeeper zookeeper:2181 --create --topic cryptoreleasedecryptcctopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic kerberosmanagementtopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic kerberosprotocoltopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic decrypttopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic decryptwithcctopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic encrypttopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic encryptwithcctopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic unregistertopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic savecryptochanneltopic.A --partitions 10 --replication-factor 1
kafka-topics.sh --zookeeper zookeeper:2181 --create --topic registertopic.A --partitions 10 --replication-factor 1

tail -f /dev/null
