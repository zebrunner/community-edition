INSERT INTO zafira.SETTINGS (NAME, VALUE, TOOL) VALUES
	('JIRA_CLOSED_STATUS', 'CLOSED', 'JIRA'),
	('JIRA_URL', '', 'JIRA'),
	('JIRA_USER', '', 'JIRA'),
	('JIRA_PASSWORD', '', 'JIRA'),
	('JIRA_ENABLED', false, 'JIRA'),
	('JENKINS_URL', '', 'JENKINS'),
	('JENKINS_USER', '', 'JENKINS'),
	('JENKINS_API_TOKEN_OR_PASSWORD', '', 'JENKINS'),
	('JENKINS_ENABLED', false, 'JENKINS'),
	('SLACK_WEB_HOOK_URL', '', 'SLACK'),
	('SLACK_ENABLED', false, 'SLACK'),
	('EMAIL_HOST', '', 'EMAIL'),
	('EMAIL_PORT', '', 'EMAIL'),
	('EMAIL_USER', '', 'EMAIL'),
	('EMAIL_PASSWORD', '', 'EMAIL'),
	('EMAIL_ENABLED', false, 'EMAIL'),
	('AMAZON_ACCESS_KEY', 'AKIAIOBQFZ6YOU2KWKAA', 'AMAZON'),
	('AMAZON_SECRET_KEY', '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', 'AMAZON'),
	('AMAZON_BUCKET', 'zafira', 'AMAZON'),
	('AMAZON_ENABLED', true, 'AMAZON'),
	('HIPCHAT_ACCESS_TOKEN', '', 'HIPCHAT'),
	('HIPCHAT_ENABLED', false, 'HIPCHAT'),
	('KEY', '', 'CRYPTO'),
	('CRYPTO_KEY_SIZE', '128', 'CRYPTO'),
	('CRYPTO_KEY_TYPE', 'AES', 'CRYPTO'),
	('RABBITMQ_HOST', 'localhost', 'RABBITMQ'),
	('RABBITMQ_PORT', '5672', 'RABBITMQ'),
	('RABBITMQ_USER', 'qpsdemo', 'RABBITMQ'),
	('RABBITMQ_PASSWORD', 'qpsdemo', 'RABBITMQ'),
	('RABBITMQ_WS', 'http://localhost:15674/stomp', 'RABBITMQ'),
	('RABBITMQ_ENABLED', false, 'RABBITMQ'),
	('COMPANY_LOGO_URL', null, null);

INSERT INTO zafira.PROJECTS (NAME, DESCRIPTION) VALUES ('UNKNOWN', '');


DO $$
DECLARE GROUP_ID zafira.GROUP_PERMISSIONS.id%TYPE;
DECLARE dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE widget_id zafira.WIDGETS.id%TYPE;
DECLARE USER_ID zafira.USER_PREFERENCES.id%TYPE;

DECLARE general_dashboard_id zafira.DASHBOARDS.id%TYPE;
DECLARE result_widget_id zafira.WIDGETS.id%TYPE;
DECLARE top_widget_id zafira.WIDGETS.id%TYPE;
DECLARE progress_widget_id zafira.WIDGETS.id%TYPE;

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

  INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('User Performance', TRUE) RETURNING id INTO dashboard_id;

  INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES ('Performance widget', 'linechart',
	'set schema zafira;
SELECT TEST_CONFIGS.ENV || "-" || TEST_CONFIGS.DEVICE AS env,
	TEST_METRICS.OPERATION,
	TEST_METRICS.ELAPSED AS "ELAPSED",
	TEST_METRICS.CREATED_AT AS "CREATED_AT"
FROM TEST_METRICS INNER JOIN
	TESTS ON TEST_METRICS.TEST_ID = TESTS.ID INNER JOIN
	TEST_CONFIGS ON TEST_CONFIGS.ID = TESTS.TEST_CONFIG_ID
WHERE TESTS.TEST_CASE_ID = #{test_case_id} #{time_step}
ORDER BY env, "CREATED_AT"',
    '{"series":[{"axis":"y","dataset":"dataset","key":"ELAPSED","label":"ELAPSED","color":"#5cb85c","thickness":"10px",
    	"type":["line","dot"],"id":"ELAPSED"}],"axes":{"x":{"key":"CREATED_AT","type":"int","ticks": "functions(value) {return ''wow!''}"}}}')
    RETURNING id INTO widget_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (dashboard_id, widget_id, 1, 12, '{"x": 0, "y": 0, "height": 11, "width": 12}');




	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('General', FALSE) RETURNING id INTO general_dashboard_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES ('Test results (last 30 days)', 'linechart',
		'set schema ''zafira'';
SELECT
	sum( case when TESTS.STATUS = ''PASSED'' then 1 else 0 end ) AS "PASSED",
	sum( case when TESTS.STATUS = ''FAILED'' then 1 else 0 end ) AS "FAILED",
	sum( case when TESTS.STATUS = ''SKIPPED'' then 1 else 0 end ) AS "SKIPPED",
	sum( case when TESTS.STATUS = ''IN_PROGRESS'' then 1 else 0 end ) AS "INCOMPLETE",
	TESTS.CREATED_AT::date AS "CREATED_AT"
FROM
	TESTS INNER JOIN
TEST_RUNS ON TESTS.TEST_RUN_ID = TEST_RUNS.ID INNER JOIN
PROJECTS ON TEST_RUNS.PROJECT_ID = PROJECTS.ID
WHERE
	TESTS.CREATED_AT::date >= (current_date - 30) AND PROJECTS.NAME LIKE ''#{project}%''
GROUP BY TESTS.CREATED_AT::date
ORDER BY TESTS.CREATED_AT::date;',
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
      "key": "INCOMPLETE",
      "label": "INCOMPLETE",
      "color": "#3a87ad",
      "type": [
        "line",
        "dot",
        "area"
      ],
      "id": "INCOMPLETE"
    }
  ],
  "axes": {
    "x": {
      "key": "CREATED_AT",
      "type": "date"
    }
  }
}')
		RETURNING id INTO result_widget_id;

		INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES ('Top 8 test automation developers', 'piechart',
		'set schema ''zafira'';
SELECT
	USERS.USERNAME AS "label",
	COUNT(*) AS "value",
	CONCAT(''#'', floor(random()*(999-100+1))+100) AS "color"
FROM
	TEST_CASES INNER JOIN
USERS ON USERS.ID = TEST_CASES.PRIMARY_OWNER_ID INNER JOIN
PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
WHERE
	PROJECTS.NAME LIKE ''#{project}%''
GROUP BY USERS.USERNAME
ORDER BY "value" DESC
LIMIT 8;',
'{}')
		RETURNING id INTO top_widget_id;

		INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES ('Test implementation progress (last 30 days)', 'linechart',
		'set schema ''zafira'';
SELECT
	TEST_CASES.CREATED_AT::date AS "CREATED_AT",
	COUNT(*) AS "AMOUNT"
FROM
	TEST_CASES INNER JOIN
PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
WHERE
	TEST_CASES.CREATED_AT::date >= (current_date - 30) AND PROJECTS.NAME LIKE ''#{project}%''
GROUP BY TEST_CASES.CREATED_AT::date
ORDER BY TEST_CASES.CREATED_AT::date ASC;',
'{
  "series": [
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
}')
		RETURNING id INTO progress_widget_id;

		INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (general_dashboard_id, result_widget_id, 0, 12, '{"x": 0, "y": 0, "height": 11, "width": 12}');
		INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (general_dashboard_id, top_widget_id, 1, 4, '{"x": 0, "y": 11, "height": 11, "width": 4}');
		INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (general_dashboard_id, progress_widget_id, 3, 8, '{"x": 4, "y": 11, "height": 11, "width": 8}');
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

	-- Insert Failures dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Failures analysis Test', TRUE) RETURNING id INTO failures_dashboard_id;

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
		('NIGHTLY DETAILS TEST', 'table', error_message_sql, error_message_model)
	RETURNING id INTO error_message_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('DETAILED FAILURES REPORT TEST', 'table', detailed_failures_report_sql, detailed_failures_report_model)
	RETURNING id INTO detailed_failures_report_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('FAILURES COUNT TEST', 'table', failures_count_sql, failures_count_model)
	RETURNING id INTO failures_count_id;
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, error_message_id, '{"x":3,"y":0,"width":9,"height":14}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, detailed_failures_report_id, '{"x":0,"y":14,"width":12,"height":10}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
		(failures_dashboard_id, failures_count_id, '{"x":0,"y":0,"width":3,"height":14}');

	-- Insert Personal dashboard data
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Personal Test', TRUE) RETURNING id INTO personal_dashboard_id;

	nightly_details_personal_sql :=
	'set schema ''zafira'';
  SELECT
      OWNER as "OWNER",
      BUILD as "BUILD",
      ''<a href="#{zafiraURL}/#!/tests/runs/''||TEST_RUN_ID||''" target="_blank"> '' || TEST_SUITE_NAME ||'' </a>'' AS "REPORT",
      eTAF_Report as "eTAF_Report",
      sum(Passed) || ''/'' || sum(FAILED) + sum(KNOWN_ISSUE) || ''/'' || sum(Skipped) as "P/F/S",
      REBUILD as "REBUILD",
  UPDATED as "UPDATED"
  FROM NIGHTLY_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
  GROUP BY "OWNER", "BUILD", "REPORT", "eTAF_Report", "REBUILD", "UPDATED"
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
      unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
      unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
      unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
  FROM MONTHLY_VIEW
  WHERE
      PROJECT LIKE ''#{project}%''
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
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
       unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM WEEKLY_VIEW
    WHERE
        PROJECT LIKE ''#{project}%''
        AND OWNER_ID = ''#{currentUserId}''
    ORDER BY "value" DESC';

	weekly_total_personal_pie_model :=
	'{
         "thickness": 20
     }';

	nightly_total_personal_pie_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''IN PROGRESS'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#4385F5'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(IN_PROGRESS), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM NIGHTLY_VIEW
    WHERE
        PROJECT LIKE ''#{project}%''
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
        STARTED::date AS "CREATED_AT"
    FROM BIMONTHLY_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
                 "color": "#f0ad4e",
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
		('NIGHTLY DETAILS PERSONAL TEST', 'table', nightly_details_personal_sql, nightly_details_personal_model)
	RETURNING id INTO nightly_details_personal_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('MONTHLY TOTAL PERSONAL TEST', 'piechart', monthly_total_personal_pie_sql, monthly_total_personal_pie_model)
	RETURNING id INTO monthly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('MONTHLY TOTAL PERSONAL TEST', 'table', monthly_total_personal_table_sql, monthly_total_personal_table_model)
	RETURNING id INTO monthly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('WEEKLY TOTAL PERSONAL TEST', 'table', weekly_total_personal_table_sql, weekly_total_personal_table_model)
	RETURNING id INTO weekly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('WEEKLY TOTAL PERSONAL TEST', 'piechart', weekly_total_personal_pie_sql, weekly_total_personal_pie_model)
	RETURNING id INTO weekly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY TOTAL PERSONAL TEST', 'piechart', nightly_total_personal_pie_sql, nightly_total_personal_pie_model)
	RETURNING id INTO nightly_total_personal_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY TOTAL PERSONAL TEST', 'table', nightly_total_personal_table_sql, nightly_total_personal_table_model)
	RETURNING id INTO nightly_total_personal_table_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('TEST RESULTS (LAST 30 DAYS) PERSONAL TEST', 'linechart', total_last_30_days_personal_sql, total_last_30_days_personal_model)
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
    INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('User Performance Test', TRUE) RETURNING id INTO user_performance_dashboard_id;

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
    ('PERSONAL TOTAL RATE TEST', 'table', personal_total_rate_sql, personal_total_rate_model)
	RETURNING id INTO personal_total_rate_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('PERSONAL TOTAL TESTS (MAN-HOURS) TEST', 'linechart', personal_total_tests_man_hours_sql, personal_total_tests_man_hours_model)
	RETURNING id INTO personal_total_tests_man_hours_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TEST IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON) TEST', 'linechart', weekly_test_impl_progress_user_perf_sql, weekly_test_impl_progress_user_perf_model)
	RETURNING id INTO weekly_test_impl_progress_user_perf_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS TREND TEST', 'linechart', total_tests_trend_sql, total_tests_trend_model)
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
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('General Test', TRUE) RETURNING id INTO general_dashboard_id;

	total_tests_count_sql :=
	'set schema ''zafira'';
    SELECT
        PROJECT AS "PROJECT",
        sum(PASSED) AS "PASS",
        sum(FAILED) AS "FAIL",
        sum(KNOWN_ISSUE) AS "ISSUE",
        sum(SKIPPED) AS "SKIP",
        round (100.0 * sum( passed ) / (sum( total )), 2) as "Pass Rate"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ''#{project}%''
    GROUP BY PROJECT
    UNION
    SELECT  ''<B><I>TOTAL</I></B>'' AS "PROJECT",
        sum(PASSED) AS "PASS",
        sum(FAILED) AS "FAIL",
        sum(KNOWN_ISSUE) AS "ISSUE",
        sum(SKIPPED) AS "SKIP",
        round (100.0 * sum( passed ) / (sum( total )), 2) as "Pass Rate"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ''#{project}%''
    ORDER BY "PASS" DESC';

	total_tests_count_model :=
    '{
        "columns": [
            "PROJECT",
            "PASS",
            "FAIL",
            "ISSUE",
            "SKIP",
            "PASS RATE"
        ]
    }';

	total_tests_pie_sql :=
    'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
    WHERE PROJECTS.NAME LIKE ''#{project}%''
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
    AND PROJECTS.NAME LIKE ''#{project}%''
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
    WHERE PROJECT LIKE ''#{project}%''
    GROUP BY "CREATED_AT"
    UNION
    SELECT
        SUM(TOTAL_HOURS) AS "ACTUAL",
        ROUND(SUM(TOTAL_HOURS)/extract(day from current_date)
        * extract(day from date_trunc(''day'', date_trunc(''month'', current_date) + interval ''1 month'') - interval ''1 day'')) AS "ETA",
        date_trunc(''month'', current_date) AS "CREATED_AT"
    FROM BIMONTHLY_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
        SUM(TOTAL) AS "TOTAL",
        date_trunc(''month'', TESTED_AT) AS "CREATED_AT"
    FROM TOTAL_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
    ('TOTAL TESTS (COUNT) TEST', 'table', total_tests_count_sql, total_tests_count_model)
	RETURNING id INTO total_tests_count_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS TEST', 'piechart', total_tests_pie_sql, total_tests_pie_model)
	RETURNING id INTO total_tests_pie_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TEST IMPLEMENTATION PROGRESS TEST', 'linechart', weekly_test_impl_progress_sql, weekly_test_impl_progress_model)
	RETURNING id INTO weekly_test_impl_progress_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL JIRA TICKETS TEST', 'table', total_jira_tickets_sql, total_jira_tickets_model)
	RETURNING id INTO total_jira_tickets_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS (MAN-HOURS) TEST', 'linechart', total_tests_man_hours_sql, total_tests_man_hours_model)
	RETURNING id INTO total_tests_man_hours_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TOTAL TESTS (BY MONTH) TEST', 'linechart', total_tests_by_month_sql, total_tests_by_month_model)
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
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Monthly Regression Test', TRUE) RETURNING id INTO monthly_dashboard_id;

    monthly_total_sql :=
    'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM MONTHLY_VIEW
    WHERE
        PROJECT LIKE ''%#{project}''
    ORDER BY "value" DESC';

	monthly_total_model :=
    '{
        "thickness": 20
     }';

    monthly_total_percent_sql :=
    'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(
        array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
            round(100.0 * sum(FAILED)/sum(TOTAL), 2),
            round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
            round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
            round(100.0 * sum(ABORTED)/sum(TOTAL), 2)
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
        STARTED::date AS "CREATED_AT"
    FROM BIMONTHLY_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
          "color": "#f0ad4e",
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
    AND PROJECTS.NAME LIKE ''#{project}%''
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
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)"
    FROM MONTHLY_VIEW
    WHERE PROJECT LIKE ''%#{project}''
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)"
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
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM MONTHLY_VIEW
    WHERE
    PROJECT LIKE ''#{project}%''
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)"
      ]
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY TOTAL TEST', 'piechart', monthly_total_sql, monthly_total_model)
	RETURNING id INTO monthly_total_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY TOTAL (%) TEST', 'piechart', monthly_total_percent_sql, monthly_total_percent_model)
	RETURNING id INTO monthly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TEST RESULTS (LAST 30 DAYS) TEST', 'linechart', test_results_30_sql, test_results_30_model)
	RETURNING id INTO test_results_30_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY PLATFORM DETAILS TEST', 'table', monthly_platform_details_sql, monthly_platform_details_model)
	RETURNING id INTO monthly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('MONTHLY DETAILS TEST', 'table', monthly_details_sql, monthly_details_model)
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
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Weekly Regression Test', TRUE) RETURNING id INTO weekly_dashboard_id;

	weekly_total_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM WEEKLY_VIEW
    WHERE
        PROJECT LIKE ''%#{project}''
    ORDER BY "value" DESC';

	weekly_total_model :=
    '{
         "thickness": 20
     }';

    weekly_total_percent_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(
         array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
             round(100.0 * sum(FAILED)/sum(TOTAL), 2),
             round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
             round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
             round(100.0 * sum(ABORTED)/sum(TOTAL), 2)
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
        STARTED::date AS "CREATED_AT"
    FROM MONTHLY_VIEW
    WHERE PROJECT LIKE ''#{project}%''
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
          "color": "#f0ad4e",
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
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)"
    FROM WEEKLY_VIEW
    WHERE PROJECT LIKE ''%#{project}''
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)"
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
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
   FROM WEEKLY_VIEW
   WHERE
   PROJECT LIKE ''#{project}%''
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)"
      ]
    }';

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TOTAL TEST', 'piechart', weekly_total_sql, weekly_total_model)
	RETURNING id INTO weekly_total_id;
    INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY TOTAL (%) TEST', 'piechart', weekly_total_percent_sql, weekly_total_percent_model)
	RETURNING id INTO weekly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('TEST RESULTS (LAST 7 DAYS) TEST', 'linechart', test_results_7_sql, test_results_7_model)
	RETURNING id INTO test_results_7_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY PLATFORM DETAILS TEST', 'table', weekly_platform_details_sql, weekly_platform_details_model)
	RETURNING id INTO weekly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('WEEKLY DETAILS TEST', 'table', weekly_details_sql, weekly_details_model)
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
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Nightly Regression Test', TRUE) RETURNING id INTO nightly_dashboard_id;

	nightly_total_sql :=
	'set schema ''zafira'';
    SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
    FROM NIGHTLY_VIEW
    WHERE
        PROJECT LIKE ''%#{project}''
        AND STARTED >= date_trunc(''day'', current_date)
    ORDER BY "value" DESC';

	nightly_total_model := '
    {
        "thickness": 20
    }';

	nightly_total_percent_sql :=
	'set schema ''zafira'';
    SELECT
       unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''IN PROGRESS'', ''KNOWN ISSUE'', ''ABORTED'']) AS "label",
       unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#4385F5'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
       unnest(
        array[round(100.0 * sum(PASSED)/sum(TOTAL), 2),
            round(100.0 * sum(FAILED)/sum(TOTAL), 2),
            round(100.0 * sum(SKIPPED)/sum(TOTAL), 2),
            round(100.0 * sum(IN_PROGRESS)/sum(TOTAL), 2),
            round(100.0 * sum(KNOWN_ISSUE)/sum(TOTAL), 2),
            round(100.0 * sum(ABORTED)/sum(TOTAL), 2)
                   ]) AS "value"
    FROM NIGHTLY_VIEW
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
        sum(TOTAL) AS "TOTAL",
        round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED (%)",
        round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED (%)",
        round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED (%)"
    FROM NIGHTLY_VIEW
    WHERE PROJECT LIKE ''%#{project}''
    AND STARTED >= date_trunc(''day'', current_date)
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)",
        "ABORTED (%)"
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
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM NIGHTLY_VIEW
    WHERE
      PROJECT LIKE ''#{project}%''
       AND STARTED >= date_trunc(''day'', current_date)
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
        "TOTAL",
        "PASSED (%)",
        "FAILED (%)",
        "KNOWN ISSUE (%)",
        "SKIPPED (%)"
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
    ('NIGHTLY TOTAL TEST', 'piechart', nightly_total_sql, nightly_total_model)
	RETURNING id INTO nightly_total_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY TOTAL (%) TEST', 'piechart', nightly_total_percent_sql, nightly_total_percent_model)
	RETURNING id INTO nightly_total_percent_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY PLATFORM DETAILS TEST', 'table', nightly_platform_details_sql, nightly_platform_details_model)
	RETURNING id INTO nightly_platform_details_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY DETAILS TEST', 'table', nightly_details_sql, nightly_details_model)
	RETURNING id INTO nightly_details_id;
  INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
    ('NIGHTLY (DATE) TEST', 'table', nightly_regression_date_sql, nightly_regression_date_model)
	RETURNING id INTO nightly_regression_date_id;
	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
		('NIGHTLY FAILURES TEST', 'table', nightly_failures_sql, nightly_failures_model)
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