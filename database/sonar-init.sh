#!/bin/bash

if [ $( psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -tAc "SELECT 1 FROM pg_database WHERE datname = 'sonar'" ) == '1' ]; then
echo "Database already exists"
exit 1
fi

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -c "CREATE DATABASE sonar"
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -c "GRANT ALL PRIVILEGES ON DATABASE sonar TO postgres"
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/sonarqube.sql sonar
