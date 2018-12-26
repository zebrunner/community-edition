SET SCHEMA 'zafira';

DO $$
-- Declare dashboards
DECLARE personal_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE user_performance_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE general_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE monthly_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE weekly_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE nightly_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE failures_dashboard_id DASHBOARDS.id%TYPE;
	DECLARE stability_dashboard_id DASHBOARDS.id%TYPE;
	-- Declare Stability dashboard widgets
	DECLARE stability_percent_id WIDGETS.id%TYPE;
	DECLARE stability_percent_sql WIDGETS.sql%TYPE;
	DECLARE stability_percent_model WIDGETS.model%TYPE;
	DECLARE test_case_info_id WIDGETS.id%TYPE;
	DECLARE test_case_info_sql WIDGETS.sql%TYPE;
	DECLARE test_case_info_model WIDGETS.model%TYPE;
	DECLARE stability_trend_id WIDGETS.id%TYPE;
	DECLARE stability_trend_sql WIDGETS.sql%TYPE;
	DECLARE stability_trend_model WIDGETS.model%TYPE;
	DECLARE test_execution_time_id WIDGETS.id%TYPE;
	DECLARE test_execution_time_sql WIDGETS.sql%TYPE;
	DECLARE test_execution_time_model WIDGETS.model%TYPE;

	-- Declare Failures dashboard widgets
	DECLARE error_message_id WIDGETS.id%TYPE;
	DECLARE error_message_sql WIDGETS.sql%TYPE;
	DECLARE error_message_model WIDGETS.model%TYPE;
	DECLARE detailed_failures_report_id WIDGETS.id%TYPE;
	DECLARE detailed_failures_report_sql WIDGETS.sql%TYPE;
	DECLARE detailed_failures_report_model WIDGETS.model%TYPE;
	DECLARE failures_count_id WIDGETS.id%TYPE;
	DECLARE failures_count_sql WIDGETS.sql%TYPE;
	DECLARE failures_count_model WIDGETS.model%TYPE;
	-- Declare Personal dashboard widgets
	DECLARE nightly_details_personal_id WIDGETS.id%TYPE;
	DECLARE nightly_details_personal_sql WIDGETS.sql%TYPE;
	DECLARE nightly_details_personal_model WIDGETS.model%TYPE;
	DECLARE monthly_total_personal_id WIDGETS.id%TYPE;
	DECLARE monthly_total_personal_sql WIDGETS.sql%TYPE;
	DECLARE monthly_total_personal_model WIDGETS.model%TYPE;
	DECLARE weekly_total_personal_id WIDGETS.id%TYPE;
	DECLARE weekly_total_personal_sql WIDGETS.sql%TYPE;
	DECLARE weekly_total_personal_model WIDGETS.model%TYPE;
	DECLARE nightly_total_personal_id WIDGETS.id%TYPE;
	DECLARE nightly_total_personal_sql WIDGETS.sql%TYPE;
	DECLARE nightly_total_personal_model WIDGETS.model%TYPE;
	DECLARE total_last_30_days_personal_id WIDGETS.id%TYPE;
	DECLARE total_last_30_days_personal_sql WIDGETS.sql%TYPE;
	DECLARE total_last_30_days_personal_model WIDGETS.model%TYPE;
	DECLARE nightly_personal_failures_id WIDGETS.id%TYPE;
	DECLARE nightly_personal_failures_sql WIDGETS.sql%TYPE;
	DECLARE nightly_personal_failures_model WIDGETS.model%TYPE;
	DECLARE nightly_personal_cron_id WIDGETS.id%TYPE;
	DECLARE nightly_personal_cron_sql WIDGETS.sql%TYPE;
	DECLARE nightly_personal_cron_model WIDGETS.model%TYPE;
	-- Declare User Performance dashboard widgets
	DECLARE personal_total_rate_id WIDGETS.id%TYPE;
	DECLARE personal_total_rate_sql WIDGETS.sql%TYPE;
	DECLARE personal_total_rate_model WIDGETS.model%TYPE;
	DECLARE personal_total_tests_man_hours_id WIDGETS.id%TYPE;
	DECLARE personal_total_tests_man_hours_sql WIDGETS.sql%TYPE;
	DECLARE personal_total_tests_man_hours_model WIDGETS.model%TYPE;
	DECLARE weekly_test_impl_progress_user_perf_id WIDGETS.id%TYPE;
	DECLARE weekly_test_impl_progress_user_perf_sql WIDGETS.sql%TYPE;
	DECLARE weekly_test_impl_progress_user_perf_model WIDGETS.model%TYPE;
	DECLARE total_tests_trend_id WIDGETS.id%TYPE;
	DECLARE total_tests_trend_sql WIDGETS.sql%TYPE;
	DECLARE total_tests_trend_model WIDGETS.model%TYPE;
	-- Declare General dashboard widgets
	DECLARE total_tests_count_id WIDGETS.id%TYPE;
	DECLARE total_tests_count_sql WIDGETS.sql%TYPE;
	DECLARE total_tests_count_model WIDGETS.model%TYPE;

	DECLARE total_tests_id WIDGETS.id%TYPE;
	DECLARE total_tests_sql WIDGETS.sql%TYPE;
	DECLARE total_tests_model WIDGETS.model%TYPE;
	DECLARE weekly_test_impl_progress_id WIDGETS.id%TYPE;
	DECLARE weekly_test_impl_progress_sql WIDGETS.sql%TYPE;
	DECLARE weekly_test_impl_progress_model WIDGETS.model%TYPE;
	DECLARE total_jira_tickets_id WIDGETS.id%TYPE;
	DECLARE total_jira_tickets_sql WIDGETS.sql%TYPE;
	DECLARE total_jira_tickets_model WIDGETS.model%TYPE;
	DECLARE total_tests_man_hours_id WIDGETS.id%TYPE;
	DECLARE total_tests_man_hours_sql WIDGETS.sql%TYPE;
	DECLARE total_tests_man_hours_model WIDGETS.model%TYPE;
	DECLARE total_tests_by_month_id WIDGETS.id%TYPE;
	DECLARE total_tests_by_month_sql WIDGETS.sql%TYPE;
	DECLARE total_tests_by_month_model WIDGETS.model%TYPE;
	-- Declare Monthly dashboard widgets
	DECLARE monthly_total_id WIDGETS.id%TYPE;
	DECLARE monthly_total_sql WIDGETS.sql%TYPE;
	DECLARE monthly_total_model WIDGETS.model%TYPE;
	DECLARE test_results_30_id WIDGETS.id%TYPE;
	DECLARE test_results_30_sql WIDGETS.sql%TYPE;
	DECLARE test_results_30_model WIDGETS.model%TYPE;
	DECLARE monthly_platform_pass_rate_id WIDGETS.id%TYPE;
	DECLARE monthly_platform_pass_rate_sql WIDGETS.sql%TYPE;
	DECLARE monthly_platform_pass_rate_model WIDGETS.model%TYPE;
	DECLARE monthly_details_id WIDGETS.id%TYPE;
	DECLARE monthly_details_sql WIDGETS.sql%TYPE;
	DECLARE monthly_details_model WIDGETS.model%TYPE;
	-- Declare Weekly dashboard widgets
	DECLARE weekly_total_id WIDGETS.id%TYPE;
	DECLARE weekly_total_sql WIDGETS.sql%TYPE;
	DECLARE weekly_total_model WIDGETS.model%TYPE;
	DECLARE weekly_test_results_id WIDGETS.id%TYPE;
	DECLARE weekly_test_results_sql WIDGETS.sql%TYPE;
	DECLARE weekly_test_results_model WIDGETS.model%TYPE;
	DECLARE weekly_platform_pass_rate_id WIDGETS.id%TYPE;
	DECLARE weekly_platform_pass_rate_sql WIDGETS.sql%TYPE;
	DECLARE weekly_platform_pass_rate_model WIDGETS.model%TYPE;
	DECLARE weekly_details_id WIDGETS.id%TYPE;
	DECLARE weekly_details_sql WIDGETS.sql%TYPE;
	DECLARE weekly_details_model WIDGETS.model%TYPE;
	-- Declare Nightly dashboard widgets
	DECLARE nightly_total_id WIDGETS.id%TYPE;
	DECLARE nightly_total_sql WIDGETS.sql%TYPE;
	DECLARE nightly_total_model WIDGETS.model%TYPE;
	DECLARE nightly_platform_pass_rate_id WIDGETS.id%TYPE;
	DECLARE nightly_platform_pass_rate_sql WIDGETS.sql%TYPE;
	DECLARE nightly_platform_pass_rate_model WIDGETS.model%TYPE;
	DECLARE nightly_details_id WIDGETS.id%TYPE;
	DECLARE nightly_details_sql WIDGETS.sql%TYPE;
	DECLARE nightly_details_model WIDGETS.model%TYPE;
	DECLARE nightly_person_pass_rate_id WIDGETS.id%TYPE;
	DECLARE nightly_person_pass_rate_sql WIDGETS.sql%TYPE;
	DECLARE nightly_person_pass_rate_model WIDGETS.model%TYPE;
	DECLARE nightly_failures_id WIDGETS.id%TYPE;
	DECLARE nightly_failures_sql WIDGETS.sql%TYPE;
	DECLARE nightly_failures_model WIDGETS.model%TYPE;

BEGIN
	-- Insert Stability dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Stability', TRUE, 8) RETURNING id INTO stability_dashboard_id;
	stability_percent_sql :=
	'SELECT
  unnest(array[''STABILITY'',
                  ''FAILURE'',
                  ''OMISSION'',
                  ''KNOWN ISSUE'',
                  ''INTERRUPT'']) AS "label",
  unnest(array[ROUND(AVG(STABILITY)::numeric, 0),
                   ROUND(AVG(FAILURE)::numeric, 0),
                   ROUND(AVG(OMISSION)::numeric, 0),
                   ROUND(AVG(KNOWN_FAILURE)::numeric, 0),
                   ROUND(AVG(INTERRUPT)::numeric, 0)]) AS "value"
  FROM TEST_CASE_HEALTH_VIEW
  WHERE
      TEST_CASE_ID = ''#{testCaseId}''';

	stability_percent_model :=
	'{
      "legend": {
          "orient": "vertical",
          "x": "left",
          "y": "center",
          "itemGap": 10,
          "textStyle": {
              "fontSize": 10
          },
          "formatter": "{name}"
      },
      "tooltip": {
          "trigger": "item",
          "axisPointer": {
              "type": "shadow"
          },
          "formatter": "{b0}<br>{d0}%"
      },
      "color": [
          "#61c8b3",
          "#e76a77",
          "#fddb7a",
          "#9f5487",
          "#b5b5b5"
      ],
      "series": [
          {
              "type": "pie",
              "selectedMode": "multi",
              "hoverOffset": 2,
              "clockwise": false,
              "stillShowZeroSum": false,
              "avoidLabelOverlap": true,
              "itemStyle": {
                  "normal": {
                      "label": {
                          "show": true,
                          "position": "outside",
                          "formatter": "{@value} ({d0}%)"
                      },
                      "labelLine": {
                          "show": true
                      }
                  },
                  "emphasis": {
                      "label": {
                          "show": true
                      }
                  }
              },
              "radius": [
                  "0%",
                  "75%"
              ]
          }
      ],
      "thickness": 20
  }';

	test_case_info_sql :=
	'SELECT
      TEST_CASES.ID AS "ID",
      TEST_CASES.TEST_CLASS AS "TEST CLASS",
      TEST_CASES.TEST_METHOD AS "TEST METHOD",
      TEST_SUITES.FILE_NAME AS "TEST SUITE",
      USERS.USERNAME AS "OWNER",
      TO_CHAR(TEST_CASES.CREATED_AT, ''MM/DD/YYYY'') AS "CREATED AT"
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
	'SELECT
      STABILITY as "STABILITY",
      100 - OMISSION - KNOWN_FAILURE - ABORTED as "FAILURE",
      100 - KNOWN_FAILURE - ABORTED as "OMISSION",
      date_trunc(''month'', TESTED_AT) AS "TESTED_AT"
  FROM TEST_CASE_HEALTH_VIEW
  WHERE TEST_CASE_ID = ''#{testCaseId}''
  ORDER BY "TESTED_AT"';

	stability_trend_model :=
	'{
      "grid": {
          "right": "2%",
          "left": "2%",
          "top": "8%",
          "bottom": "8%"
      },
      "legend": {},
      "tooltip": {
          "trigger": "axis"
      },
      "dimensions": [
          "TESTED_AT",
          "STABILITY",
          "FAILURE",
          "OMISSION"
      ],
      "color": [
          "#61c8b3",
          "#e76a77",
          "#fddb7a"
      ],
      "xAxis": {
          "type": "category",
          "boundaryGap": false,
          "axisLabel": {
              "formatter": "$filter | date: MMM dd$"
          }
      },
      "yAxis": {},
      "series": [
          {
              "type": "line",
              "z": 3,
              "itemStyle": {
                  "normal": {
                      "areaStyle": {
                          "opacity": 0.3,
                          "type": "default"
                      }
                  }
              },
              "lineStyle": {
                  "width": 1
              }
          },
          {
              "type": "line",
              "z": 2,
              "itemStyle": {
                  "normal": {
                      "areaStyle": {
                          "opacity": 0.3,
                          "type": "default"
                      }
                  }
              },
              "lineStyle": {
                  "width": 1
              }
          },
          {
              "type": "line",
              "z": 1,
              "itemStyle": {
                  "normal": {
                      "areaStyle": {
                          "opacity": 0.3,
                          "type": "default"
                      }
                  }
              },
              "lineStyle": {
                  "width": 1
              }
          }
      ]
  }';

	test_execution_time_sql =
	'SELECT
      AVG_TIME as "AVG TIME",
      MAX_TIME as "MAX TIME",
      MIN_TIME as "MIN TIME",
      date_trunc(''month'', TESTED_AT) AS "TESTED_AT"
  FROM TEST_CASE_HEALTH_VIEW
  WHERE TEST_CASE_ID = ''#{testCaseId}''
  ORDER BY "TESTED_AT"';

	test_execution_time_model =
	'{
      "grid": {
          "right": "2%",
          "left": "2%",
          "top": "8%",
          "bottom": "8%"
      },
      "legend": {},
      "tooltip": {
          "trigger": "axis"
      },
      "dimensions": [
          "TESTED_AT",
          "AVG TIME",
          "MAX TIME",
          "MIN TIME"
      ],
      "color": [
          "#61c8b3",
          "#e76a77",
          "#fddb7a"
      ],
      "xAxis": {
          "type": "category",
          "boundaryGap": false,
          "axisLabel": {
              "formatter": "$filter | date: MMM dd$"
          }
      },
      "yAxis": {},
      "series": [
          {
              "type": "line"
          },
          {
              "type": "line"
          },
          {
              "type": "line"
          }
      ]
}';
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('STABILITY (%)', 'echart', stability_percent_sql, stability_percent_model)
			RETURNING id INTO stability_percent_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TESTCASE INFO', 'table', test_case_info_sql, test_case_info_model)
			RETURNING id INTO test_case_info_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('STABILITY TREND (%)', 'echart', stability_trend_sql, stability_trend_model)
			RETURNING id INTO stability_trend_id;

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
	('TEST EXECUTION TIME DETAILS (sec)', 'echart', test_execution_time_sql, test_execution_time_model)
	RETURNING id INTO test_execution_time_id;
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(stability_dashboard_id, stability_percent_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(stability_dashboard_id, test_case_info_id, '{"x":4,"y":0,"width":8,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(stability_dashboard_id, stability_trend_id, '{"x":0,"y":11,"width":12,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
	(stability_dashboard_id, test_execution_time_id, '{"x":0,"y":22,"width":12,"height":11}');

	-- Insert Failures dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Failures analysis', TRUE, 5) RETURNING id INTO failures_dashboard_id;

	error_message_sql :=
	'SELECT Message AS "Error Message"
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
	'SELECT count(*) as "COUNT",
      Env AS "ENV",
      TEST_INFO_URL AS "REPORT",
      Rebuild AS "REBUILD"
  FROM NIGHTLY_FAILURES_VIEW
  WHERE substring(Message from 1 for 210)  IN (
      SELECT substring(Message from 1 for 210)
      FROM NIGHTLY_FAILURES_VIEW
      WHERE MESSAGE_HASHCODE=''#{hashcode}'')
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
	'SELECT
      Env AS "ENV",
      count(*) as "COUNT"
  FROM NIGHTLY_FAILURES_VIEW
  WHERE substring(Message from 1 for 210)  IN (
     SELECT substring(Message from 1 for 210)
  FROM NIGHTLY_FAILURES_VIEW
  WHERE MESSAGE_HASHCODE=''#{hashcode}'')
  GROUP BY "ENV"
  ORDER BY "COUNT" DESC
  ';

	failures_count_model :=
	'{
      "columns": [
          "ENV",
          "COUNT"
      ]
  }';

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('ERROR MESSAGE', 'table', error_message_sql, error_message_model)
			RETURNING id INTO error_message_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('DETAILED FAILURES REPORT', 'table', detailed_failures_report_sql, detailed_failures_report_model)
			RETURNING id INTO detailed_failures_report_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('FAILURES COUNT', 'table', failures_count_sql, failures_count_model)
			RETURNING id INTO failures_count_id;
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(failures_dashboard_id, error_message_id, '{"x":3,"y":0,"width":9,"height":14}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(failures_dashboard_id, detailed_failures_report_id, '{"x":0,"y":14,"width":12,"height":10}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(failures_dashboard_id, failures_count_id, '{"x":0,"y":0,"width":3,"height":14}');

	-- Insert Personal dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Personal', FALSE, 1) RETURNING id INTO personal_dashboard_id;

	nightly_details_personal_sql :=
	'SELECT
      OWNER_USERNAME as "OWNER",
      BUILD_NUMBER as "BUILD",
      ''<a href="#{zafiraURL}/#!/tests/runs/''||TEST_RUN_ID||''" target="_blank"> '' || TEST_SUITE_NAME ||'' </a>'' AS "REPORT",
      ZAFIRA_REPORT_URL as "ZAFIRA_REPORT",
      sum(Passed) || ''/'' || sum(FAILED) + sum(KNOWN_ISSUE) || ''/'' || sum(Skipped) as "P/F/S",
      REBUILD_URL as "REBUILD",
  CREATED_AT::text as "UPDATED"
  FROM NIGHTLY_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
  GROUP BY "OWNER", "BUILD", "REPORT", "ZAFIRA_REPORT", "REBUILD", "UPDATED"
  ORDER BY "BUILD" DESC
  ';

	nightly_details_personal_model :=
	'{
      "columns": [
          "OWNER",
          "BUILD",
          "REPORT",
          "ZAFIRA_REPORT",
          "P/F/S",
          "REBUILD",
          "UPDATED"
      ]
  }';

	monthly_total_personal_sql :=
	'SELECT
  unnest(array[OWNER_USERNAME,
                ''PASSED'',
                ''FAILED'',
                ''SKIPPED'',
                ''KNOWN ISSUE'',
                ''QUEUED'',
                ''ABORTED'']) AS "label",
       unnest(
        array[0,
            sum(PASSED),
            sum(FAILED),
            sum(SKIPPED),
            sum(KNOWN_ISSUE),
            sum(QUEUED),
            sum(ABORTED)]) AS "value"
  FROM MONTHLY_VIEW
  WHERE OWNER_ID = ''#{currentUserId}''
     AND PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY OWNER_USERNAME';

	monthly_total_personal_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#ffffff",
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ]
}';

	weekly_total_personal_sql :=
	'SELECT
  unnest(array[OWNER_USERNAME,
              ''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
     unnest(
      array[0,
          sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM WEEKLY_VIEW
  WHERE OWNER_ID = ''#{currentUserId}''
     AND PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY OWNER_USERNAME';

	weekly_total_personal_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#ffffff",
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ]
}';

	nightly_total_personal_sql :=
	'SELECT
  unnest(array[OWNER_USERNAME,
              ''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
     unnest(
      array[0,
          sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM NIGHTLY_VIEW
  WHERE OWNER_ID = ''#{currentUserId}''
     AND PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY OWNER_USERNAME';

	nightly_total_personal_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#ffffff",
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ]
}';


	total_last_30_days_personal_sql :=
	'SELECT
      TO_CHAR(CREATED_AT, ''MM/DD/YYYY'') AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED",
      sum( TOTAL ) AS "TOTAL"
  FROM THIRTY_DAYS_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
      AND PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY "CREATED_AT"
  UNION
  SELECT
      TO_CHAR(CREATED_AT, ''MM/DD/YYYY'') AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED",
      sum( TOTAL ) AS "TOTAL"
  FROM NIGHTLY_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
      AND PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT" ASC';

	total_last_30_days_personal_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "6%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "ABORTED",
        "QUEUED",
        "TOTAL"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#b5b5b5",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "smooth": false,
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "stack": "Status1",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        }
    ]
}';

	nightly_personal_failures_sql :=
	'SELECT count(*) AS "COUNT",
      ENV AS "ENV",
      ''<a href="#{zafiraURL}/#!/dashboards/2?hashcode='' || max(MESSAGE_HASHCODE)  || ''" target="_blank">Failures Analysis Report</a>''
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

	nightly_personal_cron_sql :=
	'SELECT
  ''<a href="''||UPSTREAM_JOB_URL||''" target="_blank">''||UPSTREAM_JOB_NAME||''</a>'' AS "NAME",
        OWNER_USERNAME as "OWNER",
        UPSTREAM_JOB_BUILD_NUMBER as "BUILD",
        SUM(PASSED) as "PASS",
        SUM(FAILED) as "FAIL",
        SUM(SKIPPED) as "SKIP",
          SUM(ABORTED) as "ABORTED",
  ''<a href="#{jenkinsURL}/job/Management_Jobs/job/smartJobsRerun/buildWithParameters?token=ciStart&ci_job_id=''||UPSTREAM_JOB_ID||''&ci_parent_build=''||UPSTREAM_JOB_BUILD_NUMBER||''&ci_user_id=''||OWNER_USERNAME||''&doRebuild=true&rerunFailures=false" id="cron_rerun" class="cron_rerun_all" target="_blank">Restart all</a>'' AS "RESTART ALL",
  ''<a href="#{jenkinsURL}/job/Management_Jobs/job/smartJobsRerun/buildWithParameters?token=ciStart&ci_job_id=''||UPSTREAM_JOB_ID||''&ci_parent_build=''||UPSTREAM_JOB_BUILD_NUMBER||''&ci_user_id=''||OWNER_USERNAME||''&doRebuild=true&rerunFailures=true" class="cron_rerun_failures" target="_blank">Restart failures</a>'' AS "RESTART FAILURES"
    FROM NIGHTLY_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
  GROUP BY "OWNER", "BUILD", "NAME", UPSTREAM_JOB_ID, UPSTREAM_JOB_URL
  ORDER BY "BUILD" DESC';

	nightly_personal_cron_model :=
	'{
      "columns": [
          "NAME",
          "BUILD",
          "OWNER",
          "PASS",
          "FAIL",
          "SKIP",
	        "ABORTED",
          "RESTART ALL",
          "RESTART FAILURES"
      ]
  }';

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY DETAILS PERSONAL', 'table', nightly_details_personal_sql, nightly_details_personal_model)
			RETURNING id INTO nightly_details_personal_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('MONTHLY TOTAL PERSONAL', 'echart', monthly_total_personal_sql, monthly_total_personal_model)
			RETURNING id INTO monthly_total_personal_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY TOTAL PERSONAL', 'echart', weekly_total_personal_sql, weekly_total_personal_model)
			RETURNING id INTO weekly_total_personal_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY TOTAL PERSONAL', 'echart', nightly_total_personal_sql, nightly_total_personal_model)
			RETURNING id INTO nightly_total_personal_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TEST RESULTS (LAST 30 DAYS) PERSONAL', 'echart', total_last_30_days_personal_sql, total_last_30_days_personal_model)
			RETURNING id INTO total_last_30_days_personal_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY - PERSONAL FAILURES', 'table', nightly_personal_failures_sql, nightly_personal_failures_model)
			RETURNING id INTO nightly_personal_failures_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY PERSONAL (CRON)', 'table', nightly_personal_cron_sql, nightly_personal_cron_model)
			RETURNING id INTO nightly_personal_cron_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, nightly_details_personal_id, '{"x":0,"y":28,"width":12,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, monthly_total_personal_id, '{"x":8,"y":0,"width":4,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, weekly_total_personal_id, '{"x":4,"y":0,"width":4,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, nightly_total_personal_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, total_last_30_days_personal_id, '{"x":0,"y":11,"width":12,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, nightly_personal_failures_id, '{"x":0,"y":39,"width":12,"height":6}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(personal_dashboard_id, nightly_personal_cron_id, '{"x":0,"y":22,"width":12,"height":6}');

	-- Insert User Performance dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('User Performance', TRUE, 6) RETURNING id INTO user_performance_dashboard_id;

	personal_total_rate_sql :=
	'SELECT
      OWNER_USERNAME AS "OWNER",
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
	'SELECT
      SUM(TOTAL_HOURS) AS "MAN-HOURS",
  CREATED_AT AS "CREATED_AT"
  FROM TOTAL_VIEW WHERE OWNER_ID = ''#{currentUserId}''
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT"';

	personal_total_tests_man_hours_model :=
	'{
      "grid": {
          "right": "2%",
          "left": "4%",
          "top": "8%",
          "bottom": "8%"
      },
      "legend": {
          "top": -5
      },
      "tooltip": {
          "trigger": "axis"
      },
      "dimensions": [
          "CREATED_AT",
          "MAN-HOURS"
      ],
      "xAxis": {
          "type": "category",
          "axisLabel": {
              "formatter": "$filter | date: MMM dd$"
          }
      },
      "yAxis": {},
      "series": [
          {
              "type": "bar"
          }
      ],
      "color": [
          "#7fbae3",
          "#919e8b"
      ]
  }';

	weekly_test_impl_progress_user_perf_sql :=
	'SELECT
      date_trunc(''week'', TEST_CASES.CREATED_AT)::date AS "CREATED_AT" ,
      count(*) AS "AMOUNT"
  FROM TEST_CASES INNER JOIN
      USERS ON TEST_CASES.PRIMARY_OWNER_ID=USERS.ID
  WHERE USERS.ID=''#{currentUserId}''
  GROUP BY 1
  ORDER BY 1;';

	weekly_test_impl_progress_user_perf_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "4%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {
        "top": -5
    },
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "AMOUNT"
    ],
    "color": [
        "#7fbae3",
        "#919e8b"
    ],
    "xAxis": {
        "type": "category",
        "axisLabel": {
            "formatter": "$filter | date: MMM dd$"
        }
    },
    "yAxis": {},
    "series": [
        {
            "type": "bar"
        },
        {
            "type": "line",
            "smooth": true,
            "lineStyle": {
                "type": "dotted"
            }
        }
    ]
}';

	total_tests_trend_sql :=
	'SELECT
      TO_CHAR(CREATED_AT, ''MM/DD/YYYY'') AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED",
      sum( TOTAL ) AS "TOTAL"
  FROM TOTAL_VIEW
  WHERE OWNER_ID=''#{currentUserId}''
  GROUP BY "CREATED_AT"';

	total_tests_trend_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "6%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "ABORTED",
        "QUEUED",
        "TOTAL"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#b5b5b5",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "smooth": false,
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "stack": "Status1",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        }
    ]
}';

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('PERSONAL TOTAL RATE', 'table', personal_total_rate_sql, personal_total_rate_model)
			RETURNING id INTO personal_total_rate_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('PERSONAL TOTAL TESTS (MAN-HOURS)', 'echart', personal_total_tests_man_hours_sql, personal_total_tests_man_hours_model)
			RETURNING id INTO personal_total_tests_man_hours_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY TEST IMPLEMENTATION PROGRESS (NUMBER OF TEST METHODS IMPLEMENTED BY PERSON)', 'echart', weekly_test_impl_progress_user_perf_sql, weekly_test_impl_progress_user_perf_model)
			RETURNING id INTO weekly_test_impl_progress_user_perf_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL TESTS TREND', 'echart', total_tests_trend_sql, total_tests_trend_model)
			RETURNING id INTO total_tests_trend_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(user_performance_dashboard_id, personal_total_rate_id, '{"x":0,"y":0,"height":11,"width":4}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(user_performance_dashboard_id, personal_total_tests_man_hours_id, '{"x":4,"y":0,"width":8,"height":12}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(user_performance_dashboard_id, weekly_test_impl_progress_user_perf_id, '{"x":0,"y":12,"width":12,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(user_performance_dashboard_id, total_tests_trend_id, '{"x":0,"y":23,"width":12,"height":12}');

	-- Insert General dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('General', FALSE, 0) RETURNING id INTO general_dashboard_id;

	total_tests_count_sql :=
	'SELECT
      PROJECT AS "PROJECT",
      sum(PASSED) AS "PASS",
      sum(FAILED) AS "FAIL",
      sum(KNOWN_ISSUE) AS "ISSUE",
      sum(SKIPPED) AS "SKIP",
      sum(QUEUED) AS "QUEUE",
      round (100.0 * sum(PASSED) / (sum(TOTAL)), 2) AS "PASS RATE"
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
      round (100.0 * sum(PASSED) / (sum(TOTAL)), 2) AS "PASS RATE"
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

	total_tests_sql :=
	'SELECT
  unnest(array[''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
      unnest(
      array[sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM TOTAL_VIEW
    WHERE
      PROJECT LIKE ANY (''{#{project}}'')';

	total_tests_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "85%"
            ]
        }
    ]
}';

	weekly_test_impl_progress_sql :=
	'SELECT
      date_trunc(''week'', TEST_CASES.CREATED_AT) AS "CREATED_AT",
      count(*) AS "AMOUNT"
  FROM TEST_CASES INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
  INNER JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID=USERS.ID
  WHERE PROJECTS.NAME LIKE ANY (''{#{project}}'')
  AND TEST_CASES.CREATED_AT > (current_date - interval ''1 year'')
  GROUP BY 1
  ORDER BY 1;';

	weekly_test_impl_progress_model :=
	'{
      "grid": {
          "right": "2%",
          "left": "4%",
          "top": "8%",
          "bottom": "8%"
      },
      "legend": {
          "top": -5
      },
      "tooltip": {
          "trigger": "axis"
      },
      "dimensions": [
          "CREATED_AT",
          "AMOUNT"
      ],
      "color": [
          "#7fbae3",
          "#919e8b"
      ],
      "xAxis": {
          "type": "category",
          "axisLabel": {
              "formatter": "$filter | date: MMM dd$"
          }
      },
      "yAxis": {},
      "series": [
          {
              "type": "bar"
          },
          {
              "type": "line",
              "smooth": true,
              "lineStyle": {
                  "type": "dotted"
              }
          }
      ]
  }';

	total_jira_tickets_sql :=
	'SELECT
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
	'SELECT
      SUM(TOTAL_HOURS) AS "ACTUAL",
      SUM(TOTAL_HOURS) AS "ETA",
      CREATED_AT AS "CREATED_AT"
  FROM TOTAL_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
      AND CREATED_AT < date_trunc(''month'', current_date)
  GROUP BY "CREATED_AT"
  UNION
  SELECT
      ROUND(SUM(TOTAL_SECONDS)/3600) AS "ACTUAL",
      ROUND(SUM(TOTAL_SECONDS)/3600/extract(day from current_date) * extract(day from date_trunc(''day'', date_trunc(''month'', current_date) + interval ''1 month'') - interval ''1 day'')) AS "ETA",
      date_trunc(''month'', current_date) AS "CREATED_AT"
  FROM MONTHLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT";';

	total_tests_man_hours_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "4%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {
        "top": -5
    },
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "ACTUAL",
        "ETA"
    ],
    "xAxis": {
        "type": "category",
        "axisLabel": {
            "formatter": "$filter | date: MMM dd$"
        }
    },
    "yAxis": {},
    "series": [
        {
            "type": "bar"
        },
        {
            "type": "line",
            "smooth": true,
            "lineStyle": {
                "type": "dashed"
            }
        }
    ],
    "color": [
        "#7fbae3",
        "#919e8b"
    ]
}';

	total_tests_by_month_sql =
	'SELECT
      date_trunc(''month'', CREATED_AT) AS "CREATED_AT",
      SUM(PASSED) as "PASSED",
      SUM(FAILED) AS "FAILED",
      SUM(SKIPPED) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      SUM(ABORTED) AS "ABORTED",
      SUM(QUEUED) AS "QUEUED",
      SUM(TOTAL) AS "TOTAL"
  FROM TOTAL_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  AND CREATED_AT < date_trunc(''month'', current_date)
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT"';

	total_tests_by_month_model =
	'{
    "grid": {
        "right": "2%",
        "left": "6%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "ABORTED",
        "TOTAL"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5",
        "#D3D3D3"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false,
        "axisLabel": {
            "formatter": "$filter | date: yyyy MMM $"
        }
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        }
    ]
}';

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL TESTS (COUNT)', 'table', total_tests_count_sql, total_tests_count_model)
			RETURNING id INTO total_tests_count_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL TESTS', 'echart', total_tests_sql, total_tests_model)
			RETURNING id INTO total_tests_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY TEST IMPLEMENTATION PROGRESS', 'echart', weekly_test_impl_progress_sql, weekly_test_impl_progress_model)
			RETURNING id INTO weekly_test_impl_progress_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL JIRA TICKETS', 'table', total_jira_tickets_sql, total_jira_tickets_model)
			RETURNING id INTO total_jira_tickets_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL TESTS (MAN-HOURS)', 'echart', total_tests_man_hours_sql, total_tests_man_hours_model)
			RETURNING id INTO total_tests_man_hours_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TOTAL TESTS (BY MONTH)', 'echart', total_tests_by_month_sql, total_tests_by_month_model)
			RETURNING id INTO total_tests_by_month_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, total_tests_man_hours_id, '{"x":4,"y":0,"width":8,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, total_tests_id, '{"x":0,"y":0,"width":4,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, total_tests_count_id, '{"x":0,"y":11,"width":4,"height":8}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, weekly_test_impl_progress_id, '{"x":4,"y":11,"height":11,"width":8}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, total_jira_tickets_id, '{"x":0,"y":19,"width":4,"height":6}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(general_dashboard_id, total_tests_by_month_id, '{"x":4,"y":33,"width":8,"height":11}');

	-- Insert Monthly dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Monthly Regression', FALSE, 4) RETURNING id INTO monthly_dashboard_id;

	monthly_total_sql :=
	'SELECT
  unnest(array[''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
     unnest(
      array[sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM MONTHLY_VIEW
    WHERE
      PROJECT LIKE ANY (''{#{project}}'')';

	monthly_total_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ],
    "thickness": 20
}';

	test_results_30_sql :=
	'SELECT
      TO_CHAR(CREATED_AT, ''MM/DD/YYYY'') AS "CREATED_AT",
      sum(PASSED) AS "PASSED",
      sum(FAILED) AS "FAILED",
      sum(KNOWN_ISSUE) AS "KNOWN_ISSUE",
      sum(SKIPPED) AS "SKIPPED",
      sum(IN_PROGRESS) AS "IN_PROGRESS",
      sum(ABORTED) AS "ABORTED"
  FROM THIRTY_DAYS_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT";';

	test_results_30_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "4%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN_ISSUE",
        "IN_PROGRESS",
        "ABORTED"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false,
        "axisLabel": {
            "formatter": "$filter | date: MMM dd$"
        }
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "smooth": false,
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "stack": "Status1",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        }
    ]
}';

	monthly_platform_pass_rate_sql :=
	'SELECT PLATFORM AS "PLATFORM",
      round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED",
      round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE",
      round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED",
      0 - round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED",
      0 - round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED",
      0 - round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED"
  FROM MONTHLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY PLATFORM
  ORDER BY PLATFORM';

	monthly_platform_pass_rate_model :=
	'{
    "tooltip": {
        "trigger": "axis",
        "axisPointer": {
            "type": "shadow"
        }
    },
    "legend": {
        "data": [
            "PASSED",
            "FAILED",
            "SKIPPED",
            "KNOWN ISSUE",
            "QUEUED",
            "ABORTED"
        ]
    },
    "grid": {
        "left": "5%",
        "right": "5%",
        "bottom": "3%",
        "containLabel": true
    },
    "xAxis": [
        {
            "type": "value"
        }
    ],
    "yAxis": [
        {
            "type": "category",
            "axisTick": {
                "show": false
            }
        }
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "dimensions": [
        "PLATFORM",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "QUEUED",
        "ABORTED"
    ],
    "height": {
        "dataItemValue": 100
    },
    "series": [
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack-queued",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        }
    ]
}';

	monthly_details_sql :=
	'SELECT
      OWNER_USERNAME AS "OWNER",
      ''<a href="#{zafiraURL}/#!/dashboards/3?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER_USERNAME || '' - Personal Board</a>'' AS "REPORT",
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
  GROUP BY OWNER_ID, OWNER_USERNAME
  ORDER BY OWNER_USERNAME';

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

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('MONTHLY TOTAL', 'echart', monthly_total_sql, monthly_total_model)
			RETURNING id INTO monthly_total_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TEST RESULTS (LAST 30 DAYS)', 'echart', test_results_30_sql, test_results_30_model)
			RETURNING id INTO test_results_30_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('MONTHLY PASS RATE BY PLATFORM (%)', 'echart', monthly_platform_pass_rate_sql, monthly_platform_pass_rate_model)
			RETURNING id INTO monthly_platform_pass_rate_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('MONTHLY DETAILS', 'table', monthly_details_sql, monthly_details_model)
			RETURNING id INTO monthly_details_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(monthly_dashboard_id, monthly_total_id, '{"x":0,"y":0,"height":11,"width":4}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(monthly_dashboard_id, test_results_30_id, '{"x":4,"y":0,"height":11,"width":8}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(monthly_dashboard_id, monthly_platform_pass_rate_id, '{"x":0,"y":11,"width":12,"height":14}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(monthly_dashboard_id, monthly_details_id, '{"x":0,"y":25,"height":6,"width":12}');

	-- Insert Weekly dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Weekly Regression', FALSE, 3) RETURNING id INTO weekly_dashboard_id;

	weekly_total_sql :=
	'SELECT
  unnest(array[''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
     unnest(
      array[sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM WEEKLY_VIEW
  WHERE
  PROJECT LIKE ANY (''{#{project}}'')';

	weekly_total_model := '{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ],
    "thickness": 20
}';

	weekly_test_results_sql :=
	'SELECT
      TO_CHAR(CREATED_AT, ''MM/DD/YYYY'') AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED",
      sum( TOTAL ) AS "TOTAL"
  FROM WEEKLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY "CREATED_AT"';

	weekly_test_results_model :=
	'{
    "grid": {
        "right": "2%",
        "left": "6%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis"
    },
    "dimensions": [
        "CREATED_AT",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "ABORTED",
        "QUEUED",
        "TOTAL"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#b5b5b5",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "smooth": false,
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "stack": "Status1",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        },
        {
            "type": "line",
            "smooth": false,
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.3,
                        "type": "default"
                    }
                }
            },
            "lineStyle": {
                "width": 1
            }
        }
    ]
}';

	weekly_platform_pass_rate_sql :=
	'SELECT PLATFORM AS "PLATFORM",
      round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED",
      round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE",
      round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED",
      0 - round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED",
      0 - round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED",
      0 - round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED"
  FROM WEEKLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY PLATFORM
  ORDER BY PLATFORM';

	weekly_platform_pass_rate_model :=
	'{
    "tooltip": {
        "trigger": "axis",
        "axisPointer": {
            "type": "shadow"
        }
    },
    "legend": {
        "data": [
            "PASSED",
            "FAILED",
            "SKIPPED",
            "KNOWN ISSUE",
            "QUEUED",
            "ABORTED"
        ]
    },
    "grid": {
        "left": "5%",
        "right": "5%",
        "bottom": "3%",
        "containLabel": true
    },
    "xAxis": [
        {
            "type": "value"
        }
    ],
    "yAxis": [
        {
            "type": "category",
            "axisTick": {
                "show": false
            }
        }
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "dimensions": [
        "PLATFORM",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "QUEUED",
        "ABORTED"
    ],
    "height": {
        "dataItemValue": 100
    },
    "series": [
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack-queued",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        }
    ]
}';

	weekly_details_sql :=
	'SELECT
        OWNER_USERNAME AS "OWNER",
        ''<a href="#{zafiraURL}/#!/dashboards/3?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER_USERNAME || '' - Personal Board</a>'' AS "REPORT",
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
   GROUP BY OWNER_ID, OWNER_USERNAME
   ORDER BY OWNER_USERNAME';

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

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY TOTAL', 'echart', weekly_total_sql, weekly_total_model)
			RETURNING id INTO weekly_total_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('TEST RESULTS (WEEKLY)', 'echart', weekly_test_results_sql, weekly_test_results_model)
			RETURNING id INTO weekly_test_results_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY PASS RATE BY PLATFORM (%)', 'echart', weekly_platform_pass_rate_sql, weekly_platform_pass_rate_model)
			RETURNING id INTO weekly_platform_pass_rate_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('WEEKLY DETAILS', 'table', weekly_details_sql, weekly_details_model)
			RETURNING id INTO weekly_details_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(weekly_dashboard_id, weekly_total_id, '{"x":0,"y":0,"height":11,"width":4}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(weekly_dashboard_id, weekly_test_results_id, '{"x":4,"y":0,"height":11,"width":8}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(weekly_dashboard_id, weekly_platform_pass_rate_id, '{"x":0,"y":11,"width":12,"height":17}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(weekly_dashboard_id, weekly_details_id, '{"x":0,"y":28,"height":6,"width":12}');

	-- Insert Nightly dashboard data
	INSERT INTO DASHBOARDS (TITLE, HIDDEN, POSITION) VALUES ('Nightly Regression', FALSE, 2) RETURNING id INTO nightly_dashboard_id;

	nightly_total_sql :=
	'SELECT
  unnest(array[MIN(CREATED_AT)::text,
              ''PASSED'',
              ''FAILED'',
              ''SKIPPED'',
              ''KNOWN ISSUE'',
              ''QUEUED'',
              ''ABORTED'']) AS "label",
     unnest(
      array[0,
          sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
          sum(QUEUED),
          sum(ABORTED)]) AS "value"
  FROM NIGHTLY_VIEW
  WHERE
  PROJECT LIKE ANY (''{#{project}}'')';

	nightly_total_model :=
	'{
    "legend": {
        "orient": "vertical",
        "x": "left",
        "y": "center",
        "itemGap": 10,
        "textStyle": {
            "fontSize": 10
        },
        "formatter": "{name}"
    },
    "tooltip": {
        "trigger": "item",
        "axisPointer": {
            "type": "shadow"
        },
        "formatter": "{b0}<br>{d0}%"
    },
    "color": [
        "#ffffff",
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "series": [
        {
            "type": "pie",
            "selectedMode": "multi",
            "hoverOffset": 2,
            "clockwise": false,
            "stillShowZeroSum": false,
            "avoidLabelOverlap": true,
            "itemStyle": {
                "normal": {
                    "label": {
                        "show": true,
                        "position": "outside",
                        "formatter": "{@value} ({d0}%)"
                    },
                    "labelLine": {
                        "show": true
                    }
                },
                "emphasis": {
                    "label": {
                        "show": true
                    }
                }
            },
            "radius": [
                "0%",
                "75%"
            ]
        }
    ],
    "thickness": 20
}';

	nightly_platform_pass_rate_sql :=
	'SELECT PLATFORM AS "PLATFORM",
      round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED",
      round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE",
      round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED",
      0 - round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED",
      0 - round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED",
      0 - round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED"
  FROM NIGHTLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY PLATFORM
  ORDER BY PLATFORM';

	nightly_platform_pass_rate_model :=
	'{
    "tooltip": {
        "trigger": "axis",
        "axisPointer": {
            "type": "shadow"
        }
    },
    "legend": {
        "data": [
            "PASSED",
            "FAILED",
            "SKIPPED",
            "KNOWN ISSUE",
            "QUEUED",
            "ABORTED"
        ]
    },
    "grid": {
        "left": "5%",
        "right": "5%",
        "bottom": "3%",
        "containLabel": true
    },
    "xAxis": [
        {
            "type": "value"
        }
    ],
    "yAxis": [
        {
            "type": "category",
            "axisTick": {
                "show": false
            }
        }
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "dimensions": [
        "PLATFORM",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "QUEUED",
        "ABORTED"
    ],
    "height": {
        "dataItemValue": 80
    },
    "series": [
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside",
                    "formatter": "{@PASSED}%"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside",
                    "formatter": "{@FAILED}%"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": false,
                    "position": "inside",
                    "formatter": "{@SKIPPED}%"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside",
                    "formatter": "{@KNOWN ISSUE}%"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside",
                    "formatter": "{@QUEUED}%"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside",
                    "formatter": "{@ABORTED}%"
                }
            }
        }
    ]
}';

	nightly_details_sql :=
	'SELECT
        ''<a href="#{zafiraURL}/#!/dashboards/3?userId='' || OWNER_ID || ''" target="_blank">'' || OWNER_USERNAME || ''</a>'' AS "OWNER",
        SUM(PASSED) AS "PASSED",
        SUM(FAILED) AS "FAILED",
        SUM(KNOWN_ISSUE) AS "KNOWN ISSUE",
        SUM(SKIPPED) AS "SKIPPED",
        sum( QUEUED ) AS "QUEUED",
        SUM(TOTAL) AS "TOTAL"
    FROM NIGHTLY_VIEW
    WHERE
      PROJECT LIKE ANY (''{#{project}}'')
    GROUP BY OWNER_ID, OWNER_USERNAME
    ORDER BY OWNER_USERNAME';

	nightly_details_model :=
	'{
      "columns": [
          "OWNER",
          "PASSED",
          "FAILED",
          "KNOWN ISSUE",
          "TOTAL"
      ]
  }';

	nightly_person_pass_rate_sql :=
	'SELECT OWNER_USERNAME AS "OWNER",
      round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED",
      round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE",
      round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED",
      0 - round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED",
      0 - round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED",
      0 - round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED"
  FROM NIGHTLY_VIEW
  WHERE PROJECT LIKE ANY (''{#{project}}'')
  GROUP BY OWNER_USERNAME
  ORDER BY OWNER_USERNAME';

	nightly_person_pass_rate_model :=
	'{
    "tooltip": {
        "trigger": "axis",
        "axisPointer": {
            "type": "shadow"
        }
    },
    "legend": {
        "data": [
            "PASSED",
            "FAILED",
            "SKIPPED",
            "KNOWN ISSUE",
            "QUEUED",
            "ABORTED"
        ]
    },
    "grid": {
        "left": "5%",
        "right": "5%",
        "bottom": "3%",
        "containLabel": true
    },
    "xAxis": [
        {
            "type": "value"
        }
    ],
    "yAxis": [
        {
            "type": "category",
            "axisTick": {
                "show": false
            }
        }
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
    ],
    "dimensions": [
        "OWNER",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "QUEUED",
        "ABORTED"
    ],
    "height": {
        "dataItemValue": 160
    },
    "series": [
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack-queued",
            "label": {
                "normal": {
                    "show": true,
                    "position": "inside"
                }
            }
        },
        {
            "type": "bar",
            "stack": "stack",
            "label": {
                "normal": {
                    "show": true,
                    "position": "left"
                }
            }
        }
    ]
}';

	nightly_failures_sql :=
	'SELECT count(*) AS "COUNT",
      ''<a href="#{zafiraURL}/#!/dashboards/2?hashcode='' || max(MESSAGE_HASHCODE)  || ''" target="_blank">Failures Analysis Report</a>'' AS "REPORT",
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

	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY TOTAL', 'echart', nightly_total_sql, nightly_total_model)
			RETURNING id INTO nightly_total_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY PASS RATE BY PLATFORM (%)', 'echart', nightly_platform_pass_rate_sql, nightly_platform_pass_rate_model)
			RETURNING id INTO nightly_platform_pass_rate_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY DETAILS', 'table', nightly_details_sql, nightly_details_model)
			RETURNING id INTO nightly_details_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY PASS RATE BY PERSON (%)', 'echart', nightly_person_pass_rate_sql, nightly_person_pass_rate_model)
			RETURNING id INTO nightly_person_pass_rate_id;
	INSERT INTO WIDGETS (TITLE, TYPE, SQL, MODEL) VALUES
																											 ('NIGHTLY FAILURES', 'table', nightly_failures_sql, nightly_failures_model)
			RETURNING id INTO nightly_failures_id;

	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(nightly_dashboard_id, nightly_total_id, '{"x":0,"y":0,"height":11,"width":4}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(nightly_dashboard_id, nightly_platform_pass_rate_id, '{"x":4,"y":0,"width":8,"height":11}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(nightly_dashboard_id, nightly_details_id, '{"x":0,"y":11,"width":4,"height":7}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(nightly_dashboard_id, nightly_person_pass_rate_id, '{"x":4,"y":11,"width":8,"height":7}');
	INSERT INTO DASHBOARDS_WIDGETS (DASHBOARD_ID, WIDGET_ID, LOCATION) VALUES
																																						(nightly_dashboard_id, nightly_failures_id, '{"x":0,"y":18,"width":12,"height":6}');

END$$;
