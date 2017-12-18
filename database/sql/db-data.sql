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
	('AMAZON_ACCESS_KEY', '', 'AMAZON'),
	('AMAZON_SECRET_KEY', '', 'AMAZON'),
	('AMAZON_BUCKET', '', 'AMAZON'),
	('AMAZON_ENABLED', false, 'AMAZON'),
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
	('RABBITMQ_ENABLED', false, 'RABBITMQ');

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

  INSERT INTO zafira.DASHBOARDS (TITLE, HIDDEN) VALUES ('Performance dashboard', TRUE) RETURNING id INTO dashboard_id;

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
