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
 );
