SET SCHEMA 'management';

INSERT INTO tenancies (name) VALUES ('zafira');

INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (1, 'TESTS EXECUTION ROI (MAN-HOURS)', 'Monthly team/personal automation ROI by tests execution. 160+ hours per person for UI tests indicate that your execution ROI is very good.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
</#function>', '{
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
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  }
}', '', '2019-05-13 10:28:17.881423', '2019-04-09 12:38:01.466911', '{
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": ["DEMO", "PROD"],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": ["*"]
}', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (2, 'TEST CASE STABILITY TREND', 'Test case stability trend on a monthly basis.', 'LINE', 'SELECT
      STABILITY as "STABILITY",
      FAILURE as "FAILURE",
      OMISSION as "OMISSION",
      KNOWN_FAILURE as "KNOWN ISSUE",
      INTERRUPT as "INTERRUPT",
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
        "OMISSION",
        "KNOWN ISSUE",
        "INTERRUPT"
    ],
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {},
    "series": [
        {
            "type": "line",
            "z": 5,
            "stack": "Stack",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "z": 4,
            "stack": "Stack",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "z": 3,
            "stack": "Stack",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Stack",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Stack",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
}
', '', '2019-05-13 10:25:55.164779', '2019-04-09 15:01:19.572092', '{
  "testCaseId": "1"
}', true);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (3, 'PASS RATE (%)', 'Pass rate percent with an extra grouping by project, owner, etc.', 'BAR', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >

<#global MULTIPLE_VALUES = {
  "PLATFORM": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK)
}>

<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES, PARENT_JOB, PARENT_BUILD) />
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
<#function generateMultipleWhereClause map, PARENT_JOB, PARENT_BUILD>
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


 <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
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
    <#local result = "LAST30DAYS_VIEW" />
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
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
      "FEATURE",
      "TASK"
      ],
    "required": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}
', '', '2019-05-13 10:24:53.236555', '2019-03-27 08:38:47.112148', '{
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
  "TASK": [],
  "PERIOD": "Last 24 Hours",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": ""
}
', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (4, 'APPLICATION ISSUES (BLOCKERS) COUNT', 'A number of unique application bugs discovered and submitted by automation.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >

<#global MULTIPLE_VALUES = {
  "PLATFORM": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "JOB_NAME": join(JOB_NAME),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

  SELECT PROJECT AS "PROJECT",
      COUNT(DISTINCT BUG) AS "COUNT"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY PROJECT


  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />

  <#if BLOCKER="true">
   <#local result = " (KNOWN_ISSUE > 0) AND (TEST_BLOCKER=TRUE) "/>
 <#else>
   <#local result = " (KNOWN_ISSUE > 0)" />
 </#if>

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

  <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
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
    <#local result = "LAST30DAYS_VIEW" />
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
</#function>', '{"columns": ["PROJECT", "COUNT"]}', '{
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
  "BLOCKER": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}
', '', '2019-05-13 10:23:58.551598', '2019-04-09 15:54:48.757347', '{
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
  "TASK": [],
  "PERIOD": "Last 7 Days",
  "BLOCKER": "true",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "5"
}
', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (5, 'PASS RATE TREND', 'Consolidated test status trend with the ability to specify 10+ extra filters and grouping by hours, days, month, etc.', 'LINE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
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

 <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
 </#if>

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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
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
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
            "stack": "Status",
            "itemStyle": {
                "normal": {
                    "areaStyle": {
                        "opacity": 0.8,
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
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}
', '', '2019-05-13 10:25:08.036054', '2019-04-12 09:54:38.556068', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6"
}', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (6, 'TEST FAILURE COUNT', 'High-level information about similar errors.', 'TABLE', '
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
}', '', '2019-05-13 10:27:34.854807', '2019-04-12 18:54:44.519344', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "38758212"
}', true);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (7, 'MONTHLY TEST IMPLEMENTATION PROGRESS', 'A number of new automated cases per week.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["USERS.USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECTS.NAME": multiJoin(PROJECT, projects),
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
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
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  }
}', '', '2019-05-13 10:24:20.574745', '2019-04-09 13:04:34.054318', '{
  "PROJECT": ["AURONIA", "UNKNOWN"],
  "PERSONAL": "true",
  "currentUserId": 1,
  "USER": []
}', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (8, 'PASS RATE', 'Consolidated test status information with the ability to specify 10+ extra filters including daily, weekly, monthly, etc period.', 'PIE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
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

  <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
 </#if>

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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
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
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '', '2019-05-13 10:24:37.490566', '2019-04-08 15:59:40.214693', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "currentUserId": 2,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6"
}
', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (9, 'TESTS FAILURES BY REASON', 'Summarized information about tests failures grouped by reason.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "BUG": join(BUG),
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
      --TODO: add support for github issues somehow when ''/browse'' is not needed
      ''<a href="'' || (select VALUE from settings where name=''JIRA_URL'') || ''/browse/'' || BUG || ''" target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      ''<a href="dashboards/'' || (select ID from dashboards where title=''Failures analysis'') || ''?hashcode='' || max(MESSAGE_HASHCODE)  || ''">Failures Analysis</a>'' AS "REPORT",
      substring(MESSAGE from 1 for 210) as "MESSAGE"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "ENV", "BUG", "SUBJECT", substring(MESSAGE from 1 for 210)
  ORDER BY "COUNT" DESC


<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />

 <#if BLOCKER="true">
   <#local result = " (KNOWN_ISSUE > 0) AND (TEST_BLOCKER=TRUE) "/>
 </#if>

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

 <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
 </#if>

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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
</#function>', '{"columns": ["COUNT", "ENV", "BUG", "SUBJECT", "REPORT", "MESSAGE"]}', '{
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
  "BLOCKER": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "BUG": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''BUG'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["COUNT", "ENV", "BUG", "SUBJECT", "REPORT", "MESSAGE"]}', '2019-05-10 23:13:27.904029', '2019-04-12 15:12:14.804581', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "BLOCKER": "false",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (10, 'TEST FAILURE DETAILS', 'All tests/jobs with a similar failure.', 'TABLE', '
<#global VIEW = getView(PERIOD) />

SELECT count(*) as "COUNT",
      ENV AS "ENV",
      --TODO: add support for github issues somehow when ''/browse'' is not needed
      ''<a href="'' || (select VALUE from settings where name=''JIRA_URL'') || ''/browse/'' || BUG || ''" target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      TEST_INFO_URL AS "REPORT"
  FROM ${VIEW}
  WHERE substring(Message from 1 for 210)  IN (
      SELECT substring(Message from 1 for 210)
      FROM ${VIEW}
      WHERE MESSAGE_HASHCODE=''${hashcode}'')
  GROUP BY "ENV", "BUG", "SUBJECT", "REPORT", substring(Message from 1 for 210)
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
', '{"columns": ["ENV", "REPORT", "BUG", "SUBJECT"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days"
      ],
    "required": true
  }
}', '', '2019-05-13 10:27:49.47342', '2019-04-12 19:20:37.515495', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "-1996341284"
}', true);

INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (11, 'TESTCASE INFO', 'Detailed test case information.', 'TABLE', 'SELECT
         TEST_CASES.TEST_CLASS || ''.'' || TEST_CASES.TEST_METHOD AS "TEST METHOD",
         TEST_SUITES.FILE_NAME AS "TEST SUITE",
         USERS.USERNAME AS "OWNER",
         PROJECTS.NAME AS "PROJECT",
         TEST_CASES.CREATED_AT::date::text AS "CREATED AT"
         FROM TEST_CASES
         INNER JOIN TEST_SUITES ON TEST_CASES.TEST_SUITE_ID = TEST_SUITES.ID
         INNER JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID = USERS.ID
         INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
     WHERE TEST_CASES.ID = ''${testCaseId}''
', '{"columns": ["OWNER", "PROJECT", "TEST METHOD", "TEST SUITE", "CREATED AT"]}', '{

}', '', '2019-04-18 20:36:00.045515', '2019-04-12 21:37:29.411124', '{
  "testCaseId": "1"
}', true);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (12, 'TEST CASE DURATION TREND', 'All kind of duration metrics per test case.', 'LINE', 'SELECT
      ROUND(AVG_TIME::numeric, 2) as "AVG TIME",
      ROUND(MAX_TIME::numeric, 2) as "MAX TIME",
      ROUND(MIN_TIME::numeric, 2) as "MIN TIME",
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
}', '', '2019-05-01 14:09:14.130991', '2019-04-09 15:09:23.010109', '{
  "testCaseId": "1"
}', true);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (13, 'TEST CASE STABILITY', 'Aggregated stability metric for a test case.', 'PIE', 'SELECT
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
}', '', '2019-05-13 10:26:34.718292', '2019-04-09 14:52:48.600982', '{
  "testCaseId": "1"
}', true);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (14, 'TESTS SUMMARY', 'Detailed information about passed, failed, skipped, etc tests.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
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
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
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

  <#if PERIOD != "Total">
    <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
    <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
    </#if>
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
</#function>', '{"columns": ["OWNER", "PASS", "FAIL", "DEFECT", "SKIP", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "QUEUED (%)", "FAIL RATE (%)"]}
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
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["OWNER", "PASS", "FAIL", "DEFECT", "SKIP", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "QUEUED (%)", "FAIL RATE (%)"]}
', '2019-05-13 10:28:36.587561', '2019-04-09 17:06:51.739459', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6",
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": []
}', false);

INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (15, 'APPLICATION ISSUES (BLOCKERS) DETAILS', 'Detailed information about known issues and blockers.', 'TABLE', '<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "BUG": join(BUG),
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
      --TODO: add support for github issues somehow when ''/browse'' is not needed
      ''<a href="'' || (select VALUE from settings where name=''JIRA_URL'') || ''/browse/'' || BUG || ''" target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      ''<a href="'' || (select VALUE from settings where name=''JIRA_URL'') || ''/browse/'' || TASK || ''" target="_blank">'' || TASK || ''</a>'' AS "TASK",
      PROJECT AS "PROJECT",
      ENV AS "ENV",
      OWNER_USERNAME AS "OWNER",
      PLATFORM AS "PLATFORM",
      PLATFORM_VERSION AS "PLATFORM_VERSION",
      BROWSER AS "BROWSER",
      BROWSER_VERSION AS "BROWSER_VERSION",
      APP_VERSION AS "APP_VERSION",
      DEVICE AS "DEVICE",
      LOCALE AS "LOCALE",
      LANGUAGE AS "LANGUAGE",
      TEST_SUITE_NAME AS "SUITE NAME",
      TEST_INFO_URL AS "TEST_INFO_URL",
      MESSAGE AS "Error Message"
    FROM ${VIEW}
    ${WHERE_MULTIPLE_CLAUSE}


<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />

 <#if BLOCKER="true">
   <#local result = " (KNOWN_ISSUE > 0) AND (TEST_BLOCKER=TRUE) "/>
 <#else>
   <#local result = " (KNOWN_ISSUE > 0)" />
 </#if>

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

  <#if PERIOD != "Total">
  <#if PARENT_JOB != "" && PARENT_BUILD != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "'' AND UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD == "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB +
        "'' AND UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  </#if>
 </#if>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>

 <#local result = " WHERE " + result/>
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
<#function join array=[]>
  <#return array?join('', '') />
</#function>

<#--
    Joins array values using '', '' separator
    @array1 - to join, has higher priority that array2
    @array2 - alternative to join if array1 does not exist or is empty
    @return - joined array as string
  -->
<#function multiJoin array1=[] array2=[]>
  <#return ((array1?? && array1?size != 0) || ! array2??)?then(join(array1), join(array2)) />
</#function>', '{"columns": ["BUG", "SUBJECT", "TASK", "PROJECT", "ENV", "OWNER", "PLATFORM", "PLATFORM_VERSION", "BROWSER", "BROWSER_VERSION", "APP_VERSION", "DEVICE", "LOCALE", "LANGUAGE", "SUITE NAME", "TEST_INFO_URL", "Error Message"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days"
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
  "BLOCKER": {
    "values": [
      "false",
      "true"
      ],
    "required": true,
    "type": "radio"
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT PLATFORM FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "valuesQuery": "SELECT VALUE FROM TAGS WHERE NAME=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "TASK": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''TASK'' ORDER BY 1;",
    "multiple": true
  },
  "BUG": {
    "valuesQuery": "SELECT DISTINCT JIRA_ID FROM WORK_ITEMS WHERE TYPE=''BUG'' ORDER BY 1;",
    "multiple": true
  },
  "DEVICE": {
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '''' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "valuesQuery": "SELECT DISTINCT NAME FROM JOBS WHERE NAME IS NOT NULL AND NAME <> '''';",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["BUG", "SUBJECT", "TASK", "PROJECT", "ENV", "OWNER", "PLATFORM", "PLATFORM_VERSION", "BROWSER", "BROWSER_VERSION", "APP_VERSION", "DEVICE", "LOCALE", "LANGUAGE", "SUITE NAME", "TEST_INFO_URL", "Error Message"]}', '2019-05-10 15:19:40.90221', '2019-04-18 15:12:31.727154', '{
  "PERIOD": "Last 24 Hours",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "BUG": [],
  "PLATFORM": [],
  "DEVICE": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": [],
  "BLOCKER": "false",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6"
}', false);


INSERT INTO WIDGET_TEMPLATES (ID, NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES (16, 'TEST CASES BY STABILITY', 'Shows all test cases with low stability percent rate per appropriate period (default - less than 10%).', 'TABLE', '
<#--
  1. for "Last 24 Hours" or "Nightly" calculate stability on the fly using appropriate views
  2. for Monthly select STABILITY from TEST_CASE_HEALTH_VIEW for current month
  3. for Total calculate avg(STABILITY) overall by TEST_CASE_HEALTH_VIEW view data
  Note: all filters the rest
  -->

<#switch PERIOD>
  <#case "Last 24 Hours">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM LAST24HOURS_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Last 7 Days">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM LAST7DAYS_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Last 14 Days">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM LAST14DAYS_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Last 30 Days">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM LAST30DAYS_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Nightly">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM NIGHTLY_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Weekly">
    SELECT
      STABILITY_URL AS "TEST METHOD",
      ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
    FROM WEEKLY_VIEW
    GROUP BY "TEST METHOD"
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Monthly">
    SELECT STABILITY_URL AS "TEST METHOD",
      AVG(STABILITY) AS "STABILITY"
    FROM TEST_CASE_HEALTH_VIEW
      WHERE TESTED_AT = date_trunc(''month'', current_date)
    GROUP BY "TEST METHOD"
    HAVING AVG(STABILITY) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
  <#case "Total">
    SELECT STABILITY_URL AS "TEST METHOD",
      AVG(STABILITY) AS "STABILITY"
    FROM TEST_CASE_HEALTH_VIEW
    GROUP BY "TEST METHOD"
    HAVING AVG(STABILITY) < ${PERCENT}
    ORDER BY "STABILITY", "TEST METHOD"
    <#break>
 </#switch>

', '{"columns": ["TEST METHOD", "STABILITY"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Weekly",
      "Last 14 Days",
      "Last 30 Days",
      "Monthly",
      "Total"
      ],
    "required": true
  },
  "PERCENT": {
    "value": "10",
    "required": true
  }
}', '', '2019-05-13 10:27:12.670165', '2019-05-02 08:40:40.991813', '{
  "PERIOD": "Weekly",
  "PERCENT": 50
}', false);
