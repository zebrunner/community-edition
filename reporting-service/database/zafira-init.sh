#!/bin/bash
if [ $( psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -tAc "SELECT 1 FROM pg_namespace WHERE nspname = 'zafira'" ) == '1' ];
then
echo "Schema already exists"
exit 1
fi
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-mng-structure.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-mng-data.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-app-structure.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-app-state-management.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-app-data.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-views.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-views-cron.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-widgets.sql

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER \
	-v RABBITMQ_ENABLED='true' -v RABBITMQ_HOST="'${RABBITMQ_HOST}'" -v RABBITMQ_PORT="'${RABBITMQ_PORT}'" -v RABBITMQ_USERNAME="'${RABBITMQ_USERNAME}'" -v RABBITMQ_PASSWORD="'${RABBITMQ_PASSWORD}'" \
        -v JENKINS_ENABLED='true' -v JENKINS_URL="'http://jenkins-master:8080/jenkins'" -v JENKINS_USER="'admin'" -v JENKINS_PASSWORD="'changeit'" -v JENKINS_FOLDER='NULL' -v JENKINS_JOB_URL_VISIBILITY='true' \
	-v S3_ENABLED='false' -v S3_BUCKET='NULL' -v S3_ACCESS_KEY='NULL' -v S3_SECRET_KEY='NULL' -v S3_REGION='NULL' \
	-v SELENIUM_ENABLED='true' -v SELENIUM_URL="'http://nginx/selenoid/wd/hub'" -v SELENIUM_USER="'demo'" -v SELENIUM_PASSWORD="'demo'" \
	-f /docker-entrypoint-initdb.d/sql/db-integrations.sql
