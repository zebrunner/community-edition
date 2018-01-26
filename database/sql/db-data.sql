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
  DECLARE general_dashboard_id zafira.DASHBOARDS.id%TYPE;

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

BEGIN
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

	total_tests_count_model := '
    {
        "columns": [
            "PROJECT",
            "PASS",
            "FAIL",
            "ISSUE",
            "SKIP",
            "Pass Rate"
        ]
    }';

	total_tests_pie_sql :='
     set schema ''zafira'';
     SELECT
        unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''ISSUE'', ''ABORTED'']) AS "label",
        unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
        unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
     FROM TOTAL_VIEW
     WHERE PROJECT LIKE ''#{project}%''
     ORDER BY "value" DESC
     ';

	total_tests_pie_model := '
    {
    "thickness": 20
    }';

	weekly_test_impl_progress_sql :=
	'set schema ''zafira'';
   SELECT
   date_trunc(''week'', TEST_CASES.CREATED_AT)::date AS "CREATED_AT" ,
   count(*) AS "AMOUNT"
   FROM TEST_CASES INNER JOIN
   PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
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
       SELECT PROJECTS.NAME AS "PROJECT",
         COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
       FROM TEST_WORK_ITEMS
       INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID INNER JOIN
       TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID INNER JOIN
       PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
       WHERE WORK_ITEMS.TYPE=''BUG''
       AND PROJECTS.NAME LIKE ''#{project}%''
       GROUP BY "PROJECT"
       ORDER BY "COUNT" DESC;';

	total_jira_tickets_model := '{"columns" : ["PROJECT", "COUNT"]}';

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
        * extract(day from date_trunc(''day'', date_trunc(''month'', current_date) + interval ''1 month'') - interval ''1 day''))
        AS "ETA",
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
                 "color": "#5cb85c",
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


	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TOTAL TESTS (COUNT)', 'table', total_tests_count_sql, total_tests_count_model)
	RETURNING id INTO total_tests_count_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TOTAL TESTS', 'piechart', total_tests_pie_sql, total_tests_pie_model)
	RETURNING id INTO total_tests_pie_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'WEEKLY TEST IMPLEMENTATION PROGRESS', 'linechart', weekly_test_impl_progress_sql, weekly_test_impl_progress_model)
	RETURNING id INTO weekly_test_impl_progress_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TOTAL JIRA TICKETS', 'table', total_jira_tickets_sql, total_jira_tickets_model)
	RETURNING id INTO total_jira_tickets_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TOTAL TESTS (MAN-HOURS)', 'linechart', total_tests_man_hours_sql, total_tests_man_hours_model)
	RETURNING id INTO total_tests_man_hours_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (general_dashboard_id, total_tests_man_hours_id, '{"x":0,"y":11,"width":12,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (general_dashboard_id, total_tests_pie_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (general_dashboard_id, total_tests_count_id, '{"x":4,"y":0,"width":4,"height":11}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (general_dashboard_id, weekly_test_impl_progress_id, '{"x":0,"y":22,"height":11,"width":12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (general_dashboard_id, total_jira_tickets_id, '{"x":8,"y":0,"width":4,"height":11}');

END$$;

DO $$

DECLARE nightly_dashboard_id zafira.DASHBOARDS.id%TYPE;

	DECLARE nightly_total_id zafira.WIDGETS.id%TYPE;
	DECLARE nightly_total_sql zafira.WIDGETS.sql%TYPE;
	DECLARE nightly_total_model zafira.WIDGETS.model%TYPE;

	DECLARE nightly_jira_tickets_id zafira.WIDGETS.id%TYPE;
	DECLARE nightly_jira_tickets_sql zafira.WIDGETS.sql%TYPE;
	DECLARE nightly_jira_tickets_model zafira.WIDGETS.model%TYPE;

	DECLARE nightly_platform_details_id zafira.WIDGETS.id%TYPE;
	DECLARE nightly_platform_details_sql zafira.WIDGETS.sql%TYPE;
	DECLARE nightly_platform_details_model zafira.WIDGETS.model%TYPE;

	DECLARE nightly_details_id zafira.WIDGETS.id%TYPE;
	DECLARE nightly_details_sql zafira.WIDGETS.sql%TYPE;
	DECLARE nightly_details_model zafira.WIDGETS.model%TYPE;

BEGIN

	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Nightly Regression Test', TRUE) RETURNING id INTO nightly_dashboard_id;

	nightly_total_sql :=
	'set schema ''zafira'';
   SELECT
      unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''ISSUE'', ''ABORTED'']) AS "label",
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

	nightly_jira_tickets_sql :=
	'set schema ''zafira'';
   SELECT PROJECTS.NAME AS "PROJECT",
     COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
   FROM TEST_WORK_ITEMS
   INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID INNER JOIN
   TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID INNER JOIN
   PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
   WHERE WORK_ITEMS.TYPE=''BUG''
   AND PROJECTS.NAME LIKE ''#{project}%''
   AND TEST_WORK_ITEMS.CREATED_AT >= date_trunc(''day'', current_date)
   GROUP BY "PROJECT"
   ORDER BY "COUNT" DESC;';

	nightly_jira_tickets_model := '{"columns" : ["PROJECT", "COUNT"]}';

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
   SELECT  OWNER AS "OWNER",
     ''<a href="#{zafiraURL}/#!/dashboards/10?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal Nightly Board</a>'' AS "REPORT",
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

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'NIGHTLY TOTAL', 'piechart', nightly_total_sql, nightly_total_model)
	RETURNING id INTO nightly_total_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'NIGHTLY JIRA TICKETS', 'table', nightly_jira_tickets_sql, nightly_jira_tickets_model)
	RETURNING id INTO nightly_jira_tickets_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'NIGHTLY PLATFORM DETAILS', 'table', nightly_platform_details_sql, nightly_platform_details_model)
	RETURNING id INTO nightly_platform_details_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'NIGHTLY DETAILS', 'table', nightly_details_sql, nightly_details_model)
	RETURNING id INTO nightly_details_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (nightly_dashboard_id, nightly_total_id, '{"x":0,"y":0,"height":11,"width":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (nightly_dashboard_id, nightly_jira_tickets_id, '{"x":6,"y":0,"height":11,"width":6}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (nightly_dashboard_id, nightly_platform_details_id, '{"x":0,"y":11,"height":11,"width":12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (nightly_dashboard_id, nightly_details_id, '{"x":0,"y":22,"height":11,"width":12}');

END$$;

DO $$

DECLARE weekly_dashboard_id zafira.DASHBOARDS.id%TYPE;

	DECLARE weekly_total_id zafira.WIDGETS.id%TYPE;
	DECLARE weekly_total_sql zafira.WIDGETS.sql%TYPE;
	DECLARE weekly_total_model zafira.WIDGETS.model%TYPE;

	DECLARE test_results_7_id zafira.WIDGETS.id%TYPE;
	DECLARE test_results_7_sql zafira.WIDGETS.sql%TYPE;
	DECLARE test_results_7_model zafira.WIDGETS.model%TYPE;

	DECLARE weekly_jira_tickets_id zafira.WIDGETS.id%TYPE;
	DECLARE weekly_jira_tickets_sql zafira.WIDGETS.sql%TYPE;
	DECLARE weekly_jira_tickets_model zafira.WIDGETS.model%TYPE;

	DECLARE weekly_platform_details_id zafira.WIDGETS.id%TYPE;
	DECLARE weekly_platform_details_sql zafira.WIDGETS.sql%TYPE;
	DECLARE weekly_platform_details_model zafira.WIDGETS.model%TYPE;

	DECLARE weekly_details_id zafira.WIDGETS.id%TYPE;
	DECLARE weekly_details_sql zafira.WIDGETS.sql%TYPE;
	DECLARE weekly_details_model zafira.WIDGETS.model%TYPE;

BEGIN
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Weekly Regression Test', TRUE) RETURNING id INTO weekly_dashboard_id;

	weekly_total_sql :=
	'set schema ''zafira'';
   SELECT
      unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''ISSUE'', ''ABORTED'']) AS "label",
      unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
      unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
   FROM WEEKLY_VIEW
   WHERE
       PROJECT LIKE ''%#{project}''
   ORDER BY "value" DESC';

	weekly_total_model := '
     {
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
     STARTED AS "CREATED_AT"
   FROM BIMONTHLY_VIEW
   WHERE PROJECT LIKE ''#{project}%''
   AND STARTED >= date_trunc(''day'', current_date  - interval ''7 day'')
   GROUP BY STARTED
   ORDER BY STARTED;';

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

	weekly_jira_tickets_sql :=
	'set schema ''zafira'';
   SELECT PROJECTS.NAME AS "PROJECT",
     COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
   FROM TEST_WORK_ITEMS
   INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID INNER JOIN
   TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID INNER JOIN
   PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
   WHERE WORK_ITEMS.TYPE=''BUG''
   AND PROJECTS.NAME LIKE ''#{project}%''
   AND TEST_WORK_ITEMS.CREATED_AT >= date_trunc(''day'', date_trunc(''week'', current_date)  - interval ''2 day'')
   GROUP BY "PROJECT"
   ORDER BY "COUNT" DESC;';

	weekly_jira_tickets_model := '{"columns" : ["PROJECT", "COUNT"]}';

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
   SELECT  OWNER AS "OWNER",
     ''<a href="#{zafiraURL}/#!/dashboards/10?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal weekly Board</a>'' AS "REPORT",
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

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'WEEKLY TOTAL', 'piechart', weekly_total_sql, weekly_total_model)
	RETURNING id INTO weekly_total_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TEST RESULTS (LAST 7 DAYS)', 'linechart', test_results_7_sql, test_results_7_model)
	RETURNING id INTO test_results_7_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'WEEKLY JIRA TICKETS', 'table', weekly_jira_tickets_sql, weekly_jira_tickets_model)
	RETURNING id INTO weekly_jira_tickets_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'WEEKLY PLATFORM DETAILS', 'table', weekly_platform_details_sql, weekly_platform_details_model)
	RETURNING id INTO weekly_platform_details_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'WEEKLY DETAILS', 'table', weekly_details_sql, weekly_details_model)
	RETURNING id INTO weekly_details_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (weekly_dashboard_id, weekly_total_id, '{"x": 0, "y": 0, "height": 11, "width": 4}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (weekly_dashboard_id, test_results_7_id, '{"x": 4, "y": 0, "height": 11, "width": 8}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (weekly_dashboard_id, weekly_jira_tickets_id, '{"x": 0, "y": 22, "height": 11, "width": 12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (weekly_dashboard_id, weekly_platform_details_id, '{"x": 0, "y": 11, "height": 11, "width": 12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (weekly_dashboard_id, weekly_details_id, '{"x": 0, "y": 22, "height": 11, "width": 12}');

END$$;

DO $$

DECLARE monthly_dashboard_id zafira.DASHBOARDS.id%TYPE;

	DECLARE monthly_total_id zafira.WIDGETS.id%TYPE;
	DECLARE monthly_total_sql zafira.WIDGETS.sql%TYPE;
	DECLARE monthly_total_model zafira.WIDGETS.model%TYPE;

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

BEGIN
	INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Monthly Regression Test', TRUE) RETURNING id INTO monthly_dashboard_id;

	monthly_total_sql :=
	'set schema ''zafira'';
   SELECT
      unnest(array[''PASSED'', ''FAILED'', ''SKIPPED'', ''ISSUE'', ''ABORTED'']) AS "label",
      unnest(array[''#109D5D'', ''#DC4437'', ''#FCBE1F'', ''#AA5C33'', ''#AAAAAA'']) AS "color",
      unnest(array[SUM(PASSED), SUM(FAILED), SUM(SKIPPED), SUM(KNOWN_ISSUE), SUM(ABORTED)]) AS "value"
   FROM BIMONTHLY_VIEW
   WHERE
       PROJECT LIKE ''%#{project}''
       AND STARTED > date_trunc(''month'', current_date  - interval ''1 month'')
   ORDER BY "value" DESC';

	monthly_total_model := '
     {
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
     STARTED AS "CREATED_AT"
   FROM BIMONTHLY_VIEW
   WHERE PROJECT LIKE ''#{project}%''
   AND STARTED >= date_trunc(''day'', current_date  - interval ''30 day'')
   GROUP BY STARTED
   ORDER BY STARTED;';

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
   SELECT PROJECTS.NAME AS "PROJECT",
     COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
   FROM TEST_WORK_ITEMS
   INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID INNER JOIN
   TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID INNER JOIN
   PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
   WHERE WORK_ITEMS.TYPE=''BUG''
   AND PROJECTS.NAME LIKE ''#{project}%''
   AND TEST_WORK_ITEMS.CREATED_AT > date_trunc(''month'', current_date  - interval ''1 month'')
   GROUP BY "PROJECT"
   ORDER BY "COUNT" DESC;';

	monthly_jira_tickets_model := '{"columns" : ["PROJECT", "COUNT"]}';

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
   FROM BIMONTHLY_VIEW
   WHERE PROJECT LIKE ''%#{project}''
   AND STARTED > date_trunc(''month'', current_date  - interval ''1 month'')
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
   SELECT  OWNER AS "OWNER",
     ''<a href="#{zafiraURL}/#!/dashboards/10?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER || '' - Personal monthly Board</a>'' AS "REPORT",
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
   FROM BIMONTHLY_VIEW
   WHERE
     PROJECT LIKE ''#{project}%''
      AND STARTED > date_trunc(''month'', current_date  - interval ''1 month'')
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

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'MONTHLY TOTAL', 'piechart', monthly_total_sql, monthly_total_model)
	RETURNING id INTO monthly_total_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'TEST RESULTS (LAST 30 DAYS)', 'linechart', test_results_30_sql, test_results_30_model)
	RETURNING id INTO test_results_30_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'MONTHLY JIRA TICKETS', 'table', monthly_jira_tickets_sql, monthly_jira_tickets_model)
	RETURNING id INTO monthly_jira_tickets_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'MONTHLY PLATFORM DETAILS', 'table', monthly_platform_details_sql, monthly_platform_details_model)
	RETURNING id INTO monthly_platform_details_id;

	INSERT INTO zafira.WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES (
		'MONTHLY DETAILS', 'table', monthly_details_sql, monthly_details_model)
	RETURNING id INTO monthly_details_id;

	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (monthly_dashboard_id, monthly_total_id, '{"x": 0, "y": 0, "height": 11, "width": 4}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (monthly_dashboard_id, test_results_30_id, '{"x": 4, "y": 0, "height": 11, "width": 8}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (monthly_dashboard_id, monthly_jira_tickets_id, '{"x": 0, "y": 22, "height": 11, "width": 12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (monthly_dashboard_id, monthly_platform_details_id, '{"x": 0, "y": 11, "height": 11, "width": 12}');
	INSERT INTO zafira.DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES (monthly_dashboard_id, monthly_details_id, '{"x": 0, "y": 22, "height": 11, "width": 12}');

END$$;
