SET SCHEMA 'zafira';

INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('General', FALSE, 0, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Personal', TRUE, 1001, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Failures analysis', TRUE, 1002, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('User Performance', TRUE, 1003, FALSE);
INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION, EDITABLE) VALUES ('Stability', TRUE, 1004, FALSE);




INSERT INTO widgets VALUES (1, 'LAST 24 HOURS PERSONAL', 'PIE', NULL, NULL, false, '2019-04-15 10:39:16.339074', '2019-04-11 16:26:43.079287', 'Consolidated personal information for last 24 hours', '{
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
INSERT INTO widgets VALUES (2, 'LAST 7 DAYS PERSONAL', 'PIE', NULL, NULL, false, '2019-04-15 10:39:23.254925', '2019-04-11 16:28:22.225447', 'Consolidated personal information for last 7 days', '{
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
INSERT INTO widgets VALUES (3, 'MONTHLY TEST IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON)', 'BAR', NULL, NULL, false, '2019-04-15 10:40:56.293475', '2019-04-12 19:52:41.215361', NULL, '{
  "PERSONAL": "true",
  "USER": [],
  "PROJECT": [],
  "userId": "1",
  "dashboardName": "User Performance",
  "currentUserId": "1"
}', NULL, 3);
INSERT INTO widgets VALUES (4, 'TEST CASE STABILITY (%)', 'PIE', NULL, NULL, false, '2019-04-15 10:41:09.572655', '2019-04-12 20:19:33.906635', NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 13);
INSERT INTO widgets VALUES (5, '30 DAYS TESTS TREND', 'LINE', NULL, NULL, false, '2019-04-15 10:39:03.516402', '2019-04-12 10:16:15.399287', NULL, '{
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
INSERT INTO widgets VALUES (6, 'LAST 24 HOURS PERSONAL FAILURES', 'TABLE', NULL, NULL, false, '2019-04-15 10:39:49.176075', '2019-04-12 15:21:28.633444', NULL, '{
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
INSERT INTO widgets VALUES (7, 'TEST CASE STABILITY TREND (%)', 'LINE', NULL, NULL, false, '2019-04-15 10:41:24.316336', '2019-04-12 20:26:59.573267', NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 2);
INSERT INTO widgets VALUES (8, 'TEST CASE DURATION DETAILS (SEC)', 'LINE', NULL, NULL, false, '2019-04-15 10:41:33.006649', '2019-04-12 20:29:53.951218', NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 12);
INSERT INTO widgets VALUES (9, 'LAST 30 DAYS PERSONAL', 'PIE', NULL, NULL, false, '2019-04-15 10:39:31.655674', '2019-04-11 16:32:21.736667', NULL, '{
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
INSERT INTO widgets VALUES (10, '30 DAYS TESTS PERSONAL TREND', 'LINE', NULL, NULL, false, '2019-04-15 10:39:39.96639', '2019-04-12 10:17:24.907404', NULL, '{
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
INSERT INTO widgets VALUES (11, 'TOTAL PERSONAL TESTS TREND', 'LINE', NULL, NULL, false, '2019-04-15 10:40:47.309859', '2019-04-12 12:09:23.080048', NULL, '{
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
INSERT INTO widgets VALUES (12, 'LAST 24 HOURS FAILURE COUNT', 'TABLE', NULL, NULL, false, '2019-04-15 10:40:03.713617', '2019-04-12 18:58:33.25451', NULL, '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, 6);
INSERT INTO widgets VALUES (13, 'TESTCASE INFO', 'TABLE', NULL, NULL, false, '2019-04-15 10:41:17.405914', '2019-04-12 21:40:54.466846', NULL, '{
  "userId": "1",
  "dashboardName": "Stability",
  "currentUserId": "1"
}', NULL, 11);
INSERT INTO widgets VALUES (14, 'LAST 24 HOURS FAILURE DETAILS', 'TABLE', NULL, NULL, false, '2019-04-15 10:40:13.838226', '2019-04-12 19:22:03.409339', NULL, '{
  "PERIOD": "Last 24 Hours",
  "userId": "1",
  "dashboardName": "Failures analysis",
  "currentUserId": "1"
}', NULL, 10);
INSERT INTO widgets VALUES (15, 'TOTAL JIRA TICKETS - UPDATE', 'TABLE', NULL, NULL, false, '2019-04-12 15:38:34.280866', '2019-04-10 14:38:06.224265', NULL, '{
  "PROJECT": [],
  "hashcode": "1046730996",
  "dashboardName": "General"
}', NULL, 4);
INSERT INTO widgets VALUES (16, '30 DAYS PASS RATE BY PLATFORM (%)', 'BAR', NULL, NULL, false, '2019-04-15 10:38:45.883034', '2019-04-10 14:49:48.723434', NULL, '{
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
INSERT INTO widgets VALUES (17, '30 DAYS TEST DETAILS', 'TABLE', NULL, NULL, false, '2019-04-15 10:38:54.627733', '2019-04-12 14:37:07.987256', NULL, '{
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
INSERT INTO widgets VALUES (18, 'PERSONAL TOTAL TESTS (MAN-HOURS)', 'BAR', NULL, NULL, false, '2019-04-15 10:40:39.58197', '2019-04-12 19:44:24.392836', NULL, '{
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
INSERT INTO widgets VALUES (19, '30 DAYS TOTAL', 'PIE', NULL, NULL, false, '2019-04-15 10:38:36.857633', '2019-04-11 16:12:56.621207', '', '{
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
INSERT INTO widgets VALUES (20, 'PERSONAL TOTAL RATE', 'PIE', NULL, NULL, false, '2019-04-15 10:40:31.318444', '2019-04-12 19:46:34.965658', NULL, '{
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

-- 5 - general -> 1
INSERT INTO dashboards_widgets VALUES (1, 1, 37, NULL, NULL, '{"x":0,"y":22,"width":4,"height":11}', '2019-04-12 14:37:08.733432', '2019-04-12 14:37:08.733432');
INSERT INTO dashboards_widgets VALUES (2, 1, 16, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}', '2019-04-12 10:16:30.92815', '2019-04-10 14:49:49.346503');
INSERT INTO dashboards_widgets VALUES (3, 1, 19, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}', '2019-04-12 10:16:30.933576', '2019-04-11 16:12:57.357429');
INSERT INTO dashboards_widgets VALUES (4, 1, 5, NULL, NULL, '{"x":4,"y":22,"width":8,"height":11}', '2019-04-12 10:16:30.935221', '2019-04-12 10:16:16.228887');

-- 3 - Personal -> 2
INSERT INTO dashboards_widgets VALUES (5, 2, 10, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}', '2019-04-12 15:21:40.929194', '2019-04-12 10:17:25.758619');
INSERT INTO dashboards_widgets VALUES (6, 2, 1, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}', '2019-04-12 15:21:40.933438', '2019-04-11 16:26:43.870433');
INSERT INTO dashboards_widgets VALUES (7, 2, 2, NULL, NULL, '{"x":4,"y":0,"width":4,"height":11}', '2019-04-12 15:21:40.935308', '2019-04-11 16:28:22.917648');
INSERT INTO dashboards_widgets VALUES (8, 2, 9, NULL, NULL, '{"x":8,"y":0,"width":4,"height":11}', '2019-04-12 15:21:40.939274', '2019-04-11 16:32:22.41995');
INSERT INTO dashboards_widgets VALUES (9, 2, 6, NULL, NULL, '{"x":0,"y":74,"width":12,"height":9}', '2019-04-12 15:21:40.941096', '2019-04-12 15:21:29.312965');

-- 2 - Failures Analysis -> 3
INSERT INTO dashboards_widgets VALUES (10, 3, 12, NULL, NULL, '{"x":0,"y":0,"width":12,"height":12}', '2019-04-15 10:09:22.422597', '2019-04-12 18:58:34.301625');
INSERT INTO dashboards_widgets VALUES (11, 3, 14, NULL, NULL, '{"x":0,"y":12,"width":12,"height":10}', '2019-04-15 10:09:22.424598', '2019-04-12 19:22:04.478803');

-- 4 - User Performance -> 4
INSERT INTO dashboards_widgets VALUES (12, 4, 11, NULL, NULL, '{"x":0,"y":33,"width":12,"height":11}', '2019-04-12 19:52:52.522107', '2019-04-12 12:09:23.754724');
INSERT INTO dashboards_widgets VALUES (13, 4, 18, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}', '2019-04-12 19:52:52.526043', '2019-04-12 19:44:25.383665');
INSERT INTO dashboards_widgets VALUES (14, 4, 20, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}', '2019-04-12 19:52:52.540018', '2019-04-12 19:46:35.707561');
INSERT INTO dashboards_widgets VALUES (15, 4, 3, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}', '2019-04-12 19:52:52.546016', '2019-04-12 19:52:41.919465');


-- 1 - Stability -> 5
INSERT INTO dashboards_widgets VALUES (16, 5, 4, NULL, NULL, '{"x":0,"y":0,"width":4,"height":11}', '2019-04-12 21:41:05.363174', '2019-04-12 20:22:33.837217');
INSERT INTO dashboards_widgets VALUES (17, 5, 7, NULL, NULL, '{"x":0,"y":11,"width":12,"height":11}', '2019-04-12 21:41:05.365063', '2019-04-12 20:27:00.311224');
INSERT INTO dashboards_widgets VALUES (18, 5, 8, NULL, NULL, '{"x":0,"y":22,"width":12,"height":11}', '2019-04-12 21:41:05.366931', '2019-04-12 20:30:55.718724');
INSERT INTO dashboards_widgets VALUES (19, 5, 13, NULL, NULL, '{"x":4,"y":0,"width":8,"height":11}', '2019-04-12 21:41:05.368283', '2019-04-12 21:40:55.432269');




