SET SCHEMA 'zafira';

INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('General', FALSE, 0, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Personal', TRUE, 1001, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Failures analysis', TRUE, 1002, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('User Performance', TRUE, 1003, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Stability', TRUE, 1004, FALSE);

INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS PERSONAL', 'PIE', NULL, NULL, false, 'Consolidated personal information for last 24 hours', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, 8);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 7 DAYS PERSONAL', 'PIE', NULL, NULL, false, 'Consolidated personal information for last 7 days', '{
  "PERIOD": "Last 7 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, 8);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('MONTHLY TEST IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON)', 'BAR', NULL, NULL, false, NULL, '{
  "PERSONAL": "true",
  "USER": [],
  "PROJECT": [],
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, 7);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE STABILITY (%)', 'PIE', NULL, NULL, false, NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 13);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TESTS TREND', 'LINE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "IGNORE_TOTAL_PARAMS": "",
  "IGNORE_PERSONAL_PARAMS": "",
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', NULL, 5);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS PERSONAL FAILURES', 'TABLE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, 9);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE STABILITY TREND (%)', 'LINE', NULL, NULL, false, NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 2);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TEST CASE DURATION DETAILS (SEC)', 'LINE', NULL, NULL, false, NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 12);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 30 DAYS PERSONAL', 'PIE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, 8);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TESTS PERSONAL TREND', 'LINE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "IGNORE_TOTAL_PARAMS": "",
  "IGNORE_PERSONAL_PARAMS": "",
  "userId": "1",
  "dashboardName": "Personal",
  "currentUserId": "1"
}', NULL, 5);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TOTAL PERSONAL TESTS TREND', 'LINE', NULL, NULL, false, NULL, '{
  "PERIOD": "Total",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "IGNORE_TOTAL_PARAMS": "",
  "IGNORE_PERSONAL_PARAMS": "",
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, 5);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS FAILURE COUNT', 'TABLE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, 6);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TESTCASE INFO', 'TABLE', NULL, NULL, false, NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 11);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('LAST 24 HOURS FAILURE DETAILS', 'TABLE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, 10);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('TOTAL JIRA TICKETS - UPDATE', 'TABLE', NULL, NULL, false, NULL, '{
  "PROJECT": [],
  "hashcode": "1046730996",
  "dashboardName": "General"
}', NULL, 4);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS PASS RATE BY PLATFORM (%)', 'BAR', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 30 Days",
  "GROUP_BY": "PLATFORM",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', NULL, 3);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TEST DETAILS', 'TABLE', NULL, NULL, false, NULL, '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', NULL, 14);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('PERSONAL TOTAL TESTS (MAN-HOURS)', 'BAR', NULL, NULL, false, NULL, '{
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, 1);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('30 DAYS TOTAL', 'PIE', NULL, NULL, false, '', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "General",
  "currentUserId": "1"
}', NULL, 8);
INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL, REFRESHABLE, DESCRIPTION, PARAMS_CONFIG, LEGEND_CONFIG, WIDGET_TEMPLATE_ID) VALUES ('PERSONAL TOTAL RATE', 'PIE', NULL, NULL, false, NULL, '{
  "PERIOD": "Total",
  "PERSONAL": "true",
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "": "Below params are not not applicable for Total period!",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, 8);


INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 17, NULL, NULL, '{"x":0,"y":22,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 16, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 19, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (1, 5, NULL, NULL, '{"x":4,"y":22,"width":8,"height":11}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 10, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 1, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 2, NULL, NULL, '{"x":4,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 9, NULL, NULL, '{"x":8,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (2, 6, NULL, NULL, '{"x":0,"y":74,"width":12,"height":9}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (3, 12, NULL, NULL, '{"x":0,"y":0,"width":12,"height":12}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (3, 14, NULL, NULL, '{"x":0,"y":12,"width":12,"height":10}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 11, NULL, NULL, '{"x":0,"y":33,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 18, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 20, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (4, 3, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}');

INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 4, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 7, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 8, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}');
INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, POSITION, SIZE, LOCATION) VALUES (5, 13, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}');
