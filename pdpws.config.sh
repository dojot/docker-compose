#!/bin/bash

echo "Checking PEP-WS environment..."

ipPostgres=localhost
PSQL="docker exec $(docker ps -f name=postgres --format "{{.Names}}" | head -1) psql"

existsPEPWS=($($PSQL --host=$ipPostgres --port=5432 --username=postgres -t -c "select true from pg_database where datname = 'dojot'"))

if [ "$existsPEPWS" = "" ]; then
  echo "Creating PEP-WS database..."
  $PSQL --host=$ipPostgres --port=5432 --username=postgres -c "CREATE DATABASE dojot WITH ENCODING 'UTF8'"

  echo "Creating PEP-WS schema..."
  $PSQL --host=$ipPostgres --port=5432 --username=postgres --dbname=dojot -c "CREATE SCHEMA dojot_authorization"

  echo "Creating PEP-WS schema..."
  $PSQL --host=$ipPostgres --port=5432 --username=postgres --dbname=dojot -c 'CREATE TABLE dojot_authorization."authorization"
    (
      action character varying(200),
      resource character varying(200),
      accessSubject character varying(200)
    );'

  echo "Inserting PEP-WS policies..."
  $PSQL --host=$ipPostgres --port=5432 --username=postgres --dbname=dojot -c "insert into dojot_authorization.authorization
    	(action, resource, accessSubject)
    values
    	('GET', 'device', 'admin'),
    	('POST', 'device', 'admin'),
    	('GET', 'device', 'user'),
    	('POST', 'device', 'user'),
    	('GET', 'metric', 'admin'),
    	('POST', 'metric', 'admin'),
    	('GET', 'metric', 'user'),
    	('POST', 'metric', 'user'),
    	('GET', 'template', 'admin'),
    	('POST', 'template', 'admin'),
    	('GET', 'template', 'user'),
    	('POST', 'template', 'user'),
    	('GET', 'flows', 'admin'),
    	('POST', 'flows', 'admin'),
    	('GET', 'flows', 'user'),
    	('POST', 'flows', 'user'),
    	('GET', 'auth/user', 'admin'),
    	('POST', 'auth/user', 'admin');"
fi

echo "PEP-WS environment is Ok!"
