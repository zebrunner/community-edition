SET SCHEMA 'zafira';

DROP TABLE IF EXISTS databasechangelog;
CREATE TABLE databasechangelog (
  id VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  filename VARCHAR(255) NOT NULL,
  dateexecuted TIMESTAMP NOT NULL,
  orderexecuted INT NOT NULL,
  exectype VARCHAR(10) NOT NULL,
  md5sum VARCHAR(35),
  description VARCHAR(255),
  comments VARCHAR(255),
  tag VARCHAR(255),
  liquibase VARCHAR(20),
  contexts VARCHAR(255),
  labels VARCHAR(255),
  deployment_id VARCHAR(10)
);

DROP TABLE IF EXISTS databasechangeloglock;
CREATE TABLE databasechangeloglock (
    id INT NOT NULL,
    locked BOOLEAN NOT NULL,
    lockgranted TIMESTAMP,
    lockedby VARCHAR(255),
    PRIMARY KEY (id)
);

INSERT INTO databasechangelog(
  id,
  author,
  filename,
  dateexecuted,
  orderexecuted,
  exectype
) VALUES (
  '001_create_integrations_structure',
  'brutskov',
  'classpath:db/changelog.yml',
  current_timestamp,
  1,
  'EXECUTED'
),
 (
     '002_create_launcher_snapshot_table',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '003_add_jenkins_view_links_setting',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '004_add_launcher_type_column',
     'itsvirko',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '005_add_test_environment_provider_integrations',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '006_add_project_to_test_cases_unique_key',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '007_drop_tests_test_runs_fk',
     'nsidorevich',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '008_add_autovacuum',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '009_update_manual_launchers',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '010_add_lambda_test_integration',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '011_remove_google_integration',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '012_test_sessions_tracking_table',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '013_add_test_session_status_column',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '014_add_launcher_presets_launchers_on_delete',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '015_add_default_runs_view_preference',
     'itsvirko',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '016_add_test_sessions_permissions',
     'itsvirko',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '017_add_test_run_artifacts_table',
     'itsvirko',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '018_remove_views_table',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '019_user_launcher_preferences_table',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '020_add_system_column_dashboards_table',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '021_add_test_environment_provider_column',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '022_add_microsoft_teams_integration',
     'itsvirko',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '023_adjust_work_items_indices',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
(
     '024_system_dashboards_update',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '025_add_registration_additional_info',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 ),
 (
     '026_adjust_smtp_integration_parameters',
     'brutskov',
     'classpath:db/changelog.yml',
     current_timestamp,
     1,
     'EXECUTED'
 );