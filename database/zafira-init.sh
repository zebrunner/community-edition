#!/bin/bash

if [ $( psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -tAc "SELECT 1 FROM pg_namespace WHERE nspname = 'zafira'" ) == '1' ]; then
echo "Schema already exists"
exit 1
fi

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-structure.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-data.sql
