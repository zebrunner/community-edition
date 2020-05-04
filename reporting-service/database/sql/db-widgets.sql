SET SCHEMA 'zafira';

INSERT INTO DASHBOARDS (TITLE, HIDDEN, SYSTEM, POSITION, EDITABLE) VALUES ('General', FALSE, FALSE, 0, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, SYSTEM, POSITION, EDITABLE) VALUES ('Personal', FALSE, FALSE, 1001, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, SYSTEM, POSITION, EDITABLE) VALUES ('Failures analysis', TRUE, TRUE, 1002, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, SYSTEM, POSITION, EDITABLE) VALUES ('User Performance', FALSE, FALSE, 1003, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, SYSTEM, POSITION, EDITABLE) VALUES ('Stability', TRUE, TRUE, 1004, FALSE);

INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS PERSONAL', 'PIE', NULL, NULL, false, 'Consolidated personal information for last 24 hours', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "BROWSER":[],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "Personal",
   "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (PIE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 7 DAYS PERSONAL', 'PIE', NULL, NULL, false, 'Consolidated personal information for last 7 days', '{
  "PERIOD": "Last 7 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "BROWSER":[],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (PIE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('MONTHLY TESTS IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON)', 'BAR', NULL, NULL, false, 'A number of new automated cases per month.', '{
  "PERSONAL": "true",
  "PERIOD": "Total",
  "USER": [],
  "PROJECT": [],
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TESTS IMPLEMENTATION PROGRESS'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE STABILITY (%)', 'PIE', NULL, NULL, false, 'Aggregated stability metric for a test case.', '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TEST CASE STABILITY'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TESTS TREND', 'LINE', NULL, NULL, false, 'Consolidated test status trend for last 30 days.', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "BROWSER": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "testCaseId": "1",
  "dashboardName": "General"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (LINE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS PERSONAL FAILURES', 'TABLE', NULL, NULL, false, 'Summarized personal information about tests failures grouped by reason.', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "BLOCKER": "false",
  "ERROR_COUNT": 0,
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "BROWSER":[],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "JIRA_URL": "",
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', '{
  "COUNT": true,
  "ENV": true,
  "BUG": false,
  "SUBJECT": false,
  "REPORT": true,
  "MESSAGE": true
}', (SELECT id FROM management.widget_templates WHERE name = 'TESTS FAILURES BY REASON'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE STABILITY TREND (%)', 'LINE', NULL, NULL, false, 'Test case stability trend on a monthly basis.', '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TEST CASE STABILITY TREND'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE DURATION DETAILS (SEC)', 'LINE', NULL, NULL, false, 'All kind of duration metrics per test case.', '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TEST CASE DURATION TREND'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 30 DAYS PERSONAL', 'PIE', NULL, NULL, false, 'Consolidated personal information for last 30 days', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "BROWSER": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (PIE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TESTS PERSONAL TREND', 'LINE', NULL, NULL, false, 'Consolidated personal test status trend for last 30 days', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "BROWSER": [],
  "Separator": "Below params are not applicable for Total period!",
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (LINE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TOTAL PERSONAL TESTS TREND', 'LINE', NULL, NULL, false, 'Totally consolidated personal test status trend.', '{
  "PERIOD": "Total",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "BROWSER": [],
  "Separator": "Below params are not applicable for Total period!",
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL,(SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (LINE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS FAILURE COUNT', 'TABLE', NULL, NULL, false, 'High-level information about similar errors for last 24 hours.', '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TEST FAILURE COUNT'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TESTCASE INFO', 'TABLE', NULL, NULL, false, 'Detailed test case information.', '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TESTCASE INFO'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS FAILURE DETAILS', 'TABLE', NULL, NULL, false, 'All tests/jobs with a similar failure for last 24 hours.', '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TEST FAILURE DETAILS'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS PASS RATE BY PROJECT (%)', 'BAR', NULL, NULL, false, 'Pass rate percent by platform for last 30 days.', '{
  "PERIOD": "Last 30 Days",
  "GROUP_BY": "PROJECT",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "PLATFORM_VERSION": [],
  "BROWSER": [],
  "BROWSER_VERSION": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "hashcode": "1893229022",
  "dashboardName": "General"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (BAR)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TEST DETAILS', 'TABLE', NULL, NULL, false, 'Detailed information about passed, failed, skipped, etc tests for last 30 days.', '{
  "PERIOD": "Last 30 Days",
  "GROUP_BY": "OWNER_USERNAME",
  "PERSONAL": "false",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "PLATFORM": [],
  "BROWSER": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', '{
  "OWNER": true,
  "SUITE": false,
  "BUILD": false,
  "PASS": true,
  "FAIL": true,
  "DEFECT": false,
  "SKIP": true,
  "ABORT": false,
  "QUEUE": false,
  "TOTAL": true,
  "PASSED (%)": true,
  "FAILED (%)": false,
  "KNOWN ISSUE (%)": false,
  "SKIPPED (%)": false,
  "QUEUED (%)": false,
  "FAIL RATE (%)": false
}', (SELECT id FROM management.widget_templates WHERE name = 'TESTS SUMMARY'));

INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('PERSONAL TOTAL TESTS (MAN-HOURS)', 'BAR', NULL, NULL, false, 'Monthly personal automation ROI by tests execution. 160+ hours for UI tests indicate that your execution ROI is very good.', '{
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "BROWSER":[],
  "TASK": [],
  "BUG": [],
  "hashcode": "1893229022",
  "dashboardName": "User Performance"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'TESTS EXECUTION ROI (MAN-HOURS)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TOTAL', 'PIE', NULL, NULL, false, 'Consolidated test status information for last 30 days.', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "BROWSER": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (PIE)'));
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('PERSONAL TOTAL RATE', 'PIE', NULL, NULL, false, 'Totally consolidated personal test status information.', '{
  "PERIOD": "Total",
  "PERSONAL": "true",
  "PROJECT": [],
  "PLATFORM": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "Separator": "Below params are not applicable for Total period!",
  "BROWSER": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "hashcode": "1893229022",
  "dashboardName": "User Performance"
}', NULL, (SELECT id FROM management.widget_templates WHERE name = 'PASS RATE (PIE)'));


INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 16, NULL, NULL, '{"x":0,"y":22,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 15, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 18, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 5, NULL, NULL, '{"x":4,"y":22,"width":8,"height":11}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 10, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 1, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 2, NULL, NULL, '{"x":4,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 9, NULL, NULL, '{"x":8,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 6, NULL, NULL, '{"x":0,"y":74,"width":12,"height":9}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (3, 12, NULL, NULL, '{"x":0,"y":0,"width":12,"height":12}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (3, 14, NULL, NULL, '{"x":0,"y":12,"width":12,"height":10}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 11, NULL, NULL, '{"x":0,"y":33,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 17, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 19, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 3, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 4, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 7, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 8, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 13, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
