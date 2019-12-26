ALTER TABLE dashboard_attributes SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE dashboard_attributes SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE dashboard_attributes SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE dashboard_attributes SET (autovacuum_analyze_threshold = 100);

ALTER TABLE dashboards SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE dashboards SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE dashboards SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE dashboards SET (autovacuum_analyze_threshold = 100);

ALTER TABLE dashboards_widgets SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE dashboards_widgets SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE dashboards_widgets SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE dashboards_widgets SET (autovacuum_analyze_threshold = 100);

ALTER TABLE databasechangelog SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE databasechangelog SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE databasechangelog SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE databasechangelog SET (autovacuum_analyze_threshold = 100);

ALTER TABLE databasechangeloglock SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE databasechangeloglock SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE databasechangeloglock SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE databasechangeloglock SET (autovacuum_analyze_threshold = 100);

ALTER TABLE filters SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE filters SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE filters SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE filters SET (autovacuum_analyze_threshold = 100);

ALTER TABLE group_permissions SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE group_permissions SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE group_permissions SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE group_permissions SET (autovacuum_analyze_threshold = 100);

ALTER TABLE groups SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE groups SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE groups SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE groups SET (autovacuum_analyze_threshold = 100);

ALTER TABLE integration_groups SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE integration_groups SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE integration_groups SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE integration_groups SET (autovacuum_analyze_threshold = 100);

ALTER TABLE integration_params SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE integration_params SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE integration_params SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE integration_params SET (autovacuum_analyze_threshold = 100);

ALTER TABLE integration_settings SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE integration_settings SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE integration_settings SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE integration_settings SET (autovacuum_analyze_threshold = 100);

ALTER TABLE integration_types SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE integration_types SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE integration_types SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE integration_types SET (autovacuum_analyze_threshold = 100);

ALTER TABLE integrations SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE integrations SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE integrations SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE integrations SET (autovacuum_analyze_threshold = 100);

ALTER TABLE invitations SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE invitations SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE invitations SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE invitations SET (autovacuum_analyze_threshold = 100);

ALTER TABLE job_views SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE job_views SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE job_views SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE job_views SET (autovacuum_analyze_threshold = 100);

ALTER TABLE jobs SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE jobs SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE jobs SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE jobs SET (autovacuum_analyze_threshold = 100);

ALTER TABLE launcher_callbacks SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE launcher_callbacks SET (autovacuum_vacuum_threshold = 1000);
ALTER TABLE launcher_callbacks SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE launcher_callbacks SET (autovacuum_analyze_threshold = 1000);

ALTER TABLE launcher_presets SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE launcher_presets SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE launcher_presets SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE launcher_presets SET (autovacuum_analyze_threshold = 100);

ALTER TABLE launchers SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE launchers SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE launchers SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE launchers SET (autovacuum_analyze_threshold = 100);

ALTER TABLE permissions SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE permissions SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE permissions SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE permissions SET (autovacuum_analyze_threshold = 100);

ALTER TABLE projects SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE projects SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE projects SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE projects SET (autovacuum_analyze_threshold = 100);

ALTER TABLE scm SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE scm SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE scm SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE scm SET (autovacuum_analyze_threshold = 100);

ALTER TABLE settings SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE settings SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE settings SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE settings SET (autovacuum_analyze_threshold = 100);

ALTER TABLE tags SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE tags SET (autovacuum_vacuum_threshold = 1000);
ALTER TABLE tags SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE tags SET (autovacuum_analyze_threshold = 1000);

ALTER TABLE test_artifacts SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_artifacts SET (autovacuum_vacuum_threshold = 100000);
ALTER TABLE test_artifacts SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_artifacts SET (autovacuum_analyze_threshold = 100000);

ALTER TABLE test_cases SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_cases SET (autovacuum_vacuum_threshold = 1000);
ALTER TABLE test_cases SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_cases SET (autovacuum_analyze_threshold = 1000);

ALTER TABLE test_configs SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_configs SET (autovacuum_vacuum_threshold = 10000);
ALTER TABLE test_configs SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_configs SET (autovacuum_analyze_threshold = 10000);

ALTER TABLE test_metrics SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_metrics SET (autovacuum_vacuum_threshold = 100000);
ALTER TABLE test_metrics SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_metrics SET (autovacuum_analyze_threshold = 100000);

ALTER TABLE test_runs SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_runs SET (autovacuum_vacuum_threshold = 10000);
ALTER TABLE test_runs SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_runs SET (autovacuum_analyze_threshold = 10000);

ALTER TABLE test_suites SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_suites SET (autovacuum_vacuum_threshold = 1000);
ALTER TABLE test_suites SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_suites SET (autovacuum_analyze_threshold = 1000);

ALTER TABLE test_tags SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_tags SET (autovacuum_vacuum_threshold = 100000);
ALTER TABLE test_tags SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_tags SET (autovacuum_analyze_threshold = 100000);

ALTER TABLE test_work_items SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE test_work_items SET (autovacuum_vacuum_threshold = 10000);
ALTER TABLE test_work_items SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE test_work_items SET (autovacuum_analyze_threshold = 10000);

ALTER TABLE tests SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE tests SET (autovacuum_vacuum_threshold = 100000);
ALTER TABLE tests SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE tests SET (autovacuum_analyze_threshold = 100000);

ALTER TABLE user_groups SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE user_groups SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE user_groups SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE user_groups SET (autovacuum_analyze_threshold = 100);

ALTER TABLE user_preferences SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE user_preferences SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE user_preferences SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE user_preferences SET (autovacuum_analyze_threshold = 100);

ALTER TABLE users SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE users SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE users SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE users SET (autovacuum_analyze_threshold = 100);

ALTER TABLE views SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE views SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE views SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE views SET (autovacuum_analyze_threshold = 100);

ALTER TABLE widgets SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE widgets SET (autovacuum_vacuum_threshold = 100);
ALTER TABLE widgets SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE widgets SET (autovacuum_analyze_threshold = 100);

ALTER TABLE work_items SET (autovacuum_vacuum_scale_factor = 0.0);
ALTER TABLE work_items SET (autovacuum_vacuum_threshold = 10000);
ALTER TABLE work_items SET (autovacuum_analyze_scale_factor = 0.0);
ALTER TABLE work_items SET (autovacuum_analyze_threshold = 10000);