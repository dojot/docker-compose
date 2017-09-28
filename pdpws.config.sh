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

  echo "Creating index subject_idx"
  $PSQL --host=$ipPostgres --port=5432 --username=postgres --dbname=dojot -c 'CREATE INDEX subject_idx ON dojot_authorization."authorization" (accessSubject)'

  echo "Inserting PEP-WS policies..."
  $PSQL --host=$ipPostgres --port=5432 --username=postgres --dbname=dojot -c "insert into dojot_authorization.authorization
      (action, resource, accessSubject)
    values
    	('.*', '.*', 'admin'),
    	('.*', '/device.*', 'user'),
    	('.*', '/metric.*', 'user'),
    	('.*', '/template.*', 'user'),
      ('.*', '/history.*', 'user'),
    	('.*', '/flows.*', 'user');"
fi

echo "PEP-WS environment is Ok!"
