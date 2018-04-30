INSERT INTO zafira.SETTINGS (NAME, VALUE, TOOL) VALUES
	('JIRA_CLOSED_STATUS', 'CLOSED', 'JIRA'),
	('JIRA_URL', '', 'JIRA'),
	('JIRA_USER', '', 'JIRA'),
	('JIRA_PASSWORD', '', 'JIRA'),
	('JIRA_ENABLED', false, 'JIRA'),
	('JENKINS_URL', 'http://demo.qaprosoft.com/jenkins', 'JENKINS'),
	('JENKINS_USER', 'admin', 'JENKINS'),
	('JENKINS_API_TOKEN_OR_PASSWORD', 'changeit', 'JENKINS'),
	('JENKINS_ENABLED', true, 'JENKINS'),
	('SLACK_WEB_HOOK_URL', '', 'SLACK'),
	('SLACK_ENABLED', false, 'SLACK'),
	('EMAIL_HOST', '', 'EMAIL'),
	('EMAIL_PORT', '', 'EMAIL'),
	('EMAIL_USER', '', 'EMAIL'),
	('EMAIL_PASSWORD', '', 'EMAIL'),
	('EMAIL_ENABLED', false, 'EMAIL'),
	('AMAZON_ACCESS_KEY', '', 'AMAZON'),
	('AMAZON_SECRET_KEY', '', 'AMAZON'),
	('AMAZON_BUCKET', 'zafira', 'AMAZON'),
	('AMAZON_ENABLED', true, 'AMAZON'),
	('HIPCHAT_ACCESS_TOKEN', '', 'HIPCHAT'),
	('HIPCHAT_ENABLED', false, 'HIPCHAT'),
	('KEY', '', 'CRYPTO'),
	('CRYPTO_KEY_SIZE', '128', 'CRYPTO'),
	('CRYPTO_KEY_TYPE', 'AES', 'CRYPTO'),
	('RABBITMQ_HOST', 'demo.qaprosoft.com', 'RABBITMQ'),
	('RABBITMQ_PORT', '5672', 'RABBITMQ'),
	('RABBITMQ_USER', 'qpsdemo', 'RABBITMQ'),
	('RABBITMQ_PASSWORD', 'qpsdemo', 'RABBITMQ'),
	('RABBITMQ_WS', 'http://demo.qaprosoft.com/stomp', 'RABBITMQ'),
	('RABBITMQ_ENABLED', true, 'RABBITMQ'),
	('COMPANY_LOGO_URL', null, null),
	('LAST_ALTER_VERSION', '0', null);

INSERT INTO zafira.PROJECTS (NAME, DESCRIPTION) VALUES ('UNKNOWN', '');


DO $$
DECLARE GROUP_ID zafira.GROUP_PERMISSIONS.id%TYPE;
DECLARE USER_ID zafira.USER_PREFERENCES.id%TYPE;

BEGIN

	INSERT INTO zafira.PERMISSIONS (NAME, BLOCK) VALUES
				('VIEW_HIDDEN_DASHBOARDS', 'DASHBOARDS'),
				('MODIFY_DASHBOARDS', 'DASHBOARDS'),
				('MODIFY_WIDGETS', 'DASHBOARDS'),
				('MODIFY_TEST_RUN_VIEWS', 'TEST_RUNS'),
				('MODIFY_TEST_RUNS', 'TEST_RUNS'),
				('TEST_RUNS_CI', 'TEST_RUNS'),
				('MODIFY_TESTS', 'TEST_RUNS'),
				('MODIFY_USERS', 'USERS'),
				('MODIFY_USER_GROUPS', 'USERS'),
				('VIEW_USERS', 'USERS'),
				('MODIFY_SETTINGS', 'SETTINGS'),
				('VIEW_SETTINGS', 'SETTINGS'),
				('MODIFY_MONITORS', 'MONITORS'),
				('VIEW_MONITORS', 'MONITORS'),
				('MODIFY_PROJECTS', 'PROJECTS'),
				('MODIFY_INTEGRATIONS', 'INTEGRATIONS'),
				('VIEW_INTEGRATIONS', 'INTEGRATIONS');

	INSERT INTO zafira.GROUPS (NAME, ROLE) VALUES ('Super users', 'ROLE_USER') RETURNING id INTO GROUP_ID;

  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 4);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 5);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 6);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 7);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 12);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 14);

	INSERT INTO zafira.GROUPS (NAME, ROLE) VALUES ('Users', 'ROLE_USER') RETURNING id INTO GROUP_ID;

  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 6);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 7);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 14);

	INSERT INTO zafira.GROUPS (NAME, ROLE) VALUES ('Super admins', 'ROLE_ADMIN') RETURNING id INTO GROUP_ID;

	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 1);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 2);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 3);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 4);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 5);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 6);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 7);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 8);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 9);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 10);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 11);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 12);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 13);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 14);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 15);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 16);
	INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 17);

  INSERT INTO zafira.GROUPS (NAME, ROLE) VALUES ('Admins', 'ROLE_ADMIN') RETURNING id INTO GROUP_ID;

  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 1);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 2);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 3);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 4);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 5);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 6);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 7);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 8);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 10);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 12);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 13);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 14);
  INSERT INTO zafira.GROUP_PERMISSIONS (GROUP_ID, PERMISSION_ID) VALUES (GROUP_ID, 15);

	INSERT INTO zafira.users (USERNAME) VALUES ('anonymous') RETURNING id INTO USER_ID;

	INSERT INTO zafira.user_preferences (NAME, VALUE, USER_ID) VALUES
		('REFRESH_INTERVAL', '0', USER_ID),
		('DEFAULT_DASHBOARD', 'General', USER_ID),
		('THEME', '32', USER_ID);

END$$;

DO $$

-- Declare dashboards
DECLARE personal_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE user_performance_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE general_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE monthly_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE weekly_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE nightly_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE failures_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE stability_dashboard_id zafira.DASHBOARDS.id%TYPE;

-- Declare Stability dashboard widgets
DECLARE average_stability_percent_id zafira.WIDGETS.id%TYPE;
DECLARE average_stability_percent_sql zafira.WIDGETS.sql%TYPE;
DECLARE average_stability_percent_model zafira.WIDGETS.model%TYPE;
DECLARE test_case_info_id zafira.WIDGETS.id%TYPE;
DECLARE test_case_info_sql zafira.WIDGETS.sql%TYPE;
DECLARE test_case_info_model zafira.WIDGETS.model%TYPE;
DECLARE stability_trend_id zafira.WIDGETS.id%TYPE;
DECLARE stability_trend_sql zafira.WIDGETS.sql%TYPE;
DECLARE stability_trend_model zafira.WIDGETS.model%TYPE;
DECLARE test_execution_time_id zafira.WIDGETS.id%TYPE;
DECLARE test_execution_time_sql zafira.WIDGETS.sql%TYPE;
DECLARE test_execution_time_model zafira.WIDGETS.model%TYPE;


-- Declare Failures dashboard widgets
DECLARE error_message_id zafira.WIDGETS.id%TYPE;
DECLARE error_message_sql zafira.WIDGETS.sql%TYPE;
DECLARE error_message_model zafira.WIDGETS.model%TYPE;
DECLARE detailed_failures_report_id zafira.WIDGETS.id%TYPE;
DECLARE detailed_failures_report_sql zafira.WIDGETS.sql%TYPE;
DECLARE detailed_failures_report_model zafira.WIDGETS.model%TYPE;
DECLARE failures_count_id zafira.WIDGETS.id%TYPE;
DECLARE failures_count_sql zafira.WIDGETS.sql%TYPE;
DECLARE failures_count_model zafira.WIDGETS.model%TYPE;

-- Declare Personal dashboard widgets
DECLARE nightly_details_personal_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_details_personal_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_details_personal_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_total_personal_pie_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_total_personal_pie_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_total_personal_pie_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_total_personal_table_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_total_personal_table_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_total_personal_table_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_total_personal_table_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_total_personal_table_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_total_personal_table_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_total_personal_pie_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_total_personal_pie_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_total_personal_pie_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_total_personal_pie_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_total_personal_pie_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_total_personal_pie_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_total_personal_table_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_total_personal_table_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_total_personal_table_model zafira.WIDGETS.model%TYPE;
DECLARE total_last_30_days_personal_id zafira.WIDGETS.id%TYPE;
DECLARE total_last_30_days_personal_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_last_30_days_personal_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_personal_failures_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_personal_failures_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_personal_failures_model zafira.WIDGETS.model%TYPE;

	-- Declare User Performance dashboard widgets
DECLARE personal_total_rate_id zafira.WIDGETS.id%TYPE;
DECLARE personal_total_rate_sql zafira.WIDGETS.sql%TYPE;
DECLARE personal_total_rate_model zafira.WIDGETS.model%TYPE;
DECLARE personal_total_tests_man_hours_id zafira.WIDGETS.id%TYPE;
DECLARE personal_total_tests_man_hours_sql zafira.WIDGETS.sql%TYPE;
DECLARE personal_total_tests_man_hours_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_test_impl_progress_user_perf_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_test_impl_progress_user_perf_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_test_impl_progress_user_perf_model zafira.WIDGETS.model%TYPE;
DECLARE total_tests_trend_id zafira.WIDGETS.id%TYPE;
DECLARE total_tests_trend_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_tests_trend_model zafira.WIDGETS.model%TYPE;

-- Declare General dashboard widgets
DECLARE total_tests_count_id zafira.WIDGETS.id%TYPE;
DECLARE total_tests_count_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_tests_count_model zafira.WIDGETS.model%TYPE;
DECLARE total_tests_pie_id zafira.WIDGETS.id%TYPE;
DECLARE total_tests_pie_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_tests_pie_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_test_impl_progress_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_test_impl_progress_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_test_impl_progress_model zafira.WIDGETS.model%TYPE;
DECLARE total_jira_tickets_id zafira.WIDGETS.id%TYPE;
DECLARE total_jira_tickets_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_jira_tickets_model zafira.WIDGETS.model%TYPE;
DECLARE total_tests_man_hours_id zafira.WIDGETS.id%TYPE;
DECLARE total_tests_man_hours_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_tests_man_hours_model zafira.WIDGETS.model%TYPE;
DECLARE total_tests_by_month_id zafira.WIDGETS.id%TYPE;
DECLARE total_tests_by_month_sql zafira.WIDGETS.sql%TYPE;
DECLARE total_tests_by_month_model zafira.WIDGETS.model%TYPE;

-- Declare Monthly dashboard widgets
DECLARE monthly_total_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_total_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_total_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_total_percent_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_total_percent_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_total_percent_model zafira.WIDGETS.model%TYPE;
DECLARE test_results_30_id zafira.WIDGETS.id%TYPE;
DECLARE test_results_30_sql zafira.WIDGETS.sql%TYPE;
DECLARE test_results_30_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_jira_tickets_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_jira_tickets_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_jira_tickets_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_platform_details_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_platform_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_platform_details_model zafira.WIDGETS.model%TYPE;
DECLARE monthly_details_id zafira.WIDGETS.id%TYPE;
DECLARE monthly_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE monthly_details_model zafira.WIDGETS.model%TYPE;

-- Declare Weekly dashboard widgets
DECLARE weekly_total_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_total_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_total_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_total_percent_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_total_percent_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_total_percent_model zafira.WIDGETS.model%TYPE;
DECLARE test_results_7_id zafira.WIDGETS.id%TYPE;
DECLARE test_results_7_sql zafira.WIDGETS.sql%TYPE;
DECLARE test_results_7_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_platform_details_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_platform_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_platform_details_model zafira.WIDGETS.model%TYPE;
DECLARE weekly_details_id zafira.WIDGETS.id%TYPE;
DECLARE weekly_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE weekly_details_model zafira.WIDGETS.model%TYPE;

-- Declare Nightly dashboard widgets
DECLARE nightly_total_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_total_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_total_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_total_percent_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_total_percent_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_total_percent_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_platform_details_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_platform_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_platform_details_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_details_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_details_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_details_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_regression_date_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_regression_date_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_regression_date_model zafira.WIDGETS.model%TYPE;
DECLARE nightly_failures_id zafira.WIDGETS.id%TYPE;
DECLARE nightly_failures_sql zafira.WIDGETS.sql%TYPE;
DECLARE nightly_failures_model zafira.WIDGETS.model%TYPE;

BEGIN
	-- Insert Stability dashboard data

  INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Stability', FALSE, 8) RETURNING id INTO stability_dashboard_id;

	average_stability_percent_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''STABILITY'', ''FAILURE'', ''OMISSION'', ''KNOWN FAILURE'', ''INTERRUPT'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[ROUND(AVG(STABILITY)::numeric, 0),
                     ROUND(AVG(FAILURE)::numeric, 0),
                     ROUND(AVG(OMISSION)::numeric, 0),
                     ROUND(AVG(KNOWN_FAILURE)::numeric, 0),
                     ROUND(AVG(INTERRUPT)::numeric, 0)]) AS "value"
    FROM TEST_CASE_HEALTH_VIEW
    WHERE
        TEST_CASE_ID = ''#{testCaseId}''
    ORDER BY "value" DESC';

	average_stability_percent_model :=
	'{
        "thickness": 20
     }';

	test_case_info_sql :=
	'SET SCHEMA ''zafira'';
     SELECT
     TEST_CASES.ID AS "ID",
     TEST_CASES.TEST_CLASS AS "TEST CLASS",
     TEST_CASES.TEST_METHOD AS "TEST METHOD",
     TEST_SUITES.FILE_NAME AS "TEST SUITE",
     USERS.USERNAME AS "OWNER",
     TEST_CASES.CREATED_AT::date AS "CREATED AT"
     FROM TEST_CASES
     LEFT JOIN TEST_SUITES ON TEST_CASES.TEST_SUITE_ID = TEST_SUITES.ID
     LEFT JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID = USERS.ID
 WHERE TEST_CASES.ID = ''#{testCaseId}''';

	test_case_info_model :=
	'{
         "columns": [
             "ID",
             "TEST CLASS",
             "TEST METHOD",
             "TEST SUITE",
             "OWNER",
             "CREATED AT"
         ]
     }';

	stability_trend_sql :=
	'set schema ''zafira'';
    SELECT
        STABILITY as "STABILITY",
        100 - OMISSION - KNOWN_FAILURE - ABORTED as "FAILURE",
        100 - KNOWN_FAILURE - ABORTED as "OMISSION",
        date_trunc(''month'', TESTED_AT) AS "TESTED_AT"
    FROM TEST_CASE_HEALTH_VIEW
    WHERE TEST_CASE_ID = ''#{testCaseId}''
    ORDER BY "TESTED_AT"';

	stability_trend_model :=
	'{
        "series": [
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "OMISSION",
                "label": "OMISSION",
                "interpolation": {
                    "mode": "bundle",
                    "tension": 1
                },
                "color": "#FDE9B4",
                "thickness": "10px",
                "type": [
                    "line",
                    "area"
                ],
                "id": "OMISSION",
                "visible": true
            },
            {
                "dataset": "dataset",
                "key": "FAILURE",
                "label": "FAILURE",
                "interpolation": {
                    "mode": "bundle",
                    "tension": 1
                },
                "color": "#F2C3C0",
                "thickness": "10px",
                "type": [
                    "line",
                    "area"
                ],
                "id": "FAILURE",
                "visible": true
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "STABILITY",
                "label": "STABILITY",
                "interpolation": {
                    "mode": "bundle",
                    "tension": 1
                },
                "color": "#5CB85C",
                "thickness": "10px",
                "type": [
                    "line",
                    "area"
                ],
                "id": "STABILITY",
                "visible": true
            }
        ],
        "axes": {
            "x": {
                "key": "TESTED_AT",
                "type": "date"
            }
        }
    }';

	test_execution_time_sql :=
	'set schema ''zafira'';
    SELECT
        AVG_TIME as "AVG TIME",
        MAX_TIME as "MAX TIME",
        MIN_TIME as "MIN TIME",
        date_trunc(''month'', TESTED_AT) AS "TESTED_AT"
    FROM TEST_CASE_HEALTH_VIEW
    WHERE TEST_CASE_ID = ''#{testCaseId}''
    ORDER BY "TESTED_AT"';

	test_execution_time_model :=
	'{
        "series": [
            {
                "dataset": "dataset",
                "key": "MAX TIME",
                "label": "MAX TIME",
                "color": "#DC4437",
                "thickness": "20px",
                "type": [
                    "line",
                    "dot"
                ],
                "id": "MAX TIME",
                "visible": true
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "MIN TIME",
                "label": "MIN TIME",
                "color": "#5CB85C",
                "thickness": "20px",
                "type": [
                    "line",
                    "dot"
                ],
                "id": "MIN TIME",
                "visible": true
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "AVG TIME",
                "label": "AVG TIME",
                "color": "#3A87AD",
                "thickness": "20px",
                "type": [
                    "line",
                    "dot"
                ],
                "id": "AVG TIME",
                "visible": true
            }
        ],
        "axes": {
            "x": {
                "key": "TESTED_AT",
                "type": "date"
            }
        }
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('STABILITY (%)', 'piechart', average_stability_percent_sql, average_stability_percent_model)
	RETURNING id INTO average_stability_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('TESTCASE INFO', 'table', test_case_info_sql, test_case_info_model)
	RETURNING id INTO test_case_info_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('STABILITY TREND (%)', 'linechart', stability_trend_sql, stability_trend_model)
	RETURNING id INTO stability_trend_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('TEST EXECUTION TIME DETAILS (sec)', 'linechart', test_execution_time_sql, test_execution_time_model)
	RETURNING id INTO test_execution_time_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(stability_dashboard_id, average_stability_percent_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(stability_dashboard_id, test_case_info_id, '{"x":4,"y":0,"width":8,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(stability_dashboard_id, stability_trend_id, '{"x":0,"y":11,"width":12,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(stability_dashboard_id, test_execution_time_id, '{"x":0,"y":22,"width":12,"height":11}');

	-- Insert Failures dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Failures analysis', TRUE, 5) RETURNING id INTO failures_dashboard_id;

	error_message_sql :=
	'set schema ''zafira'';
    SELECT Message AS "Error Message"
    FROM NIGHTLY_FAILURES_VIEW
    WHERE MESSAGE_HASHCODE=''#{hashcode}''
    LIMIT 1';

	error_message_model :=
	'{
       "columns":[
          "Error Message"
       ]
    }';

	detailed_failures_report_sql :=
	'set schema ''zafira'';
  SELECT count(*) as "COUNT",
      Env AS "ENV",
      Report AS "REPORT",
      Rebuild AS "REBUILD"
  FROM NIGHTLY_FAILURES_VIEW
  WHERE substring(Message from 1 for 210)  IN (
     SELECT substring(Message from 1 for 210)
     FROM NIGHTLY_FAILURES_VIEW
     WHERE MESSAGE_HASHCODE=''#{hashcode}''
  )
  GROUP BY "ENV", "REPORT", "REBUILD", substring(Message from 1 for 210)
  ORDER BY "COUNT" DESC, "ENV"';

	detailed_failures_report_model :=
	'{
         "columns": [
             "COUNT",
             "ENV",
             "REPORT",
             "REBUILD"
         ]
     }';


	failures_count_sql :=
	'set schema ''zafira'';
    SELECT
        Env AS "ENV",
        count(*) as "COUNT"
    FROM NIGHTLY_FAILURES_VIEW
    WHERE substring(Message from 1 for 210)  IN (
       SELECT substring(Message from 1 for 210)
    FROM NIGHTLY_FAILURES_VIEW
    WHERE MESSAGE_HASHCODE=''#{hashcode}'')
    GROUP BY "ENV"
    ORDER BY "COUNT" DESC';

	failures_count_model :=
	'{
        "columns": [
            "ENV",
            "COUNT"
        ]
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY DETAILS', 'table', error_message_sql, error_message_model)
	RETURNING id INTO error_message_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('DETAILED FAILURES REPORT', 'table', detailed_failures_report_sql, detailed_failures_report_model)
	RETURNING id INTO detailed_failures_report_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('FAILURES COUNT', 'table', failures_count_sql, failures_count_model)
	RETURNING id INTO failures_count_id;
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, error_message_id, '{"x":3,"y":0,"width":9,"height":14}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, detailed_failures_report_id, '{"x":0,"y":14,"width":12,"height":10}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, failures_count_id, '{"x":0,"y":0,"width":3,"height":14}');

	-- Insert Personal dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Personal', FALSE, 1) RETURNING id INTO personal_dashboard_id;

	nightly_details_personal_sql :=
	'set schema ''zafira'';
  SELECT
      OWNER as "OWNER",
      BUILD as "BUILD",
      ''<a href="#{zafiraURL}/#!/tests/runs/''||TEST_RUN_ID||''" target="_blank"> '' || TEST_SUITE_NAME ||'' </a>'' AS "REPORT",
      eTAF_Report as "ETAF_REPORT",
      sum(Passed) || ''/'' || sum(FAILED) + sum(KNOWN_ISSUE) || ''/'' || sum(Skipped) as "P/F/S",
      REBUILD as "REBUILD",
  UPDATED as "UPDATED"
  FROM NIGHTLY_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
  GROUP BY "OWNER", "BUILD", "REPORT", "ETAF_REPORT", "REBUILD", "UPDATED"
  ORDER BY "BUILD" DESC';

	nightly_details_personal_model :=
	'{
      "columns": [
          "OWNER",
          "BUILD",
          "REPORT",
          "ETAF_REPORT",
          "P/F/S",
          "REBUILD",
          "UPDATED"
      ]
  }';

	monthly_total_personal_pie_sql :=
	'set schema ''zafira'';
  SELECT
      unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
      unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
      unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
  FROM MONTHLY_VIEW
  WHERE
      PROJECT LIKE ANY (''{#{project}}'')
      AND OWNER_ID = ''#{currentUserId}''
  ORDER BY "value" DESC';

	monthly_total_personal_pie_model :=
	'{
      "thickness": 20
   }';

	monthly_total_personal_table_sql :=
	'set schema ''zafira'';
    SELECT OWNER AS "OWNER",
        SUM(TOTAL)  AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 2) AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 2) AS "FAILED (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 2) AS "SKIPPED (%)"
    FROM MONTHLY_VIEW
    WHERE OWNER_ID = ''#{currentUserId}''
    GROUP BY OWNER
    ORDER BY OWNER';

	monthly_total_personal_table_model :=
	'{
        "columns": [
            "OWNER",
            "TOTAL",
            "PASSED (%)",
            "FAILED (%)",
            "SKIPPED (%)"
        ]
     }';

	weekly_total_personal_table_sql :=
	'set schema ''zafira'';
    SELECT OWNER AS "OWNER",
        SUM(TOTAL)  AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 2) AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 2) AS "FAILED (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 2) AS "SKIPPED (%)"
    FROM MONTHLY_VIEW
    WHERE OWNER_ID = ''#{currentUserId}''
    GROUP BY OWNER
    ORDER BY OWNER';

	weekly_total_personal_table_model :=
	'{
      "columns": [
          "OWNER",
          "TOTAL",
          "PASSED (%)",
          "FAILED (%)",
          "SKIPPED (%)"
      ]
  }';

	weekly_total_personal_pie_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM WEEKLY_VIEW
    WHERE
        PROJECT LIKE ANY (''{#{project}}'')
        AND OWNER_ID = ''#{currentUserId}''
    ORDER BY "value" DESC';

	weekly_total_personal_pie_model :=
	'{
         "thickness": 20
     }';

	nightly_total_personal_pie_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM NIGHTLY_VIEW
    WHERE
        PROJECT LIKE ANY (''{#{project}}'')
        AND OWNER_ID = ''#{currentUserId}''
    ORDER BY "value" DESC';

	nightly_total_personal_pie_model :=
	'{
       "thickness": 20
   }';

	nightly_total_personal_table_sql :=
	'set schema ''zafira'';
    SELECT OWNER AS "OWNER",
        SUM(TOTAL)  AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 2) AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 2) AS "FAILED (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 2) AS "SKIPPED (%)"
    FROM NIGHTLY_VIEW
    WHERE OWNER_ID = ''#{currentUserId}''
    GROUP BY OWNER
    ORDER BY OWNER';

	nightly_total_personal_table_model :=
	'{
        "columns":[
           "OWNER",
           "TOTAL",
           "PASSED (%)",
           "FAILED (%)",
           "SKIPPED (%)"
         ]
     }';

	total_last_30_days_personal_sql :=
	'set schema ''zafira'';
    SELECT
        sum(PASSED) AS "PASSED",
        sum(FAILED) AS "FAILED",
        sum(KNOWN_ISSUE) AS "KNOWN_ISSUE",
        sum(SKIPPED) AS "SKIPPED",
        sum(IN_PROGRESS) AS "IN_PROGRESS",
        sum(ABORTED) AS "ABORTED",
        sum(QUEUED) AS "QUEUED",
STARTED::date AS "CREATED_AT"
    FROM BIMONTHLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    AND OWNER_ID = ''#{currentUserId}''
    AND STARTED >= date_trunc(''day'', current_date  - interval ''30 day'')
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT";';

	total_last_30_days_personal_model :=
	'{
         "series": [
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "PASSED",
                 "label": "PASSED",
                 "color": "#5cb85c",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "PASSED"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "FAILED",
                 "label": "FAILED",
                 "color": "#d9534f",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "FAILED"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "KNOWN_ISSUE",
                 "label": "KNOWN_ISSUE",
                 "color": "#AA5C33",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "KNOWN_ISSUE"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "SKIPPED",
                 "label": "SKIPPED",
                 "color": "#f0ad4e",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "SKIPPED"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "ABORTED",
                 "label": "ABORTED",
                 "color": "#AAAAAA",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "ABORTED"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "IN_PROGRESS",
                 "label": "IN_PROGRESS",
                 "color": "#3a87ad",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "IN_PROGRESS"
             },
             {
                 "axis": "y",
                 "dataset": "dataset",
                 "key": "QUEUED",
                 "label": "QUEUED",
                 "color": "#6C6C6C",
                 "thickness": "10px",
                 "type": [
                     "line",
                     "dot",
                     "area"
                 ],
                 "id": "QUEUED"
             }
         ],
         "axes": {
             "x": {
                 "key": "CREATED_AT",
                 "type": "date",
                 "ticks": "functions(value) {return ''wow!''}"
             }
         }
    }';

	nightly_personal_failures_sql :=
	'set schema ''zafira'';
  SELECT count(*) AS "COUNT",
      ENV AS "ENV",
      ''<a href="#{zafiraURL}/#!/dashboards/'||failures_dashboard_id||'?hashcode='' || max(MESSAGE_HASHCODE)  || ''" target="_blank">Failures Analysis Report</a>''
          AS "REPORT",
      substring(MESSAGE from 1 for 210) as "MESSAGE",
      REBUILD as "REBUILD"
  FROM NIGHTLY_FAILURES_VIEW
  WHERE
      OWNER_ID = #{currentUserId}
      AND MESSAGE IS NOT NULL
  GROUP BY "ENV", substring(MESSAGE from 1 for 210), "REBUILD"
  ORDER BY "COUNT" DESC';

	nightly_personal_failures_model :=
	'{
      "columns": [
          "COUNT",
          "ENV",
          "REPORT",
          "MESSAGE",
          "REBUILD"
      ]
  }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY DETAILS PERSONAL', 'table', nightly_details_personal_sql, nightly_details_personal_model)
	RETURNING id INTO nightly_details_personal_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('MONTHLY TOTAL PERSONAL', 'piechart', monthly_total_personal_pie_sql, monthly_total_personal_pie_model)
	RETURNING id INTO monthly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('MONTHLY TOTAL PERSONAL', 'table', monthly_total_personal_table_sql, monthly_total_personal_table_model)
	RETURNING id INTO monthly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('WEEKLY TOTAL PERSONAL', 'table', weekly_total_personal_table_sql, weekly_total_personal_table_model)
	RETURNING id INTO weekly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('WEEKLY TOTAL PERSONAL', 'piechart', weekly_total_personal_pie_sql, weekly_total_personal_pie_model)
	RETURNING id INTO weekly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY TOTAL PERSONAL', 'piechart', nightly_total_personal_pie_sql, nightly_total_personal_pie_model)
	RETURNING id INTO nightly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY TOTAL PERSONAL', 'table', nightly_total_personal_table_sql, nightly_total_personal_table_model)
	RETURNING id INTO nightly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('TEST RESULTS (LAST 30 DAYS) PERSONAL', 'linechart', total_last_30_days_personal_sql, total_last_30_days_personal_model)
	RETURNING id INTO total_last_30_days_personal_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY - PERSONAL FAILURES', 'table', nightly_personal_failures_sql, nightly_personal_failures_model)
	RETURNING id INTO nightly_personal_failures_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, nightly_details_personal_id, '{"x":0,"y":28,"width":12,"height":21}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, monthly_total_personal_pie_id, '{"x":8,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, monthly_total_personal_table_id, '{"x":4,"y":11,"width":4,"height":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, weekly_total_personal_table_id, '{"x":8,"y":11,"width":4,"height":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, weekly_total_personal_pie_id, '{"x":4,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, nightly_total_personal_pie_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, nightly_total_personal_table_id, '{"x":0,"y":11,"width":4,"height":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, total_last_30_days_personal_id, '{"x":0,"y":17,"width":12,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(personal_dashboard_id, nightly_personal_failures_id, '{"x":0,"y":49,"width":12,"height":15}');

	-- Insert User Performance dashboard data
    INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('User Performance', TRUE, 6) RETURNING id INTO user_performance_dashboard_id;

	personal_total_rate_sql :=
	'set schema ''zafira'';
    SELECT
        OWNER AS "OWNER",
        sum( passed ) AS "PASSED",
        sum( failed ) AS "FAILED",
        sum( skipped ) AS "SKIPPED",
        round (100.0 * sum( passed ) / (sum( total )), 2) as "PASS RATE"
    FROM TOTAL_VIEW
    WHERE OWNER_ID = ''#{currentUserId}''
    GROUP BY "OWNER"';

	personal_total_rate_model :=
    '{
         "columns":[
            "OWNER",
            "PASSED",
            "FAILED",
            "SKIPPED",
            "PASS RATE"
         ]
     }';

	personal_total_tests_man_hours_sql :=
    'set schema ''zafira'';
    SELECT
        SUM(TOTAL_HOURS) AS "MAN-HOURS",
    	TESTED_AT AS "CREATED_AT"
    FROM TOTAL_VIEW WHERE OWNER_ID = ''#{currentUserId}''
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT"';

	personal_total_tests_man_hours_model :=
    '{
      "series": [
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "MAN-HOURS",
          "label": "MAN-HOURS",
          "color": "#5cb85c",
          "thickness": "10px",
          "type": [
            "column"
             ],
          "id": "MAN-HOURS"
        }
      ],
      "axes": {
        "x": {
          "key": "CREATED_AT",
          "type": "date",
          "ticks": "functions(value) {return ''wow!''}"
        },
        "y": {
          "min": "0"
        }
      }
    }';

	weekly_test_impl_progress_user_perf_sql :=
	'set schema ''zafira'';
    SELECT
        date_trunc(''week'', TEST_CASES.CREATED_AT)::date AS "CREATED_AT" ,
        count(*) AS "AMOUNT"
    FROM TEST_CASES INNER JOIN
        USERS ON TEST_CASES.PRIMARY_OWNER_ID=USERS.ID
    WHERE USERS.ID=''#{currentUserId}''
    GROUP BY 1
    ORDER BY 1;';

	weekly_test_impl_progress_user_perf_model :=
	'{
      "series": [
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "AMOUNT",
          "label": "INTERPOLATED AMOUNT",
          "interpolation": {"mode": "bundle", "tension": 0.8},
          "color": "#f0ad4e",
          "type": [
            "line"
          ],
          "id": "AMOUNT"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "AMOUNT",
          "label": "AMOUNT",
          "color": "#3a87ad",
          "type": [
            "column"
          ],
          "id": "AMOUNT"
        }
      ],
      "axes": {
        "x": {
          "key": "CREATED_AT",
          "type": "date"
        },
        "y": {
          "min": "0"
        }
      }
    }';

	total_tests_trend_sql :=
	'set schema ''zafira'';
    SELECT
        TESTED_AT AS "MONTH",
        sum( PASSED ) AS "PASSED",
        sum( FAILED ) AS "FAILED",
        sum( SKIPPED ) AS "SKIPPED",
        sum( IN_PROGRESS ) AS "IN_PROGRESS",
        sum( ABORTED ) AS "ABORTED",
        sum( QUEUED ) AS "QUEUED",
        sum( TOTAL ) AS "TOTAL"
    FROM TOTAL_VIEW
    WHERE OWNER_ID=''#{currentUserId}''
    GROUP BY 1
    ORDER BY 1';

	total_tests_trend_model :=
    '{
      "series": [
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "PASSED",
          "label": "PASSED",
          "color": "#5cb85c",
          "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "PASSED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "FAILED",
          "label": "FAILED",
          "color": "#d9534f",
    	  "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "FAILED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "SKIPPED",
          "label": "SKIPPED",
          "color": "#f0ad4e",
    	  "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "SKIPPED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "IN_PROGRESS",
          "label": "IN_PROGRESS",
          "color": "#3a87ad",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "IN_PROGRESS"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "ABORTED",
          "label": "ABORTED",
          "color": "#aaaaaa",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "ABORTED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "TOTAL",
          "label": "TOTAL",
          "color": "#d3d3d3",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "TOTAL"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "QUEUED",
          "label": "QUEUED",
          "color": "#6C6C6C",
          "type": [
              "line",
              "dot",
              "area"
          ],
          "id": "QUEUED"
        }
   ],
      "axes": {
        "x": {
          "key": "MONTH",
          "type": "date",
          "ticks": "functions(value) {return ''wow!''}"
        }
      }
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('PERSONAL TOTAL RATE', 'table', personal_total_rate_sql, personal_total_rate_model)
	RETURNING id INTO personal_total_rate_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('PERSONAL TOTAL TESTS (MAN-HOURS)', 'linechart', personal_total_tests_man_hours_sql, personal_total_tests_man_hours_model)
	RETURNING id INTO personal_total_tests_man_hours_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TEST IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON)', 'linechart', weekly_test_impl_progress_user_perf_sql, weekly_test_impl_progress_user_perf_model)
	RETURNING id INTO weekly_test_impl_progress_user_perf_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS TREND', 'linechart', total_tests_trend_sql, total_tests_trend_model)
	RETURNING id INTO total_tests_trend_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (user_performance_dashboard_id, personal_total_rate_id, '{"x": 0, "y": 0, "height": 11, "width": 4}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (user_performance_dashboard_id, personal_total_tests_man_hours_id, '{"x": 4, "y": 0, "height": 11, "width": 8}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (user_performance_dashboard_id, weekly_test_impl_progress_user_perf_id, '{"x": 0, "y": 11, "height": 11, "width": 12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (user_performance_dashboard_id, total_tests_trend_id, '{"x": 0, "y": 22, "height": 11, "width": 12}');

	-- Insert General dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('General', FALSE, 0) RETURNING id INTO general_dashboard_id;

	total_tests_count_sql :=
	'set schema ''zafira'';
    SELECT
        PROJECT AS "PROJECT",
        sum(PASSED) AS "PASS",
        sum(FAILED) AS "FAIL",
        sum(KNOWN_ISSUE) AS "ISSUE",
        sum(SKIPPED) AS "SKIP",
        sum(QUEUED) AS "QUEUE",
        round (100.0 * sum( passed ) / (sum( total )), 2) as "Pass Rate"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY PROJECT
    UNION
    SELECT  ''<B><I>TOTAL</I></B>'' AS "PROJECT",
        sum(PASSED) AS "PASS",
        sum(FAILED) AS "FAIL",
        sum(KNOWN_ISSUE) AS "ISSUE",
        sum(SKIPPED) AS "SKIP",
        sum(QUEUED) AS "QUEUE",
        round (100.0 * sum( passed ) / (sum( total )), 2) as "Pass Rate"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "PASS" DESC';

	total_tests_count_model :=
    '{
        "columns": [
            "PROJECT",
            "PASS",
            "FAIL",
            "ISSUE",
            "SKIP",
            "QUEUE",
            "PASS RATE"
        ]
    }';

	total_tests_pie_sql :=
    'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "value" DESC';

	total_tests_pie_model :=
    '{
         "thickness": 20
     }';

	weekly_test_impl_progress_sql :=
    'set schema ''zafira'';
    SELECT
        date_trunc(''week'', TEST_CASES.CREATED_AT)::date AS "CREATED_AT" ,
        count(*) AS "AMOUNT"
    FROM TEST_CASES INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
    INNER JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID=USERS.ID
    WHERE PROJECTS.NAME LIKE ANY (''{#{project}}'')
    GROUP BY 1
    ORDER BY 1;';

	weekly_test_impl_progress_model :=
	'{
        "series": [
          {
            "axis": "y",
            "dataset": "dataset",
            "key": "AMOUNT",
            "label": "INTERPOLATED AMOUNT",
            "interpolation": {"mode": "bundle", "tension": 0.8},
            "color": "#f0ad4e",
            "type": [
              "line"
            ],
            "id": "AMOUNT"
          },
          {
            "axis": "y",
            "dataset": "dataset",
            "key": "AMOUNT",
            "label": "AMOUNT",
            "color": "#3a87ad",
            "type": [
              "column"
            ],
            "id": "AMOUNT"
          }
        ],
        "axes": {
          "x": {
            "key": "CREATED_AT",
            "type": "date"
          }
        }
    }';

	total_jira_tickets_sql :=
	'set schema ''zafira'';
    SELECT
        PROJECTS.NAME AS "PROJECT",
        COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
    FROM TEST_WORK_ITEMS
        INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID
        INNER JOIN TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID
        INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
    WHERE WORK_ITEMS.TYPE=''BUG''
    AND PROJECTS.NAME LIKE ANY (''{#{project}}'')
    GROUP BY "PROJECT"
    ORDER BY "COUNT" DESC;';

	total_jira_tickets_model :=
    '{
        "columns":[
           "PROJECT",
           "COUNT"
        ]
     }';

	total_tests_man_hours_sql :=
	'set schema ''zafira'';
    SELECT
        SUM(TOTAL_HOURS) AS "ACTUAL",
        SUM(TOTAL_HOURS) AS "ETA",
        TESTED_AT AS "CREATED_AT"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "CREATED_AT"
    UNION
    SELECT
        SUM(TOTAL_HOURS) AS "ACTUAL",
        ROUND(SUM(TOTAL_HOURS)/extract(day from current_date)
        * extract(day from date_trunc(''day'', date_trunc(''month'', current_date) + interval ''1 month'') - interval ''1 day'')) AS "ETA",
        date_trunc(''month'', current_date) AS "CREATED_AT"
    FROM MONTHLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT";';

	total_tests_man_hours_model :=
	'{
        "series": [
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "ACTUAL",
                "label": "ACTUAL",
                "color": "#5C9AE1",
                "thickness": "10px",
                "type": [
                    "column"
                ],
                "id": "ACTUAL",
                "visible": true
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "ETA",
                "label": "ETA",
                "color": "#C4C9CE",
                "thickness": "10px",
                "interpolation": {
                    "mode": "bundle",
                    "tension": 1
                },
                "type": [
                    "dashed-line"
                ],
                "id": "ETA",
                "visible": true
            }
        ],
        "axes": {
            "x": {
                "key": "CREATED_AT",
                "type": "date",
                "ticks": "functions(value) {return ''wow!''}"
            },
            "y": {
                "min": "0"
            }
        }
    }';

    total_tests_by_month_sql =
    'set schema ''zafira'';
    SELECT
        SUM(PASSED) as "PASSED",
        SUM(FAILED) AS "FAILED",
        SUM(SKIPPED) AS "SKIPPED",
        SUM(IN_PROGRESS) AS "IN PROGRESS",
        SUM(ABORTED) AS "ABORTED",
        SUM(QUEUED) AS "QUEUED",
        SUM(TOTAL) AS "TOTAL",
        date_trunc(''month'', TESTED_AT) AS "CREATED_AT"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT"';

    total_tests_by_month_model =
    '{
        "series": [
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "PASSED",
                "label": "PASSED",
                "color": "#5cb85c",
                "thickness": "10px",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "PASSED"
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "FAILED",
                "label": "FAILED",
                "color": "#d9534f",
                "thickness": "10px",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "FAILED"
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "SKIPPED",
                "label": "SKIPPED",
                "color": "#f0ad4e",
                "thickness": "10px",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "SKIPPED"
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "IN PROGRESS",
                "label": "IN PROGRESS",
                "color": "#3a87ad",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "IN PROGRESS"
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "ABORTED",
                "label": "ABORTED",
                "color": "#aaaaaa",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "ABORTED"
            },
            {
              "axis": "y",
              "dataset": "dataset",
              "key": "QUEUED",
              "label": "QUEUED",
              "color": "#6C6C6C",
              "type": [
                  "line",
                  "dot",
                  "area"
              ],
              "id": "QUEUED"
            },
            {
                "axis": "y",
                "dataset": "dataset",
                "key": "TOTAL",
                "label": "TOTAL",
                "color": "#D3D3D3",
                "type": [
                    "line",
                    "dot",
                    "area"
                ],
                "id": "TOTAL"
            }
        ],
        "axes": {
            "x": {
                "key": "CREATED_AT",
                "type": "date",
                "ticks": "functions(value) {return ''wow!''}"
            }
        }
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS (COUNT)', 'table', total_tests_count_sql, total_tests_count_model)
	RETURNING id INTO total_tests_count_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS', 'piechart', total_tests_pie_sql, total_tests_pie_model)
	RETURNING id INTO total_tests_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TEST IMPLEMENTATION PROGRESS', 'linechart', weekly_test_impl_progress_sql, weekly_test_impl_progress_model)
	RETURNING id INTO weekly_test_impl_progress_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL JIRA TICKETS', 'table', total_jira_tickets_sql, total_jira_tickets_model)
	RETURNING id INTO total_jira_tickets_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS (MAN-HOURS)', 'linechart', total_tests_man_hours_sql, total_tests_man_hours_model)
	RETURNING id INTO total_tests_man_hours_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS (BY MONTH)', 'linechart', total_tests_by_month_sql, total_tests_by_month_model)
	RETURNING id INTO total_tests_by_month_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, total_tests_man_hours_id, '{"x":4,"y":0,"width":8,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, total_tests_pie_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, total_tests_count_id, '{"x":0,"y":11,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, weekly_test_impl_progress_id, '{"x":4,"y":22,"height":11,"width":8}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, total_jira_tickets_id, '{"x":0,"y":22,"width":4,"height":11}');
    INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (general_dashboard_id, total_tests_by_month_id, '{"x":4,"y":11,"width":8,"height":11}');

	-- Insert Monthly dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Monthly Regression', FALSE, 4) RETURNING id INTO monthly_dashboard_id;

    monthly_total_sql :=
    'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM MONTHLY_VIEW
    WHERE
        PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "value" DESC';

	monthly_total_model :=
    '{
        "thickness": 20
     }';

    monthly_total_percent_sql :=
    'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
        unnest(
        array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
            round(100.0 * sum(FAILED)/sum(TOTAL), 2),
            round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
            round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
            round(100.0 * sum(ABORTED)/sum(TOTAL), 2),
            round(100.0 * sum(QUEUED)/sum(TOTAL), 2)
                       ]) AS "value"
    FROM MONTHLY_VIEW
    ORDER BY "value" DESC';

    monthly_total_percent_model :=
    '{
         "thickness": 20
     }';

	test_results_30_sql :=
	'set schema ''zafira'';
    SELECT
        sum(PASSED) AS "PASSED",
        sum(FAILED) AS "FAILED",
        sum(KNOWN_ISSUE) AS "KNOWN_ISSUE",
        sum(SKIPPED) AS "SKIPPED",
        sum(IN_PROGRESS) AS "IN_PROGRESS",
        sum(ABORTED) AS "ABORTED",
        sum(QUEUED) AS "QUEUED",
        STARTED::date AS "CREATED_AT"
    FROM BIMONTHLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    AND STARTED >= date_trunc(''day'', current_date  - interval ''30 day'')
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT";';

	test_results_30_model :=
	'{
     "series": [
       {
         "axis": "y",
         "dataset": "dataset",
         "key": "PASSED",
         "label": "PASSED",
         "color": "#5cb85c",
         "thickness": "10px",
         "type": [
           "line",
           "dot",
           "area"
         ],
         "id": "PASSED"
       },
       {
         "axis": "y",
         "dataset": "dataset",
         "key": "FAILED",
         "label": "FAILED",
         "color": "#d9534f",
       "thickness": "10px",
         "type": [
           "line",
           "dot",
           "area"
         ],
         "id": "FAILED"
       },
    {
          "axis": "y",
          "dataset": "dataset",
          "key": "KNOWN_ISSUE",
          "label": "KNOWN_ISSUE",
          "color": "#AA5C33",
          "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "KNOWN_ISSUE"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "SKIPPED",
          "label": "SKIPPED",
          "color": "#f0ad4e",
          "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "SKIPPED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "ABORTED",
          "label": "ABORTED",
          "color": "#AAAAAA",
          "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "ABORTED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "QUEUED",
          "label": "QUEUED",
          "color": "#6C6C6C",
          "thickness": "10px",
          "type": [
              "line",
              "dot",
              "area"
          ],
          "id": "QUEUED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "IN_PROGRESS",
          "label": "IN_PROGRESS",
          "color": "#3a87ad",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "IN_PROGRESS"
        }
      ],
      "axes": {
        "x": {
          "key": "CREATED_AT",
          "type": "date",
          "ticks": "functions(value) {return ''wow!''}"
        }
      }
    }';

	monthly_jira_tickets_sql :=
	'set schema ''zafira'';
    SELECT
        PROJECTS.NAME AS "PROJECT",
        COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
    FROM TEST_WORK_ITEMS
        INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID
        INNER JOIN TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID
        INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
    WHERE WORK_ITEMS.TYPE=''BUG''
    AND PROJECTS.NAME LIKE ANY (''{#{project}}'')
    AND TEST_WORK_ITEMS.CREATED_AT > date_trunc(''month'', current_date  - interval ''1 month'')
    GROUP BY "PROJECT"
    ORDER BY "COUNT" DESC;';

	monthly_jira_tickets_model :=
    '{
        "columns":[
           "PROJECT",
           "COUNT"
        ]
     }';

	monthly_platform_details_sql :=
    'set schema ''zafira'';
    SELECT
        case when (PLATFORM IS NULL AND BROWSER <> '''') then ''WEB''
             when (PLATFORM = ''*'' AND BROWSER <> '''') then ''WEB''
             when (PLATFORM IS NULL AND BROWSER = '''') then ''API''
             when (PLATFORM = ''*''  AND BROWSER = '''') then ''API''
             else PLATFORM end AS "PLATFORM",
        Build AS "BUILD",
        sum( PASSED ) AS "PASSED",
        sum( FAILED ) AS "FAILED",
        sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
        sum( SKIPPED) AS "SKIPPED",
        sum( ABORTED ) AS "ABORTED",
        sum(QUEUED) AS "QUEUED",
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)"
    FROM MONTHLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "PLATFORM", "BUILD"
    ORDER BY "PLATFORM"';

	monthly_platform_details_model :=
	'{
      "columns": [
        "PLATFORM",
        "BUILD",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "ABORTED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)",
        "QUEUED (%)"
      ]
    }';

	monthly_details_sql :=
	'set schema ''zafira'';
    SELECT
        OWNER AS "OWNER",
        ''<a href="#{zafiraURL}/#!/dashboards/'||personal_dashboard_id||'?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal Board</a>'' AS "REPORT",
        SUM(PASSED) AS "PASSED",
        SUM(FAILED) AS "FAILED",
        SUM(KNOWN_ISSUE) AS "KNOWN ISSUE",
        SUM(SKIPPED) AS "SKIPPED",
        SUM(QUEUED) AS "QUEUED",
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM MONTHLY_VIEW
    WHERE
    PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY OWNER_ID, OWNER
    ORDER BY OWNER';

	monthly_details_model :=
	'{
      "columns": [
        "OWNER",
        "REPORT",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "QUEUED (%)"
      ]
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY TOTAL', 'piechart', monthly_total_sql, monthly_total_model)
	RETURNING id INTO monthly_total_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY TOTAL (%)', 'piechart', monthly_total_percent_sql, monthly_total_percent_model)
	RETURNING id INTO monthly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TEST RESULTS (LAST 30 DAYS)', 'linechart', test_results_30_sql, test_results_30_model)
	RETURNING id INTO test_results_30_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY PLATFORM DETAILS', 'table', monthly_platform_details_sql, monthly_platform_details_model)
	RETURNING id INTO monthly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY DETAILS', 'table', monthly_details_sql, monthly_details_model)
	RETURNING id INTO monthly_details_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (monthly_dashboard_id, monthly_total_id, '{"x":0,"y":0,"height":11,"width":3}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (monthly_dashboard_id, monthly_total_percent_id, '{"x":3,"y":0,"width":3,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (monthly_dashboard_id, test_results_30_id, '{"x":6,"y":0,"height":11,"width":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (monthly_dashboard_id, monthly_platform_details_id, '{"x":0,"y":22,"width":12,"height":18}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (monthly_dashboard_id, monthly_details_id, '{"x":0,"y":11,"height":11,"width":12}');

	-- Insert Weekly dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Weekly Regression', FALSE, 3) RETURNING id INTO weekly_dashboard_id;

	weekly_total_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM WEEKLY_VIEW
    WHERE
        PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "value" DESC';

	weekly_total_model :=
    '{
         "thickness": 20
     }';

    weekly_total_percent_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
        unnest(
         array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
             round(100.0 * sum(FAILED)/sum(TOTAL), 2),
             round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
             round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
             round(100.0 * sum(ABORTED)/sum(TOTAL), 2),
             round(100.0 * sum(QUEUED)/sum(TOTAL), 2)
                    ]) AS "value"
    FROM WEEKLY_VIEW
    ORDER BY "value" DESC';

	weekly_total_percent_model :=
    '{
         "thickness": 20
     }';

	test_results_7_sql :=
	'set schema ''zafira'';
    SELECT
        sum(PASSED) AS "PASSED",
        sum(FAILED) AS "FAILED",
        sum(KNOWN_ISSUE) AS "KNOWN_ISSUE",
        sum(SKIPPED) AS "SKIPPED",
        sum(IN_PROGRESS) AS "IN_PROGRESS",
        sum(ABORTED) AS "ABORTED",
        sum(QUEUED) AS "QUEUED",
        STARTED::date AS "CREATED_AT"
    FROM MONTHLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    AND STARTED >= date_trunc(''day'', current_date  - interval ''7 day'')
    GROUP BY "CREATED_AT"
    ORDER BY "CREATED_AT";';

	test_results_7_model :=
	'{
     "series": [
       {
         "axis": "y",
         "dataset": "dataset",
         "key": "PASSED",
         "label": "PASSED",
         "color": "#5cb85c",
         "thickness": "10px",
         "type": [
           "line",
           "dot",
           "area"
         ],
         "id": "PASSED"
       },
       {
         "axis": "y",
         "dataset": "dataset",
         "key": "FAILED",
         "label": "FAILED",
         "color": "#d9534f",
       "thickness": "10px",
         "type": [
           "line",
           "dot",
           "area"
         ],
         "id": "FAILED"
       },
    {
          "axis": "y",
          "dataset": "dataset",
          "key": "KNOWN_ISSUE",
          "label": "KNOWN_ISSUE",
          "color": "#AA5C33",
          "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "KNOWN_ISSUE"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "SKIPPED",
          "label": "SKIPPED",
          "color": "#f0ad4e",
        "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "SKIPPED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "ABORTED",
          "label": "ABORTED",
          "color": "#AAAAAA",
        "thickness": "10px",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "ABORTED"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "IN_PROGRESS",
          "label": "IN_PROGRESS",
          "color": "#3a87ad",
          "type": [
            "line",
            "dot",
            "area"
          ],
          "id": "IN_PROGRESS"
        },
        {
          "axis": "y",
          "dataset": "dataset",
          "key": "QUEUED",
          "label": "QUEUED",
          "color": "#6C6C6C",
          "type": [
              "line",
              "dot",
              "area"
          ],
          "id": "QUEUED"
        }
      ],
      "axes": {
        "x": {
          "key": "CREATED_AT",
          "type": "date",
          "ticks": "functions(value) {return ''wow!''}"
        }
      }
    }';

	weekly_platform_details_sql :=
	'set schema ''zafira'';
    SELECT
        case when (PLATFORM IS NULL AND BROWSER <> '''') then ''WEB''
             when (PLATFORM = ''*'' AND BROWSER <> '''') then ''WEB''
             when (PLATFORM IS NULL AND BROWSER = '''') then ''API''
             when (PLATFORM = ''*''  AND BROWSER = '''') then ''API''
             else PLATFORM end AS "PLATFORM",
        Build AS "BUILD",
        sum( PASSED ) AS "PASSED",
        sum( FAILED ) AS "FAILED",
        sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
        sum( SKIPPED) AS "SKIPPED",
        sum( ABORTED ) AS "ABORTED",
        sum( QUEUED ) AS "QUEUED",
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)"
    FROM WEEKLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "PLATFORM", "BUILD"
    ORDER BY "PLATFORM"';

	weekly_platform_details_model :=
	'{
      "columns": [
        "PLATFORM",
        "BUILD",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "ABORTED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)",
        "QUEUED (%)"
      ]
    }';

	weekly_details_sql :=
	'set schema ''zafira'';
    SELECT
        OWNER AS "OWNER",
        ''<a href="#{zafiraURL}/#!/dashboards/'||personal_dashboard_id||'?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal Board</a>'' AS "REPORT",
        SUM(PASSED) AS "PASSED",
        SUM(FAILED) AS "FAILED",
        SUM(KNOWN_ISSUE) AS "KNOWN ISSUE",
        SUM(SKIPPED) AS "SKIPPED",
        sum( QUEUED ) AS "QUEUED",
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
   FROM WEEKLY_VIEW
   WHERE
   PROJECT LIKE ANY (''{#{project}}'')
   GROUP BY OWNER_ID, OWNER
   ORDER BY OWNER';

	weekly_details_model :=
	'{
      "columns": [
        "OWNER",
        "REPORT",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "QUEUED (%)"
      ]
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TOTAL', 'piechart', weekly_total_sql, weekly_total_model)
	RETURNING id INTO weekly_total_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TOTAL (%)', 'piechart', weekly_total_percent_sql, weekly_total_percent_model)
	RETURNING id INTO weekly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TEST RESULTS (LAST 7 DAYS)', 'linechart', test_results_7_sql, test_results_7_model)
	RETURNING id INTO test_results_7_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY PLATFORM DETAILS', 'table', weekly_platform_details_sql, weekly_platform_details_model)
	RETURNING id INTO weekly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY DETAILS', 'table', weekly_details_sql, weekly_details_model)
	RETURNING id INTO weekly_details_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (weekly_dashboard_id, weekly_total_id, '{"x":0,"y":0,"height":11,"width":3}');
    INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (weekly_dashboard_id, weekly_total_percent_id, '{"x":3,"y":0,"width":3,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (weekly_dashboard_id, test_results_7_id, '{"x":6,"y":0,"height":11,"width":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (weekly_dashboard_id, weekly_platform_details_id, '{"x":0,"y":22,"height":20,"width":12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (weekly_dashboard_id, weekly_details_id, '{"x":0,"y":11,"height":11,"width":12}');

	-- Insert Nightly dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Nightly Regression', FALSE, 2) RETURNING id INTO nightly_dashboard_id;

	nightly_total_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED), SUM(QUEUED)]) AS "value"
    FROM NIGHTLY_VIEW
    WHERE
        PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "value" DESC';

	nightly_total_model := '
    {
        "thickness": 20
    }';

	nightly_total_percent_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'', ''QUEUED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'', ''#6C6C6C'']) AS "color",
       unnest(
        array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
            round(100.0 * sum(FAILED)/sum(TOTAL), 2),
            round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
            round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
            round(100.0 * sum(ABORTED)/sum(TOTAL), 2),
            round(100.0 * sum(QUEUED)/sum(TOTAL), 2)
                   ]) AS "value"
    FROM NIGHTLY_VIEW
	  WHERE
        PROJECT LIKE ANY (''{#{project}}'')
    ORDER BY "value" DESC';

	nightly_total_percent_model :=
    '{
        "thickness": 20
    }';

	nightly_platform_details_sql :=
	'set schema ''zafira'';
    SELECT
        case when (PLATFORM IS NULL AND BROWSER <> '''') then ''WEB''
            when (PLATFORM = ''*'' AND BROWSER <> '''') then ''WEB''
            when (PLATFORM IS NULL AND BROWSER = '''') then ''API''
            when (PLATFORM = ''*''  AND BROWSER = '''') then ''API''
            else PLATFORM end AS "PLATFORM",
        Build AS "BUILD",
        sum( PASSED ) AS "PASSED",
        sum( FAILED ) AS "FAILED",
        sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
        sum( SKIPPED) AS "SKIPPED",
        sum( ABORTED ) AS "ABORTED",
        sum( QUEUED ) AS "QUEUED",
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)",
        round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED (%)"
    FROM NIGHTLY_VIEW
    WHERE PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY "PLATFORM", "BUILD"
    ORDER BY "PLATFORM"';

	nightly_platform_details_model :=
	'{
      "columns": [
        "PLATFORM",
        "BUILD",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "ABORTED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)",
        "QUEUED (%)"
      ]
    }';

	nightly_details_sql :=
	'set schema ''zafira'';
    SELECT
        OWNER AS "OWNER",
        ''<a href="#{zafiraURL}/#!/dashboards/'||personal_dashboard_id||'?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal Board</a>'' AS "REPORT",
        SUM(PASSED) AS "PASSED",
        SUM(FAILED) AS "FAILED",
        SUM(KNOWN_ISSUE) AS "KNOWN ISSUE",
        SUM(SKIPPED) AS "SKIPPED",
        sum( QUEUED ) AS "QUEUED",
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM NIGHTLY_VIEW
    WHERE
      PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY OWNER_ID, OWNER
    ORDER BY OWNER';

	nightly_details_model :=
	'{
      "columns": [
        "OWNER",
        "REPORT",
        "PASSED",
        "FAILED",
        "KNOWN ISSUE",
        "SKIPPED",
        "QUEUED",
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "QUEUED (%)"
      ]
    }';

    nightly_regression_date_sql :=
    'set schema ''zafira'';
    SELECT
    MIN(Updated) AS "REGRESSION DATE"
    FROM NIGHTLY_VIEW;';

    nightly_regression_date_model :=
    '{
        "columns": [
            "REGRESSION DATE"
        ]
    }';

	nightly_failures_sql :=
	'set schema ''zafira'';
  SELECT count(*) AS "COUNT",
      ''<a href="#{zafiraURL}/#!/dashboards/'||failures_dashboard_id||'?hashcode='' || max(MESSAGE_HASHCODE)  || ''" target="_blank">Failures Analysis Report</a>'' AS "REPORT",
      substring(MESSAGE from 1 for 210) as "MESSAGE"
  FROM NIGHTLY_FAILURES_VIEW
  GROUP BY substring(MESSAGE from 1 for 210)
  HAVING count(*) > 0
  ORDER BY "COUNT" desc, "MESSAGE"';

	nightly_failures_model :=
	'{
      "columns": [
          "COUNT",
          "REPORT",
          "MESSAGE"
      ]
  }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY TOTAL', 'piechart', nightly_total_sql, nightly_total_model)
	RETURNING id INTO nightly_total_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY TOTAL (%)', 'piechart', nightly_total_percent_sql, nightly_total_percent_model)
	RETURNING id INTO nightly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY PLATFORM DETAILS', 'table', nightly_platform_details_sql, nightly_platform_details_model)
	RETURNING id INTO nightly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY DETAILS', 'table', nightly_details_sql, nightly_details_model)
	RETURNING id INTO nightly_details_id;
  INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY (DATE)', 'table', nightly_regression_date_sql, nightly_regression_date_model)
	RETURNING id INTO nightly_regression_date_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY FAILURES', 'table', nightly_failures_sql, nightly_failures_model)
	RETURNING id INTO nightly_failures_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (nightly_dashboard_id, nightly_total_id, '{"x":0,"y":0,"height":11,"width":4}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (nightly_dashboard_id, nightly_total_percent_id, '{"x":4,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (nightly_dashboard_id, nightly_platform_details_id, '{"x":0,"y":22,"height":15,"width":12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (nightly_dashboard_id, nightly_details_id, '{"x":0,"y":11,"height":11,"width":12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
    (nightly_dashboard_id, nightly_regression_date_id, '{"x":8,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(nightly_dashboard_id, nightly_failures_id, '{"x":0,"y":37,"width":12,"height":22}');

END$$;