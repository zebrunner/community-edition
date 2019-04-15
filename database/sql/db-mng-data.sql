SET SCHEMA 'management';

INSERT INTO tenancies (name) VALUES ('zafira');

INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (1, 'TESTS EXECUTION ROI (MAN-HOURS)', 'Monthly team/personal automation ROI by tests execution. 160+ hours per person for UI tests indicates your execution ROI is very good.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": join(PROJECT),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />

SELECT
      ROUND(SUM(TOTAL_SECONDS)/3600) AS "ACTUAL",
      ROUND(SUM(TOTAL_ETA_SECONDS)/3600) AS "ETA",
      to_char(CREATED_AT, ''YYYY-MM'') AS "CREATED_AT"
  FROM TOTAL_VIEW
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT";


  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
     <#if map[key] != "" >
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>

 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>
', '{
    "grid": {
        "right": "4%",
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
        "type": "category"
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
}', '{
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TOTAL_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM TOTAL_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-15 15:48:22.855454', '2019-04-09 12:38:01.466911', '{
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": ["DEMO", "PROD"],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": ["*"]
}', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (2, 'TEST CASE STABILITY TREND', 'Test case stability trend on monthly basis.', 'LINE', 'SELECT
      STABILITY as "STABILITY",
      100 - OMISSION - KNOWN_FAILURE - ABORTED as "FAILURE",
      100 - KNOWN_FAILURE - ABORTED as "OMISSION",
      to_char(date_trunc(''month'', TESTED_AT), ''YYYY-MM'') AS "TESTED_AT"
  FROM TEST_CASE_HEALTH_VIEW
  WHERE TEST_CASE_ID = ''${testCaseId}''
  ORDER BY "TESTED_AT"', '{
    "grid": {
        "right": "5%",
        "left": "5%",
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
        "boundaryGap": false
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
}', '{
}', '', '2019-04-15 16:10:05.202285', '2019-04-09 15:01:19.572092', '{
  "testCaseId": "1"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (3, 'PASS RATE', 'Pass rate percent with extra grouping by project, owner etc.', 'BAR', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >

<#global MULTIPLE_VALUES = {
  "PLATFORM": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": join(PROJECT),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT lower(${GROUP_BY}) AS "GROUP_FIELD",
      round (100.0 * sum( PASSED ) / sum(TOTAL), 0)::integer AS "PASSED",
      round (100.0 * sum( KNOWN_ISSUE ) / sum(TOTAL), 0)::integer AS "KNOWN ISSUE",
      round (100.0 * sum( QUEUED) / sum(TOTAL), 0)::integer AS "QUEUED",
      0 - round (100.0 * sum( FAILED ) / sum(TOTAL), 0)::integer AS "FAILED",
      0 - round (100.0 * sum( SKIPPED ) / sum(TOTAL), 0)::integer AS "SKIPPED",
      0 - round (100.0 * sum( ABORTED) / sum(TOTAL), 0)::integer AS "ABORTED"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "GROUP_FIELD"
  ORDER BY "GROUP_FIELD" DESC

  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
     <#if map[key] != "" >
      <#if PERIOD == "Total" && IGNORE_TOTAL_PARAMS?seq_contains(key)>
       <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, LANGUAGE, JOB_NAME-->
       <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>
 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "TOTAL_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "MONTHLY_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>', '{
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
        "GROUP_FIELD",
        "PASSED",
        "FAILED",
        "SKIPPED",
        "KNOWN ISSUE",
        "QUEUED",
        "ABORTED"
    ],
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
        }
    ]
}', '{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Total"
      ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "PLATFORM",
      "OWNER_USERNAME",
      "PROJECT",
      "DEVICE",
      "ENV",
      "APP_VERSION",
      "LOCALE",
      "LANGUAGE",
      "JOB_NAME",
      "PRIORITY",
      "FEATURE"
      ],
    "required": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TOTAL_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM TOTAL_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION <> '''' AND APP_VERSION IS NOT NULL",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE != ''''",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME <> '''' AND NAME IS NOT NULL",
    "multiple": true
  }
}
', '', '2019-04-15 16:13:13.922899', '2019-03-27 08:38:47.112148', '{
  "GROUP_BY": "PLATFORM",
  "PROJECT": [],
  "USER": [],
  "PLATFORM": [],
  "PLATFORM_VERSION": [],
  "BROWSER_VERSION": [],
  "DEVICE": [],
  "ENV": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PERIOD": "Last 30 Days"
}
', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (4, 'TOTAL JIRA TICKETS', 'Number of discovered and registered bugs by automation', 'TABLE', '<#global MULTIPLE_VALUES = {
  "PROJECTS.NAME": join(PROJECT)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />

SELECT
      PROJECTS.NAME AS "PROJECT",
      COUNT(DISTINCT WORK_ITEMS.JIRA_ID) AS "COUNT"
  FROM TEST_WORK_ITEMS
      INNER JOIN WORK_ITEMS ON TEST_WORK_ITEMS.WORK_ITEM_ID = WORK_ITEMS.ID
      INNER JOIN TEST_CASES ON WORK_ITEMS.TEST_CASE_ID = TEST_CASES.ID
      INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "PROJECT"
  ORDER BY "COUNT" DESC;


    <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "WHERE WORK_ITEMS.TYPE=''BUG'' " />
 <#list map?keys as key>
     <#if map[key] != "" >
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>
<#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>', '', '{
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-12 22:38:01.642146', '2019-04-09 15:54:48.757347', '{
  "PROJECT": []
}', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (5, 'PASS RATE TREND', 'Consolidated test status trend with ability to specify 10+ extra filters and grouping by hours, days, month etc.', 'LINE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": join(PROJECT),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "PLATFORM": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />
<#global CREATED_AT = getCreatedAt(PERIOD) />

SELECT
      ${CREATED_AT} AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED",
      sum( TOTAL ) AS "TOTAL"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "CREATED_AT"
  ORDER BY "CREATED_AT";

  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
     <#if map[key] != "" >
      <#if PERIOD == "Total" && IGNORE_TOTAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, LANGUAGE, JOB_NAME-->
        <#continue>
      </#if>
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>

 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>


<#--
    Retrieves actual CREATED_BY grouping  by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getCreatedAt value>
  <#local result = "to_char(date_trunc(''day'', CREATED_AT), ''YYYY-MM-DD'')" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "to_char(date_trunc(''hour'', CREATED_AT), ''MM-DD HH24:MI'')" />
    <#break>
  <#case "Nightly">
        <#local result = "to_char(date_trunc(''hour'', CREATED_AT), ''HH24:MI'')" />
    <#break>
  <#case "Last 7 Days">
  <#case "Last 14 Days">
  <#case "Last 30 Days">
  <#case "Weekly">
  <#case "Monthly">
        <#local result = "to_char(date_trunc(''day'', CREATED_AT), ''YYYY-MM-DD'')" />
    <#break>
  <#case "Total">
        <#local result = "to_char(date_trunc(''month'', CREATED_AT), ''YYYY-MM'')" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
  <#case "Total">
    <#local result = "TOTAL_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>', '{
    "grid": {
        "right": "4%",
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
}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Total"
      ],
    "required": true
  },
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM LAST30DAYS_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM LAST30DAYS_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM LAST30DAYS_VIEW WHERE DEVICE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM LAST30DAYS_VIEW WHERE APP_VERSION <> '''' AND APP_VERSION IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM LAST30DAYS_VIEW WHERE LOCALE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM LAST30DAYS_VIEW WHERE LANGUAGE IS NOT NULL AND LANGUAGE != '''' ORDER BY 1",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT JOB_NAME FROM LAST30DAYS_VIEW WHERE JOB_NAME <> '''' AND JOB_NAME IS NOT NULL ORDER BY 1",
    "multiple": true
  }
}
', '', '2019-04-15 16:14:16.909359', '2019-04-12 09:54:38.556068', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": []
}', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (6, 'TEST FAILURE COUNT', 'High level information about the similar errors.', 'TABLE', '
<#global VIEW = getView(PERIOD) />

SELECT ENV AS "ENV",
      count(*) as "COUNT",
          MESSAGE AS "Error Message",
          STABILITY_URL AS "STABILITY"
  FROM ${VIEW}
  WHERE MESSAGE_HASHCODE=''${hashcode}''
  GROUP BY MESSAGE, ENV, STABILITY_URL
  LIMIT 1

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

', '{"columns": ["ENV", "COUNT", "STABILITY", "Error Message"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days"
      ],
    "required": true
  }
}', '', '2019-04-15 16:12:13.352187', '2019-04-12 18:54:44.519344', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "1046730996"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (7, 'MONTHLY TEST IMPLEMENTATION PROGRESS', 'Number of new automated cases per week.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["USERS.USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECTS.NAME": join(PROJECT),
  "USERS.USERNAME": join(USER)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />

SELECT
      to_char(date_trunc(''month'', TEST_CASES.CREATED_AT), ''YYYY-MM'') AS "CREATED_AT",
      count(*) AS "AMOUNT"
  FROM TEST_CASES INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
  INNER JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID=USERS.ID
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY 1
  ORDER BY 1;


  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
     <#if map[key] != "" >
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND USERS.ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " USERS.ID=${currentUserId} "/>
 </#if>


 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>
', '{
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
        "type": "category"
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
}', '{
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-15 15:48:31.226114', '2019-04-09 13:04:34.054318', '{
  "PROJECT": [],
  "PERSONAL": "true",
  "currentUserId": 1,
  "USER": []
}', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (8, 'PASS RATE', 'Consolidated test status information with ability to specify 10+ extra filters including daily, weekly, monthly etc period.', 'PIE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": join(PROJECT),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "PLATFORM": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

<#if PERSONAL == "true" >
SELECT
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
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY OWNER_USERNAME

<#else>

SELECT
  unnest(array[''${PERIOD}'',
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
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
</#if>

<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
    <#if map[key] != "" >
      <#if PERIOD == "Total" && IGNORE_TOTAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, LANGUAGE, JOB_NAME-->
        <#continue>
      </#if>
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
    </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>


 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
  <#case "Total">
    <#local result = "TOTAL_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>
', '{
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
                "70%"
            ]
        }
    ]
}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Total"
      ],
    "required": true
  },
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "type": "radio",
    "required": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM LAST30DAYS_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM LAST30DAYS_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM LAST30DAYS_VIEW WHERE DEVICE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM LAST30DAYS_VIEW WHERE APP_VERSION <> '''' AND APP_VERSION IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM LAST30DAYS_VIEW WHERE LOCALE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM LAST30DAYS_VIEW WHERE LANGUAGE IS NOT NULL AND LANGUAGE != '''' ORDER BY 1",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT JOB_NAME FROM LAST30DAYS_VIEW WHERE JOB_NAME <> '''' AND JOB_NAME IS NOT NULL ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-15 16:13:22.662018', '2019-04-08 15:59:40.214693', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "currentUserId": 2,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": []
}
', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (9, 'TESTS FAILURES', 'Summarized information about tests failures grouped by reason.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": join(PROJECT),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "PLATFORM": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT count(*) AS "COUNT",
      ENV AS "ENV",
      ''<a href="dashboards/'' || (select ID from dashboards where title=''Failures analysis'') || ''?hashcode='' || max(MESSAGE_HASHCODE)  || ''">Failures Analysis</a>'' AS "REPORT",
      substring(MESSAGE from 1 for 210) as "MESSAGE"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "ENV", substring(MESSAGE from 1 for 210)
  ORDER BY "COUNT" DESC


<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
    <#if map[key] != "" >
      <#if PERIOD == "Total" && IGNORE_TOTAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, LANGUAGE, JOB_NAME-->
        <#continue>
      </#if>
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
    </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>


 <#if result?length != 0>
  <#local result = " WHERE MESSAGE IS NOT NULL AND " + result/>
 <#else>
  <#local result = " WHERE MESSAGE IS NOT NULL"/>
 </#if>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>', '{"columns": ["COUNT", "ENV", "REPORT", "MESSAGE"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Total"
      ],
    "required": true
  },
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TOTAL_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM TOTAL_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM LAST30DAYS_VIEW WHERE DEVICE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM LAST30DAYS_VIEW WHERE APP_VERSION <> '''' AND APP_VERSION IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM LAST30DAYS_VIEW WHERE LOCALE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM LAST30DAYS_VIEW WHERE LANGUAGE IS NOT NULL AND LANGUAGE != '''' ORDER BY 1",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT JOB_NAME FROM LAST30DAYS_VIEW WHERE JOB_NAME <> '''' AND JOB_NAME IS NOT NULL ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-15 16:14:27.496976', '2019-04-12 15:12:14.804581', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": []
}', false);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (10, 'TEST FAILURE DETAILS', 'All tests/jobs with the similar failure.', 'TABLE', '
<#global VIEW = getView(PERIOD) />

SELECT count(*) as "COUNT",
      ENV AS "ENV",
      TEST_INFO_URL AS "REPORT"
  FROM ${VIEW}
  WHERE substring(Message from 1 for 210)  IN (
      SELECT substring(Message from 1 for 210)
      FROM ${VIEW}
      WHERE MESSAGE_HASHCODE=''${hashcode}'')
  GROUP BY "ENV", "REPORT", substring(Message from 1 for 210)
  ORDER BY "COUNT" DESC, "ENV"

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>
', '{"columns": ["ENV", "REPORT"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days"
      ],
    "required": true
  }
}', '', '2019-04-15 16:12:13.352187', '2019-04-12 19:20:37.515495', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "38758212"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (11, 'TESTCASE INFO', 'Detailed test case information.', 'TABLE', 'SELECT
         TEST_CASES.ID AS "ID",
         TEST_CASES.TEST_CLASS AS "TEST CLASS",
         TEST_CASES.TEST_METHOD AS "TEST METHOD",
         TEST_SUITES.FILE_NAME AS "TEST SUITE",
         USERS.USERNAME AS "OWNER",
         TEST_CASES.CREATED_AT::date::text AS "CREATED AT"
         FROM TEST_CASES
         LEFT JOIN TEST_SUITES ON TEST_CASES.TEST_SUITE_ID = TEST_SUITES.ID
         LEFT JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID = USERS.ID
     WHERE TEST_CASES.ID = ''${testCaseId}''', '{"columns": ["ID", "TEST CLASS", "TEST METHOD", "TEST SUITE", "OWNER", "CREATED AT"]}', '{

}', '', '2019-04-15 16:12:13.352187', '2019-04-12 21:37:29.411124', '{
  "testCaseId": "1"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (12, 'TEST CASE DURATION TREND', 'All kind of duration metrics per test case.', 'LINE', 'SELECT
      AVG_TIME as "AVG TIME",
      MAX_TIME as "MAX TIME",
      MIN_TIME as "MIN TIME",
      to_char(date_trunc(''month'', TESTED_AT), ''YYYY-MM'') AS "TESTED_AT"
  FROM TEST_CASE_HEALTH_VIEW
  WHERE TEST_CASE_ID = ''${testCaseId}''
  ORDER BY "TESTED_AT"', '{
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
        "boundaryGap": false
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
}', '{
}', '', '2019-04-15 16:12:13.352187', '2019-04-09 15:09:23.010109', '{
  "testCaseId": "1"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (13, 'TEST CASE STABILITY', 'Aggregated stability metric for test case.', 'PIE', 'SELECT
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
      TEST_CASE_ID = ''${testCaseId}''
  GROUP BY TEST_METHOD_NAME', '{
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
                "70%"
            ]
        }
    ]
}', '{
}', '', '2019-04-15 16:12:13.352187', '2019-04-09 14:52:48.600982', '{
  "testCaseId": "1"
}', true);
INSERT INTO widget_templates (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (14, 'TESTS SUMMARY', 'Detailed information about passed, failed, skipped etc.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": join(PROJECT),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "PLATFORM": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT
        ''<a href="dashboards/'' || (select ID from dashboards where title=''Personal'') || ''?userId='' || OWNER_ID || ''">'' || OWNER_USERNAME || ''</a>'' AS "OWNER",
        SUM(PASSED) AS "PASS",
        SUM(FAILED) AS "FAIL",
        SUM(KNOWN_ISSUE) AS "DEFECT",
        SUM(SKIPPED) AS "SKIP",
        sum( QUEUED ) AS "QUEUE",
        SUM(TOTAL) AS "TOTAL"
    FROM ${VIEW}
    ${WHERE_MULTIPLE_CLAUSE}
    GROUP BY OWNER_ID, OWNER_USERNAME
    ORDER BY OWNER_USERNAME

<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />
 <#list map?keys as key>
    <#if map[key] != "" >
      <#if PERIOD == "Total" && IGNORE_TOTAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, LANGUAGE, JOB_NAME-->
        <#continue>
      </#if>
      <#if PERSONAL == "true" && IGNORE_PERSONAL_PARAMS?seq_contains(key)>
        <#-- Ignore non supported filters for Personal chart: USER -->
        <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
    </#if>
 </#list>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>


 <#if result?length != 0>
  <#local result = " WHERE " + result/>
 </#if>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#local result = "LAST24HOURS_VIEW" />
 <#switch value>
  <#case "Last 24 Hours">
    <#local result = "LAST24HOURS_VIEW" />
    <#break>
  <#case "Last 7 Days">
    <#local result = "LAST7DAYS_VIEW" />
    <#break>
  <#case "Last 14 Days">
    <#local result = "LAST14DAYS_VIEW" />
    <#break>
  <#case "Last 30 Days">
    <#local result = "LAST30DAYS_VIEW" />
    <#break>
  <#case "Nightly">
    <#local result = "NIGHTLY_VIEW" />
    <#break>
  <#case "Weekly">
    <#local result = "WEEKLY_VIEW" />
    <#break>
  <#case "Monthly">
    <#local result = "MONTHLY_VIEW" />
    <#break>
  <#case "Total">
    <#local result = "TOTAL_VIEW" />
    <#break>
 </#switch>
 <#return result>
</#function>

<#--
    Joins array values using '', '' separator
    @array - to join
    @return - joined array as string
  -->
<#function join array>
  <#return array?join('', '') />
</#function>', '{"columns": ["OWNER", "PASS", "FAIL", "DEFECT", "SKIP", "TOTAL"]}
', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Total"
      ],
    "required": true
  },
  "PERSONAL": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT DISTINCT PROJECT FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM LAST30DAYS_VIEW WHERE PLATFORM IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT DISTINCT OWNER_USERNAME FROM TOTAL_VIEW ORDER BY 1",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TOTAL_VIEW WHERE ENV IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT DISTINCT PRIORITY FROM TOTAL_VIEW WHERE PRIORITY IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT DISTINCT FEATURE FROM LAST30DAYS_VIEW WHERE FEATURE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM LAST30DAYS_VIEW WHERE DEVICE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM LAST30DAYS_VIEW WHERE APP_VERSION <> '''' AND APP_VERSION IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM LAST30DAYS_VIEW WHERE LOCALE IS NOT NULL ORDER BY 1",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM LAST30DAYS_VIEW WHERE LANGUAGE IS NOT NULL AND LANGUAGE != '''' ORDER BY 1",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT JOB_NAME FROM LAST30DAYS_VIEW WHERE JOB_NAME <> '''' AND JOB_NAME IS NOT NULL ORDER BY 1",
    "multiple": true
  }
}', '', '2019-04-15 16:14:08.764212', '2019-04-09 17:06:51.739459', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": []
}', false);


