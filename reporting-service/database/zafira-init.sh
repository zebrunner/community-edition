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

if [ "$ZAFIRA_AMAZON_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='AMAZON';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_AMAZON_BUCKET' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AMAZON_BUCKET';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_AMAZON_ACCESS_KEY' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AMAZON_ACCESS_KEY';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_AMAZON_SECRET_KEY' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AMAZON_SECRET_KEY';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_AMAZON_REGION' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AMAZON_REGION';"
fi

if [ "$ZAFIRA_JENKINS_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='JENKINS';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_JENKINS_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='JENKINS_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_JENKINS_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='JENKINS_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_JENKINS_API_TOKEN_OR_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='JENKINS_API_TOKEN_OR_PASSWORD';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_JENKINS_FOLDER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='JENKINS_FOLDER';"
fi

if [ "$ZAFIRA_EMAIL_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='EMAIL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_EMAIL_HOST' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='EMAIL_HOST';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_EMAIL_PORT' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='EMAIL_PORT';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_EMAIL_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='EMAIL_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_EMAIL_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='EMAIL_PASSWORD';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZAFIRA_EMAIL_FROM_ADDRESS' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='EMAIL_FROM_ADDRESS';"
fi

if [ "$RABBITMQ_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='RABBITMQ';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$RABBITMQ_HOST' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='RABBITMQ_HOST';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$RABBITMQ_PORT' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='RABBITMQ_PORT';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$RABBITMQ_USERNAME' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='RABBITMQ_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$RABBITMQ_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='RABBITMQ_PASSWORD';"
fi

if [ "$ZEBRUNNER_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='ZEBRUNNER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZEBRUNNER_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='ZEBRUNNER_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZEBRUNNER_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='ZEBRUNNER_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$ZEBRUNNER_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='ZEBRUNNER_PASSWORD';"
fi

if [ "$SELENIUM_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='SELENIUM';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SELENIUM_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SELENIUM_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SELENIUM_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SELENIUM_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SELENIUM_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SELENIUM_PASSWORD';"
fi

if [ "$MCLOUD_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='MCLOUD';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$MCLOUD_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='MCLOUD_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$MCLOUD_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='MCLOUD_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$MCLOUD_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='MCLOUD_PASSWORD';"
fi

if [ "$AEROKUBE_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='AEROKUBE';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$AEROKUBE_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AEROKUBE_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$AEROKUBE_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AEROKUBE_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$AEROKUBE_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='AEROKUBE_PASSWORD';"
fi

if [ "$BROWSERSTACK_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='BROWSERSTACK';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$BROWSERSTACK_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='BROWSERSTACK_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$BROWSERSTACK_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='BROWSERSTACK_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$BROWSERSTACK_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='BROWSERSTACK_ACCESS_KEY';"
fi

if [ "$SAUCELABS_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "update zafira.integrations set enabled='true' where zafira.integrations.name='SAUCELABS';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SAUCELABS_URL' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SAUCELABS_URL';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SAUCELABS_USER' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SAUCELABS_USER';"
    psql --username $POSTGRES_USER -c "update zafira.integration_settings set value='$SAUCELABS_PASSWORD' from zafira.integration_params where integration_settings.integration_param_id=integration_params.id and integration_params.name='SAUCELABS_PASSWORD';"
fi
