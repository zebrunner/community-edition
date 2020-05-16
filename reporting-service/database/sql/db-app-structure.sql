CREATE SCHEMA IF NOT EXISTS zafira;

SET SCHEMA 'zafira';


DROP FUNCTION IF EXISTS update_timestamp();
CREATE FUNCTION update_timestamp() RETURNS trigger AS
$update_timestamp$
BEGIN
  new.modified_at := current_timestamp;
  RETURN new;
END;
$update_timestamp$ LANGUAGE plpgsql;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL,
  username VARCHAR(100) NOT NULL,
  password VARCHAR(50) NULL DEFAULT '',
  email VARCHAR(100) NULL,
  first_name VARCHAR(100) NULL,
  last_name VARCHAR(100) NULL,
  last_login TIMESTAMP NULL,
  cover_photo_url TEXT NULL,
  source VARCHAR(20) NOT NULL DEFAULT 'INTERNAL',
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  reset_token VARCHAR(255) NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX username_unique ON users (username);
CREATE UNIQUE INDEX user_email_unique ON users (email) WHERE email IS NOT NULL;
CREATE TRIGGER update_timestamp_users
  BEFORE INSERT OR UPDATE
  ON users
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_suites;
CREATE TABLE IF NOT EXISTS test_suites (
  id SERIAL,
  name VARCHAR(200) NOT NULL,
  description TEXT NULL,
  file_name VARCHAR(255) NOT NULL DEFAULT '',
  user_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id)
);
CREATE UNIQUE INDEX name_file_user_unique ON test_suites (name, file_name, user_id);
CREATE INDEX fk_test_suite_user_asc ON test_suites (user_id);
CREATE TRIGGER update_timestamp_test_suits
  BEFORE INSERT OR UPDATE
  ON test_suites
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();



DROP TABLE IF EXISTS projects;
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  description TEXT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX name_unique ON projects (name);
CREATE TRIGGER update_timestamp_projects
  BEFORE INSERT OR UPDATE
  ON projects
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_cases;
CREATE TABLE IF NOT EXISTS test_cases (
  id SERIAL,
  test_class VARCHAR(255) NOT NULL,
  test_method VARCHAR(255) NOT NULL,
  info TEXT NULL,
  test_suite_id INT NOT NULL,
  primary_owner_id INT NOT NULL,
  secondary_owner_id INT NULL,
  project_id INT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'UNKNOWN',
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_suite_id) REFERENCES test_suites (id),
  FOREIGN KEY (primary_owner_id) REFERENCES users (id),
  FOREIGN KEY (secondary_owner_id) REFERENCES users (id),
  FOREIGN KEY (project_id) REFERENCES projects (id)
);
CREATE INDEX fk_test_case_suite_asc ON test_cases (test_suite_id);
CREATE INDEX fk_test_case_primary_owner_asc ON test_cases (primary_owner_id);
CREATE INDEX fk_test_case_secondary_owner_asc ON test_cases (secondary_owner_id);
CREATE INDEX fk_test_cases_projects_asc ON test_cases (project_id);
CREATE INDEX testcases_test_class_index ON test_cases (test_class);
CREATE INDEX testcases_test_method_index ON test_cases (test_method);
CREATE UNIQUE INDEX testcases_ownership_unique ON test_cases (primary_owner_id, test_class, test_method, project_id);
CREATE TRIGGER update_timestamp_test_cases
  BEFORE INSERT OR UPDATE
  ON test_cases
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS work_items;
CREATE TABLE IF NOT EXISTS work_items (
  id SERIAL,
  jira_id VARCHAR(45) NOT NULL,
  type VARCHAR(45) NOT NULL DEFAULT 'TASK',
  hash_code INT NULL,
  description TEXT NULL,
  user_id INT NULL,
  test_case_id INT NULL,
  known_issue BOOLEAN NOT NULL DEFAULT FALSE,
  blocker BOOLEAN NOT NULL DEFAULT FALSE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (test_case_id) REFERENCES test_cases (id)
);
CREATE UNIQUE INDEX work_item_unique ON work_items (jira_id, type, hash_code);
CREATE INDEX fk_work_item_user_asc ON work_items (user_id);
CREATE INDEX fk_work_item_test_case_asc ON work_items (test_case_id);
CREATE TRIGGER update_timestamp_work_items
  BEFORE INSERT OR UPDATE
  ON work_items
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();
CREATE INDEX work_items_created_at_index ON work_items (created_at);


DROP TABLE IF EXISTS integration_groups;
CREATE TABLE IF NOT EXISTS integration_groups (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  display_name VARCHAR(50) NOT NULL,
  icon_url VARCHAR(255) NOT NULL,
  multiple_allowed BOOLEAN NOT NULL DEFAULT FALSE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX integration_groups_name_unique ON integration_groups (name);
CREATE TRIGGER update_timestamp_integration_groups
  BEFORE INSERT OR UPDATE
  ON integration_groups
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS integration_types;
CREATE TABLE IF NOT EXISTS integration_types (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  display_name VARCHAR(50) NOT NULL,
  icon_url VARCHAR(255) NOT NULL,
  integration_group_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (integration_group_id) REFERENCES integration_groups (id)
);
CREATE UNIQUE INDEX integration_types_name_unique ON integration_types (name);
CREATE UNIQUE INDEX integration_types_display_name_unique ON integration_types (display_name);
CREATE TRIGGER update_timestamp_integration_types
  BEFORE INSERT OR UPDATE
  ON integration_types
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS integrations;
CREATE TABLE IF NOT EXISTS integrations (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  back_reference_id VARCHAR(50) NULL,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  enabled BOOLEAN NOT NULL DEFAULT FALSE,
  integration_type_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (integration_type_id) REFERENCES integration_types (id)
);
CREATE UNIQUE INDEX integrations_back_reference_unique ON integrations (back_reference_id);
CREATE UNIQUE INDEX integrations_integration_type_id_default_unique ON integrations (integration_type_id, is_default) WHERE is_default = TRUE;
CREATE TRIGGER update_timestamp_integrations
  BEFORE INSERT OR UPDATE
  ON integrations
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS integration_params;
CREATE TABLE IF NOT EXISTS integration_params (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  metadata TEXT NULL,
  default_value TEXT NULL,
  mandatory BOOLEAN NOT NULL DEFAULT FALSE,
  need_encryption BOOLEAN NOT NULL DEFAULT FALSE,
  integration_type_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (integration_type_id) REFERENCES integration_types (id)
);
CREATE UNIQUE INDEX integration_params_name_integration_type_id_unique ON integration_params (name, integration_type_id);
CREATE TRIGGER update_timestamp_integration_params
  BEFORE INSERT OR UPDATE
  ON integration_params
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS integration_settings;
CREATE TABLE IF NOT EXISTS integration_settings (
  id SERIAL,
  value TEXT NULL,
  binary_data BYTEA NULL,
  encrypted BOOLEAN NOT NULL DEFAULT FALSE,
  integration_id INT NOT NULL,
  integration_param_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (integration_id) REFERENCES integrations (id),
  FOREIGN KEY (integration_param_id) REFERENCES integration_params (id)
);
CREATE UNIQUE INDEX integration_settings_integration_param_id_integration_id_unique ON integration_settings (integration_param_id, integration_id);
CREATE TRIGGER update_timestamp_integration_settings
  BEFORE INSERT OR UPDATE
  ON integration_settings
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS jobs;
CREATE TABLE IF NOT EXISTS jobs (
  id SERIAL,
  user_id INT NULL,
  name VARCHAR(100) NOT NULL,
  job_url VARCHAR(255) NOT NULL,
  jenkins_host VARCHAR(255) NULL,
  automation_server_id INT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (automation_server_id) REFERENCES integrations (id)
);
CREATE UNIQUE INDEX job_url_unique ON jobs (job_url);
CREATE INDEX fk_jobs_users1_idx ON jobs (user_id);
CREATE TRIGGER update_timestamp_jobs
  BEFORE INSERT OR UPDATE
  ON jobs
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_configs;
CREATE TABLE IF NOT EXISTS test_configs (
  id SERIAL,
  url VARCHAR(512) NULL,
  env VARCHAR(50) NULL,
  platform VARCHAR(30) NULL,
  platform_version VARCHAR(30) NULL,
  browser VARCHAR(30) NULL,
  browser_version VARCHAR(30) NULL,
  app_version VARCHAR(255) NULL,
  locale VARCHAR(30) NULL,
  language VARCHAR(30) NULL,
  device VARCHAR(50) NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE TRIGGER update_timestamp_test_configs
  BEFORE INSERT OR UPDATE
  ON test_configs
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_runs;
CREATE TABLE IF NOT EXISTS test_runs (
  id SERIAL,
  ci_run_id VARCHAR(50) NULL,
  user_id INT,
  test_suite_id INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  scm_url VARCHAR(255) NULL,
  scm_branch VARCHAR(100) NULL,
  scm_commit VARCHAR(100) NULL,
  config_xml TEXT NULL,
  work_item_id INT NULL,
  job_id INT NOT NULL,
  build_number INT NOT NULL,
  started_by VARCHAR(45) NULL,
  upstream_job_id INT NULL,
  upstream_job_build_number INT NULL,
  project_id INT NULL,
  config_id INT NULL,
  known_issue BOOLEAN NOT NULL DEFAULT FALSE,
  blocker BOOLEAN NOT NULL DEFAULT FALSE,
  env VARCHAR(50) NULL,
  app_version VARCHAR(255) NULL,
  started_at TIMESTAMP NULL,
  elapsed INT NULL,
  eta INT NULL,
  comments TEXT NULL,
  channels VARCHAR(255) NULL,
  reviewed BOOLEAN NOT NULL DEFAULT FALSE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (test_suite_id) REFERENCES test_suites (id),
  FOREIGN KEY (work_item_id) REFERENCES work_items (id),
  FOREIGN KEY (job_id) REFERENCES jobs (id),
  FOREIGN KEY (upstream_job_id) REFERENCES jobs (id),
  FOREIGN KEY (project_id) REFERENCES projects (id),
  FOREIGN KEY (config_id) REFERENCES test_configs (id)
);
CREATE INDEX fk_test_run_user_asc ON test_runs (user_id);
CREATE INDEX fk_test_run_test_suite_asc ON test_runs (test_suite_id);
CREATE INDEX fk_test_runs_work_items1_idx ON test_runs (work_item_id);
CREATE INDEX fk_test_runs_jobs1_idx ON test_runs (job_id);
CREATE INDEX fk_test_runs_jobs2_idx ON test_runs (upstream_job_id);
CREATE INDEX fk_test_runs_projects1_idx ON test_runs (project_id);
CREATE INDEX test_runs_started_at_index ON test_runs (started_at ASC NULLS LAST);
CREATE UNIQUE INDEX ci_run_id_unique ON test_runs (ci_run_id);
CREATE TRIGGER update_timestamp_test_runs
  BEFORE INSERT OR UPDATE
  ON test_runs
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

DROP TABLE IF EXISTS test_run_artifacts;
CREATE TABLE IF NOT EXISTS test_run_artifacts (
id SERIAL,
name VARCHAR(255) NOT NULL,
link TEXT NOT NULL,
expires_at TIMESTAMP NULL,
test_run_id INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (test_run_id) REFERENCES test_runs (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_test_run_artifacts_test_runs_idx ON test_run_artifacts (test_run_id);
CREATE UNIQUE INDEX name_test_run_id_unique ON test_run_artifacts (name, test_run_id);

DROP TABLE IF EXISTS tests;
CREATE TABLE IF NOT EXISTS tests (
  id SERIAL,
  ci_test_id VARCHAR(50) NULL,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(20) NOT NULL,
  test_args TEXT NULL,
  test_run_id INT NOT NULL,
  test_case_id INT NOT NULL,
  test_group VARCHAR(255),
  message TEXT NULL,
  message_hash_code INT NULL,
  start_time TIMESTAMP NULL,
  finish_time TIMESTAMP NULL,
  retry INT NOT NULL DEFAULT 0,
  test_config_id INT NULL,
  known_issue BOOLEAN NOT NULL DEFAULT FALSE,
  blocker BOOLEAN NOT NULL DEFAULT FALSE,
  need_rerun BOOLEAN NOT NULL DEFAULT TRUE,
  depends_on_methods VARCHAR(255) NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_config_id) REFERENCES test_configs (id),
  FOREIGN KEY (test_run_id) REFERENCES test_runs (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (test_case_id) REFERENCES test_cases (id)
);
CREATE INDEX fk_tests_test_runs1_idx ON tests (test_run_id);
CREATE INDEX fk_tests_test_cases1_idx ON tests (test_case_id);
CREATE INDEX fk_tests_test_configs1_idx ON tests (test_config_id);
CREATE TRIGGER update_timestamp_tests
  BEFORE INSERT OR UPDATE
  ON tests
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS tags;
CREATE TABLE IF NOT EXISTS tags (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  value VARCHAR(255) NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX tags_unique ON tags (name, value);
CREATE INDEX tags_name ON tags (name);
CREATE INDEX tags_value ON tags (value);
CREATE TRIGGER update_timestamp_tags
  BEFORE INSERT OR UPDATE
  ON tags
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

DROP TABLE IF EXISTS test_tags;
CREATE TABLE IF NOT EXISTS test_tags (
  id SERIAL,
  test_id INT NOT NULL,
  tag_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_id) REFERENCES tests (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (tag_id) REFERENCES tags (id)
);
CREATE INDEX fk_tests_test_tags1_idx ON test_tags (test_id);
CREATE INDEX fk_tags_test_tags1_idx ON test_tags (tag_id);
CREATE UNIQUE INDEX test_tags_unique ON test_tags (tag_id, test_id);
CREATE TRIGGER update_timestamp_test_tags
  BEFORE INSERT OR UPDATE
  ON test_tags
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS user_preferences;
CREATE TABLE IF NOT EXISTS user_preferences (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  user_id INT,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE UNIQUE INDEX name_user_id_unique ON user_preferences (name, user_id);
CREATE TRIGGER update_timestamp_user_preferences
  BEFORE INSERT OR UPDATE
  ON user_preferences
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_artifacts;
CREATE TABLE IF NOT EXISTS test_artifacts (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  link TEXT NOT NULL,
  expires_at TIMESTAMP NULL,
  test_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_id) REFERENCES tests (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_test_artifacts_tests1_idx ON test_artifacts (test_id);
CREATE UNIQUE INDEX name_test_id_unique ON test_artifacts (name, test_id);
CREATE TRIGGER update_timestamp_test_artifacts
  BEFORE INSERT OR UPDATE
  ON test_artifacts
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();



DROP TABLE IF EXISTS test_work_items;
CREATE TABLE IF NOT EXISTS test_work_items (
  id SERIAL,
  test_id INT NOT NULL,
  work_item_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_id) REFERENCES tests (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (work_item_id) REFERENCES work_items (id)
);
CREATE UNIQUE INDEX test_work_item_test_id_work_item_id_unique ON test_work_items (test_id, work_item_id);
CREATE INDEX fk_test_work_items_tests1_idx ON test_work_items (test_id);
CREATE INDEX fk_test_work_items_work_items1_idx ON test_work_items (work_item_id);
CREATE TRIGGER update_timestamp_test_work_items
  BEFORE INSERT OR UPDATE
  ON test_work_items
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS test_metrics;
CREATE TABLE IF NOT EXISTS test_metrics (
  id SERIAL,
  operation VARCHAR(127) NOT NULL,
  elapsed BIGINT NOT NULL,
  test_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (test_id) REFERENCES tests (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_test_metrics_tests1_idx ON test_metrics (test_id);
CREATE INDEX test_operation ON test_metrics (operation);
CREATE TRIGGER update_timestamp_test_metrics
  BEFORE INSERT OR UPDATE
  ON test_metrics
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS settings;
CREATE TABLE IF NOT EXISTS settings (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  value TEXT NULL,
  is_encrypted BOOLEAN NULL DEFAULT FALSE,
  tool VARCHAR(255) NULL,
  file BYTEA NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX setting_unique ON settings (name);
CREATE TRIGGER update_timestamp_settings
  BEFORE INSERT OR UPDATE
  ON settings
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS widgets;
CREATE TABLE IF NOT EXISTS widgets (
  id SERIAL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL,
  params_config TEXT NULL,
  legend_config TEXT NULL,
  widget_template_id INT NULL,
  refreshable BOOLEAN NOT NULL DEFAULT FALSE NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  type VARCHAR(20) NULL,
  sql TEXT NULL,
  model TEXT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (widget_template_id) REFERENCES management.widget_templates (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE UNIQUE INDEX widgets_title_widget_template_id_uindex ON widgets (title, widget_template_id);
CREATE TRIGGER update_timestamp_widgets
  BEFORE INSERT OR UPDATE
  ON widgets
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS dashboards;
CREATE TABLE IF NOT EXISTS dashboards (
  id SERIAL,
  title VARCHAR(255) NOT NULL,
  hidden BOOLEAN NOT NULL DEFAULT FALSE,
  position INT NOT NULL DEFAULT 0,
  editable BOOLEAN NOT NULL DEFAULT TRUE,
  system BOOLEAN NOT NULL DEFAULT FALSE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE INDEX title_unique ON dashboards (title);
CREATE TRIGGER update_timestamp_dashboards
  BEFORE INSERT OR UPDATE
  ON dashboards
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS dashboards_widgets;
CREATE TABLE IF NOT EXISTS dashboards_widgets (
  id SERIAL,
  dashboard_id INT NOT NULL,
  widget_id INT NOT NULL,
  position INT NULL DEFAULT 0,
  size INT NULL DEFAULT 1,
  location VARCHAR(255) NOT NULL DEFAULT '',
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (dashboard_id) REFERENCES dashboards (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (widget_id) REFERENCES widgets (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_dashboards_widgets_dashboards1_idx ON dashboards_widgets (dashboard_id);
CREATE INDEX fk_dashboards_widgets_widgets1_idx ON dashboards_widgets (widget_id);
CREATE UNIQUE INDEX dashboard_widget_unique ON dashboards_widgets (dashboard_id, widget_id);
CREATE TRIGGER update_timestamp_dashboards_widgets
  BEFORE INSERT OR UPDATE
  ON dashboards_widgets
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS groups;
CREATE TABLE IF NOT EXISTS groups (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(255) NOT NULL,
  invitable BOOLEAN NOT NULL DEFAULT TRUE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX group_unique ON groups (name);
CREATE TRIGGER update_timestamp_groups
  BEFORE INSERT OR UPDATE
  ON groups
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS user_groups;
CREATE TABLE IF NOT EXISTS user_groups (
  id SERIAL,
  group_id INT NOT NULL,
  user_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (group_id) REFERENCES groups (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_user_groups_groups1_idx ON user_groups (group_id);
CREATE INDEX fk_user_groups_users1_idx ON user_groups (user_id);
CREATE UNIQUE INDEX user_group_unique ON user_groups (user_id, group_id);
CREATE TRIGGER update_timestamp_user_groups
  BEFORE INSERT OR UPDATE
  ON user_groups
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS permissions;
CREATE TABLE IF NOT EXISTS permissions (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  block VARCHAR(50) NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX permission_unique ON permissions (name);
CREATE TRIGGER update_timestamp_permissions
  BEFORE INSERT OR UPDATE
  ON permissions
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS group_permissions;
CREATE TABLE IF NOT EXISTS group_permissions (
  id SERIAL,
  group_id INT NOT NULL,
  permission_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (group_id) REFERENCES groups (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (permission_id) REFERENCES permissions (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_group_permissions_groups1_idx ON group_permissions (group_id);
CREATE INDEX fk_group_permissions_permissions1_idx ON group_permissions (permission_id);
CREATE UNIQUE INDEX group_permission_unique ON group_permissions (permission_id, group_id);
CREATE TRIGGER update_timestamp_group_premissions
  BEFORE INSERT OR UPDATE
  ON group_permissions
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS dashboard_attributes;
CREATE TABLE IF NOT EXISTS dashboard_attributes (
  id SERIAL,
  key VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  dashboard_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (dashboard_id) REFERENCES dashboards (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_dashboard_attributes_dashboards1_idx ON dashboard_attributes (dashboard_id);
CREATE UNIQUE INDEX dashboard_key_unique ON dashboard_attributes (key, dashboard_id);
CREATE TRIGGER update_timestamp_dashboard_attributes
  BEFORE INSERT OR UPDATE
  ON dashboard_attributes
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

DROP TABLE IF EXISTS invitations;
CREATE TABLE IF NOT EXISTS invitations (
  id SERIAL,
  email VARCHAR(50) NOT NULL,
  token VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL,
  user_id INT NOT NULL,
  group_id INT NOT NULL,
  source VARCHAR(20) NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (group_id) REFERENCES groups (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE INDEX fk_invitations_users1_idx ON invitations (user_id);
CREATE INDEX fk_invitations_groups1_idx ON invitations (group_id);
CREATE UNIQUE INDEX email_unique ON invitations (email);
CREATE UNIQUE INDEX token_unique ON invitations (token);
CREATE TRIGGER update_timestamp_invitations
  BEFORE INSERT OR UPDATE
  ON invitations
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS filters;

CREATE TABLE IF NOT EXISTS filters (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  description TEXT NULL,
  subject TEXT NOT NULL,
  public_access BOOLEAN NOT NULL DEFAULT FALSE,
  user_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX filters_name_public_unique ON filters (name) WHERE public_access = TRUE;
CREATE UNIQUE INDEX filters_name_user_id_public_access_private_unique ON filters (name, user_id, public_access) WHERE public_access = FALSE;
CREATE TRIGGER update_timestamp_filters
  BEFORE INSERT OR UPDATE
  ON filters
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS scm;

CREATE TABLE IF NOT EXISTS scm (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  login VARCHAR(255) NULL,
  access_token VARCHAR(255) NOT NULL,
  organization VARCHAR(255) NULL,
  repo VARCHAR(255) NULL,
  repository_url VARCHAR(255) NULL,
  user_id INT NULL,
  avatar_url VARCHAR(255) NULL,
  api_version VARCHAR(255) NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
CREATE TRIGGER update_timestamp_scm
  BEFORE INSERT OR UPDATE
  ON scm
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS launchers;

CREATE TABLE IF NOT EXISTS launchers (
  id SERIAL,
  name VARCHAR(255) NOT NULL,
  model TEXT NOT NULL,
  scm_id INT NOT NULL,
  job_id INT NULL,
  type VARCHAR(50),
  auto_scan BOOLEAN NOT NULL DEFAULT FALSE,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (scm_id) REFERENCES scm (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (job_id) REFERENCES jobs (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
CREATE TRIGGER update_timestamp_launchers
  BEFORE INSERT OR UPDATE
  ON launchers
  FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS launcher_presets;
CREATE TABLE IF NOT EXISTS launcher_presets (
    id SERIAL,
    name VARCHAR(50) NOT NULL,
    reference VARCHAR(20) NOT NULL,
    params TEXT NULL,
    launcher_id INT NOT NULL,
    provider_id INT NOT NULL,
    modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    PRIMARY KEY (id),
    CONSTRAINT fk_LAUNCHER_PRESET_LAUNCHERS1
        FOREIGN KEY (launcher_id)
            REFERENCES LAUNCHERS (id)
            ON DELETE CASCADE
            ON UPDATE NO ACTION,
    CONSTRAINT fk_LAUNCHER_PRESET_INTEGRATIONS1
        FOREIGN KEY (provider_id)
            REFERENCES INTEGRATIONS (id)
            ON DELETE CASCADE
            ON UPDATE NO ACTION);
CREATE UNIQUE INDEX LAUNCHER_PRESET_LAUNCHER_ID_NAME_UNIQUE ON launcher_presets (name, launcher_id);
CREATE UNIQUE INDEX LAUNCHER_PRESET_REFERENCE_UNIQUE ON launcher_presets (reference);
CREATE TRIGGER update_timestamp_launcher_presets BEFORE INSERT OR UPDATE ON launcher_presets FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS launcher_callbacks;
CREATE TABLE IF NOT EXISTS launcher_callbacks (
  id SERIAL,
  ci_run_id VARCHAR(50) NOT NULL,
  url VARCHAR(255) NOT NULL,
  reference VARCHAR(20) NOT NULL,
  launcher_preset_id INT NOT NULL,
  modified_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  CONSTRAINT fk_LAUNCHER_CALLBACK_LAUNCHER_PRESETS1
      FOREIGN KEY (launcher_preset_id)
          REFERENCES LAUNCHER_PRESETS (ID)
          ON DELETE CASCADE
          ON UPDATE NO ACTION);
CREATE UNIQUE INDEX LAUNCHER_CALLBACK_CI_RUN_ID_UNIQUE ON launcher_callbacks (ci_run_id);
CREATE UNIQUE INDEX LAUNCHER_CALLBACK_REFERENCE_UNIQUE ON launcher_callbacks (reference);
CREATE TRIGGER update_timestamp_launcher_callback BEFORE INSERT OR UPDATE ON launcher_callbacks FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


CREATE TABLE IF NOT EXISTS user_launcher_preferences (
    id SERIAL,
    user_id INT NOT NULL,
    launcher_id INT NOT NULL,
    favorite BOOLEAN NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    FOREIGN KEY (launcher_id) REFERENCES launchers (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION);
CREATE UNIQUE INDEX USER_LAUNCHER_PREFERENCES_USER_ID_LAUNCHER_ID_UNIQUE ON user_launcher_preferences (user_id, launcher_id);


DROP TABLE IF EXISTS test_sessions;
CREATE TABLE test_sessions (
   id SERIAL,
   session_id VARCHAR(255) NOT NULL,
   version VARCHAR(255) NOT NULL,
   started_at TIMESTAMP NOT NULL,
   ended_at TIMESTAMP NULL,
   duration INT NULL,
   os_name VARCHAR(255) NOT NULL,
   browser_name VARCHAR(255) NOT NULL,
   test_name VARCHAR(255) NULL,
   build_number VARCHAR(255) NULL,
   status VARCHAR(20) NOT NULL,
   modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id)
);
CREATE TRIGGER update_timestamp_test_sessions BEFORE INSERT OR UPDATE ON test_sessions FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


CREATE OR REPLACE FUNCTION check_version(INTEGER) RETURNS VOID AS
$$
DECLARE
  current_version settings.value%TYPE;
BEGIN
  current_version := (SELECT VALUE FROM settings WHERE name = 'LAST_ALTER_VERSION');
  IF (SELECT to_number(current_version, '9999') + 1 != $1 AND current_version != '0') THEN
    RAISE EXCEPTION 'Alter table can not be executed. Expected version is "%". Actual version is "%".', to_number(current_version, '9999') + 1, $1;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_version(INT) RETURNS VOID AS
$$
DECLARE
  current_version settings.value%TYPE;
BEGIN
  current_version := to_char($1, '9999');
  UPDATE settings SET value = current_version WHERE name = 'LAST_ALTER_VERSION';
END;
$$ LANGUAGE plpgsql;
