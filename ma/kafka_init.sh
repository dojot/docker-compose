#!/bin/sh

exec /usr/bin/start-kafka.sh &

result=1
while [ $result -ne "0" ]
do
  sleep 1
  echo dump | nc zookeeper 2181 | grep brokers
  result=$?
done

cd /opt/kafka/bin

./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugcomponent.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugcryptochannel.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugpageprotection.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugreleasetransaction.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic debugtransaction.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic loggingprocessing.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic loggingtransaction.A --partitions 10 --replication-factor 1

./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic cryptoreleasedecryptcctopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic kerberosmanagementtopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic kerberosprotocoltopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic decrypttopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic decryptwithcctopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic encrypttopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic encryptwithcctopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic unregistertopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic savecryptochanneltopic.A --partitions 10 --replication-factor 1
./kafka-topics.sh --zookeeper zookeeper:2181 --create --topic registertopic.A --partitions 10 --replication-factor 1

tail -f /dev/null
