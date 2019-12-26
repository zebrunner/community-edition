SET SCHEMA 'management';

INSERT INTO tenancies (name) VALUES ('zafira');


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TESTS EXECUTION ROI (MAN-HOURS)', 'Monthly team/personal automation ROI by tests execution. 160+ hours per person for UI tests indicate that your execution ROI is very good.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST CASE STABILITY TREND', 'Test case stability trend on a monthly basis.', 'LINE', 'SELECT
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


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('PASS RATE (%)', 'Pass rate percent with an extra grouping by project, owner, etc.', 'BAR', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK)
}>

<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES, PARENT_JOB, PARENT_BUILD) />
<#global VIEW = getView(PERIOD) />

SELECT lower(${GROUP_BY}) AS "GROUP_FIELD",
      CASE
        WHEN sum( PASSED ) != 0 THEN sum( PASSED )
      END AS "PASSED",
      CASE
        WHEN sum( KNOWN_ISSUE ) != 0 THEN sum( KNOWN_ISSUE )
      END AS "KNOWN ISSUE",
      CASE
        WHEN sum( QUEUED ) != 0 THEN sum( QUEUED )
      END AS "QUEUED",
      CASE
        WHEN sum( FAILED ) != 0 THEN 0 - sum( FAILED )
      END AS "FAILED",
      CASE
        WHEN sum( SKIPPED ) != 0 THEN  0 - sum( SKIPPED )
      END AS "SKIPPED",
      CASE
        WHEN sum( ABORTED ) != 0 THEN 0 - sum( ABORTED )
      END AS "ABORTED"
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
</#function>', 'setTimeout( function() {

  const dimensions = ["GROUP_FIELD","PASSED","FAILED","SKIPPED","KNOWN ISSUE","QUEUED","ABORTED"];
  let note = true;

  const createSource = () => {
    let source = [];
    let amount = dataset.length;
    for (let i = 0; i < amount; i++) {
      let sourceData = [];
      dimensions.forEach((value, index) => sourceData.push(dataset[i][value]));
      source.push(sourceData);
    }
    return source;
  };

  let numberDataSource = createSource();
  let percentDataSource = [];

  const createPercentSource = (value, total) => {
    let temporaryArr = [];
    value.map( a => {
      if (typeof a === "number")  a = Math.round(100 * a / total , 0);
			temporaryArr.push(a);
    });
    percentDataSource.push(temporaryArr);
  };

  getTotalValue = (value) => {
    let total = 0;
    value.map( a => {
      if (typeof a === "number") total += a > 0 ? a : a * -1
    });
    return total;
  };

  numberDataSource.forEach((value) => {
    let total = getTotalValue(value);
    createPercentSource(value, total);
  });

  formatterFunc = (params, index, plus) => {
    let total = getTotalValue(params.value);
    let controlValue = params.value[index] * 100 / total;
    controlValue = controlValue > 0 ? controlValue : controlValue * -1;
    if (controlValue > 5) return `${params.value[index]}${plus ? "%" : ""}`;
    else return '';
  };

  let option = {
    title: {
      text: "Note: click on bar to show absolute numbers",
      textStyle: {
        color: "grey",
        fontWeight: "100",
        fontSize: 14
      },
      right: "5%",
      top: "94%"
    },
      tooltip: {
        trigger: "axis",
        axisPointer: {
          type: "shadow"
        }
      },
      legend: {},
      grid: {
        show: true,
        top: 40,
        left: "5%",
        right: "5%",
        bottom: 20,
        containLabel: true
      },
      xAxis: [{
          type: "value"
        }],
      yAxis: [{
          type: "category",
          axisTick: {
            show: false
          }
        }],
      color: [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#6dbbe7",
        "#b5b5b5"
      ],
      dataset: {
        source: percentDataSource
      },
      dimensions: dimensions,
      series: [
        {
          type: "bar",
          name: "PASSED",
          stack: "stack",
          label: {
            normal: {
              show: true,
              position: "inside",
              formatter: (params) => formatterFunc(params, 1, note)
            }
          }
        },
        {
          type: "bar",
          name: "FAILED",
          stack: "stack",
          label: {
            normal: {
                show: true,
                position: "inside",
                formatter: (params) => formatterFunc(params, 2, note)
            }
          }
        },
        {
          type: "bar",
          name: "SKIPPED",
          stack: "stack",
          label: {
            normal: {
                show: true,
                position: "inside",
                formatter: (params) => formatterFunc(params, 3, note)
            }
          }
        },
        {
          type: "bar",
          name: "KNOWN ISSUE",
          stack: "stack",
          label: {
            normal: {
                show: true,
                position: "inside",
                formatter: (params) => formatterFunc(params, 4, note)
            }
          }
        },
        {
          type: "bar",
          name: "QUEUED",
          stack: "stack",
          label: {
            normal: {
                show: true,
                position: "inside",
                formatter: (params) => formatterFunc(params, 5, note)
            }
          }
        },
        {
          type: "bar",
          name: "ABORTED",
          stack: "stack",
          label: {
            normal: {
                show: true,
                position:"left",
                formatter: (params) => formatterFunc(params, 6, note)
            }
          }
        }
      ]
  };

  const changeValue = (text, source) => {
    chart.setOption({
      dataset: {
        source: source
      },
      title: {
        text: text
      }
    });
  };

  chart.on("click", function (event) {
    let text = `Note: click on bar to show ${!note ? "absolute numbers" : "numbers in percent"}`;
    note = !note
    if (!note) changeValue(text, numberDataSource);
    else changeValue(text, percentDataSource);
  });

  chart.setOption(option);
  angular.element($window).on("resize", onResize);
}, 1000)', '{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
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
', '', '2019-05-21 22:29:13.117356', '2019-03-27 08:38:47.112148', '{
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
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "PERIOD": "Total",
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}
', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('APPLICATION ISSUES (BLOCKERS) COUNT', 'A number of unique application bugs discovered and submitted by automation.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
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
      "Nightly",
      "Weekly",
      "Monthly",
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
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
', '', '2019-05-21 22:31:37.184335', '2019-04-09 15:54:48.757347', '{
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
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": [],
  "PERIOD": "Last 7 Days",
  "BLOCKER": "true",
  "JOB_NAME": "",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": ""
}
', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('PASS RATE TREND', 'Consolidated test status trend with the ability to specify 10+ extra filters and grouping by hours, days, month, etc.', 'LINE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />
<#global GROUP_AND_ORDER_BY = getGroupBy(PERIOD, PARENT_JOB) />

SELECT
      ${GROUP_AND_ORDER_BY} AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY ${GROUP_AND_ORDER_BY}
  ORDER BY ${GROUP_AND_ORDER_BY};

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
  <#if PARENT_JOB != "">
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
<#function getGroupBy Period, parentJob>
  <#local result = "" />
  <#if parentJob != "">
    <#local result = "UPSTREAM_JOB_BUILD_NUMBER" />
  <#else>
    <#local result = getCreatedAt(PERIOD) />
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
</#function>', 'let lineRow = {
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
};

let series = [];
  for (var i = 0; i < 6 ; i++) {
    series.push(lineRow);
  };

let option = {
    "grid": {
        "right": "8%",
        "left": "10%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis",
        "extraCssText": "transform: translateZ(0);"
    },
    "color": [
        "#e76a77",
        "#6dbbe7",
        "#fddb7a",
        "#b5b5b5",
        "#61c8b3",
        "#9f5487"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {
      axisLabel : {
        formatter: (value) => {
          if(value == 0) return value
          if(value >= 1000000000) return `${(value/1000000000).toFixed(2)}B`
          else if(value >= 1000000) return `${(value/1000000).toFixed(2)}M`
          else if (value >= 1000) return `${(value/1000).toFixed(2)}K`
          else return value
        }
      }
    },
    "series": series
};

window.onresize = function(event) {
  const leftCorner = chart.getWidth() < 700 ? "10%" : "8%";
  option.grid.left = leftCorner;
  chart.setOption(option);
};

chart.setOption(option);', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  }
}
', '', '2019-05-21 22:32:29.254337', '2019-04-12 09:54:38.556068', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
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
  "JOB_NAME": "",
  "PARENT_JOB": ""
}', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST FAILURE COUNT', 'High-level information about similar errors.', 'TABLE', '
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
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly"
      ],
    "required": true
  }
}', '', '2019-05-21 22:33:42.97516', '2019-04-12 18:54:44.519344', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "38758212"
}', true);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('MONTHLY TEST IMPLEMENTATION PROGRESS', 'A number of new automated cases per month.', 'BAR', '<#global IGNORE_PERSONAL_PARAMS = ["USERS.USERNAME"] >

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
}', '', '2019-05-13 13:17:40.339082', '2019-04-09 13:04:34.054318', '{
  "PROJECT": ["AURONIA", "UNKNOWN"],
  "PERSONAL": "true",
  "currentUserId": 1,
  "USER": []
}', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('PASS RATE', 'Consolidated test status information with the ability to specify 10+ extra filters including daily, weekly, monthly, etc period.', 'PIE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
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
      "Nightly",
      "Weekly",
      "Monthly",
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '', '2019-05-21 22:34:53.751114', '2019-04-08 15:59:40.214693', '{
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
  "JOB_NAME": "",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6"
}
', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TESTS FAILURES BY REASON', 'Summarized information about tests failures grouped by reason.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "BUG": join(BUG),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
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
  HAVING count(*) > ${ERROR_COUNT}
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
</#function>', '{"columns": ["COUNT", "ENV", "REPORT", "MESSAGE", "BUG", "SUBJECT"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
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
  "ERROR_COUNT": {
    "value": "0",
    "required": false
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["COUNT", "ENV", "BUG", "SUBJECT", "REPORT", "MESSAGE"]}', '2019-05-22 12:41:41.952258', '2019-04-12 15:12:14.804581', '{
  "PERIOD": "Last 7 Days",
  "PERSONAL": "false",
  "ERROR_COUNT": 0,
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
  "BLOCKER": "false",
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST FAILURE DETAILS', 'All tests/jobs with a similar failure.', 'TABLE', '
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
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly"
      ],
    "required": true
  }
}', '', '2019-05-15 17:29:04.476357', '2019-04-12 19:20:37.515495', '{
  "PERIOD": "Last 24 Hours",
  "hashcode": "-1996341284"
}', true);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TESTCASE INFO', 'Detailed test case information.', 'TABLE', 'SELECT
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


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST CASE DURATION TREND', 'All kind of duration metrics per test case.', 'LINE', 'SELECT
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


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST CASE STABILITY', 'Aggregated stability metric for a test case.', 'PIE', 'SELECT
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


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TESTS SUMMARY', 'Detailed information about passed, failed, skipped, etc tests.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT
        <#if GROUP_BY="OWNER_USERNAME" >
          ''<a href="dashboards/'' || (select ID from dashboards where title=''Personal'') || ''?userId='' || OWNER_ID || ''">'' || OWNER_USERNAME || ''</a>'' AS "OWNER",
        <#elseif GROUP_BY="TEST_SUITE_NAME">
          ''<a href="tests/runs/'' || TEST_RUN_ID || ''">'' || TEST_SUITE_NAME || ''</a>'' AS "SUITE",
          ${GROUP_BY} AS "${GROUP_BY}",
        </#if>
        SUM(PASSED) AS "PASS",
        SUM(FAILED) AS "FAIL",
        SUM(KNOWN_ISSUE) AS "DEFECT",
        SUM(SKIPPED) AS "SKIP",
        SUM(ABORTED) AS "ABORT",
        sum(QUEUED) AS "QUEUE",
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * sum( QUEUED ) / sum(TOTAL), 0)::integer AS "QUEUED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM ${VIEW}
    ${WHERE_MULTIPLE_CLAUSE}
    <#if GROUP_BY="OWNER_USERNAME" >
      GROUP BY OWNER_ID, OWNER_USERNAME
    <#elseif GROUP_BY="TEST_SUITE_NAME">
      GROUP BY TEST_RUN_ID, TEST_SUITE_NAME
    </#if>
    ORDER BY 1



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
</#function>', '{"columns": ["OWNER", "SUITE", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "QUEUE", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "QUEUED (%)", "FAIL RATE (%)"]}
', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Total"
      ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "OWNER_USERNAME",
      "TEST_SUITE_NAME"
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["OWNER", "SUITE", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "QUEUE", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "QUEUED (%)", "FAIL RATE (%)"]}
', '2019-05-22 13:52:34.963878', '2019-04-09 17:06:51.739459', '{
  "PERIOD": "Nightly",
  "GROUP_BY": "TEST_SUITE_NAME",
  "PERSONAL": "false",
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
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', false);

INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('APPLICATION ISSUES (BLOCKERS) DETAILS', 'Detailed information about known issues and blockers.', 'TABLE', '<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "BUG": join(BUG),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
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
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly"
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{"legend": ["BUG", "SUBJECT", "TASK", "PROJECT", "ENV", "OWNER", "PLATFORM", "PLATFORM_VERSION", "BROWSER", "BROWSER_VERSION", "APP_VERSION", "DEVICE", "LOCALE", "LANGUAGE", "SUITE NAME", "TEST_INFO_URL", "Error Message"]}', '2019-05-21 22:38:51.220713', '2019-04-18 15:12:31.727154', '{
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
  "BLOCKER": "false",
  "JOB_NAME": "",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": "6"
}', false);


INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, LEGEND_CONFIG, MODIFIED_AT, CREATED_AT, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TEST CASES BY STABILITY', 'Shows all test cases with low stability percent rate per appropriate period (default - less than 10%).', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME"] >
<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "DEVICE": join(DEVICE),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK)
}>

<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

<#--
  1. for "Last 24 Hours" or "Nightly" calculate stability on the fly using appropriate views
  2. for Monthly select STABILITY from TEST_CASE_HEALTH_VIEW for current month
  3. for Total calculate avg(STABILITY) overall by TEST_CASE_HEALTH_VIEW view data
  Note: all filters the rest
  -->

  SELECT
    PROJECT AS "PROJECT",
    STABILITY_URL AS "TEST METHOD",
    ROUND(SUM(PASSED)/SUM(TOTAL)*100) AS "STABILITY"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "PROJECT", "TEST METHOD"
  <#if PERIOD == "Monthly" || PERIOD = "Total">
    HAVING AVG(STABILITY) <= ${PERCENT}
  <#else>
    HAVING ROUND(SUM(PASSED)/SUM(TOTAL)*100) <= ${PERCENT}
  </#if>
  ORDER BY "PROJECT", "TEST METHOD", "STABILITY"


<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
 <#local result = "" />

  <#if PERIOD == "Monthly">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "TESTED_AT = date_trunc(''month'', current_date)"/>
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
 <#local result = "TEST_CASE_HEALTH_VIEW" />
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
  <#case "Total">
    <#local result = "TEST_CASE_HEALTH_VIEW" />
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
</#function>', '{"columns": ["PROJECT", "TEST METHOD", "STABILITY"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Total"
      ],
    "required": true
  },
  "PERCENT": {
    "value": "10",
    "required": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  }
}', '', '2019-05-21 22:39:53.577361', '2019-05-02 08:40:40.991813', '{
  "PERIOD": "Last 7 Days",
  "PROJECT": [],
  "PERCENT": 50,
  "USER": [],
  "PLATFORM": [],
  "PLATFORM_VERSION": [],
  "BROWSER_VERSION": [],
  "DEVICE": [],
  "ENV": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "LANGUAGE": [],
  "JOB_NAME": "",
  "PRIORITY": [],
  "FEATURE": [],
  "TASK": []
}', false);

INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('MILESTONE DETAILS', 'Consolidated test status trend with the ability to specify 10+ extra filters and grouping by hours, days, month, etc.', 'OTHER','<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >
<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "TASK": join(TASK),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />
<#global GROUP_AND_ORDER_BY = getGroupBy(PERIOD, PARENT_JOB) />
SELECT
      ${GROUP_AND_ORDER_BY} AS "CREATED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED",
      sum( QUEUED ) AS "QUEUED"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY ${GROUP_AND_ORDER_BY}
  ORDER BY ${GROUP_AND_ORDER_BY};
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
  <#if PARENT_JOB != "">
      <#if result?length != 0>
      <#local result = result + " AND "/>
      </#if>
      <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
<#function getGroupBy Period, parentJob>
  <#local result = "" />
  <#if parentJob != "">
    <#local result = "UPSTREAM_JOB_BUILD_NUMBER" />
  <#else>
    <#local result = getCreatedAt(PERIOD) />
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
</#function>' , '
setTimeout(function() {
  const created = dataset[0].CREATED_AT.toString();
  const lastCount = dataset.length - 1;
  const lastValue = dataset[lastCount].CREATED_AT.toString();
  
  let dataSource = [["CREATED_AT"], ["PASSED"], ["FAILED"], ["SKIPPED"], ["QUEUED"], ["ABORTED"], ["KNOWN ISSUE"]];
  
  const createDatasetSource = () => {
    let amount = dataset.length;
    for (let i = 0; i < amount; i++) {
      dataSource.forEach((value, index) => {
        let valueName = value[0];
        let pushValue = dataset[i][valueName];
        if (valueName === "CREATED_AT") value.push(pushValue.toString());
        else value.push(pushValue);
      })
    }
    return dataSource;
  };
  
  let grid, legend, pieStyle, title;
  
  customStyle = () => {
    const screenWidth = window.innerWidth;
    const rich = (fontSize, padding, fontWeight) => {
      return {
        PASSED:{ color: "#61c8b3", fontSize, fontWeight },
        FAILED:{ color: "#e76a77", fontSize, fontWeight },
        SKIPPED:{ color: "#fddb7a", fontSize, fontWeight},
        QUEUED:{ color: "#6dbbe7", fontSize, fontWeight },
        ABORTED:{ color: "#b5b5b5", fontSize, fontWeight },
        KNOWN_ISSUE:{ color: "#9f5487", fontSize, fontWeight },
        BUILD:{ color: "#0a0a0a", fontSize, padding, fontWeight: 700 }
      }
    };
    
    grid = {
      top: "8%",
      left: "27%",
      right: "3%",
      bottom: "17%"
    };
    legend = {
      orient: "vertical",
      x: "left",
      y: "center",
      left: "1%",
      icon: "roundRect",
      textStyle: {
        fontSize: 12
      }
    };
    title = {
      show: true,
      right: "3%",
      top: 0,
      textStyle: {
        rich: rich(12, [0, 0, 0, 50], 500)
      }
    };
    pieStyle = {
      radius: "70%",
      center: ["15%", "47%"]
    };
    if (screenWidth > 1250) grid.left = "30%";
    else grid.left = "35%";
    if (chart._dom.clientWidth === 280 || screenWidth < 481) {
      grid.top = "50%";
      grid.left = 30;
      grid.right = 15;
      grid.bottom = "15%";
      legend.x = "left";
      legend.y = "top";
      legend.top = 10;
      legend.itemGap = 2;
      legend.itemWidth = 10;
      legend.itemHeight = 7;
      legend.textStyle.fontSize = 7;
      title.right = "3%",
      title.top = "40%";
      title.textStyle.rich = rich(6);
      pieStyle.radius = "40%";
      pieStyle.center = ["60%", "23%"];
      if (screenWidth < 481) {
        legend.itemGap = 5;
        legend.textStyle.fontSize = 10;
        pieStyle.center = ["60%", "23%"];
        title.right = "3%",
        title.right = "2.5%";
        title.top = "43%";
        title.textStyle.rich = rich(8, [0, 0, 0, 20], 400);
      }
    }
  }
  customStyle();
  
  const changeTitle = (value = lastCount) => {
    let titleValue = "";
    let name = "";
    let total = 0;
    let newDataObj = {};
    
    for (const testName in dataset[value]){
      if (testName === "CREATED_AT") continue;
      total +=  dataset[value][testName];
    }
    
    for (let i = 0; i < dataSource.length; i++){
      newDataObj[dataSource[i][0]] = dataset[value][dataSource[i][0]]
    }
    
    Object.entries(newDataObj).forEach(([key, value]) => {
      if (value === 0) return;
      if (key === "CREATED_AT") return name = typeof value == "number"? `{BUILD|Build: ${value}}` : `{BUILD|Date: ${value}}`;

      let parameter = key === "KNOWN ISSUE" ? "KNOWN_ISSUE" : key;
      persentValue = (value * 100 / total).toFixed(2);
      titleValue += ` {${parameter}|${key}: ${persentValue}%;}`;
    });
    
    titleValue += name;
    
    chart.setOption({
      title:{
        text: titleValue
      }
    })
  };
  changeTitle();
  
let colors = ["#61c8b3", "#e76a77", "#fddb7a", "#6dbbe7", "#b5b5b5", "#9f5487"];
let lineRow = {
    type: "line",
    smooth: false,
    seriesLayoutBy: "row",
    stack: "Status",
    itemStyle: {
      normal: {
        areaStyle: {
          opacity: 0.8,
          type: "default"
        }
      }
    }
  };
  
  let pie = {
    type: "pie",
    id: "pie",
    radius: pieStyle.radius,
    center:  pieStyle.center,
    label: { show: false },
    encode: {
      itemName: "CREATED_AT",
      value: lastValue,
      tooltip: lastValue
    },
    selectedMode : true,
    emphasis: {
      label: {
        show: true,
        formatter: "{b}: {d}%"
      }
    }
  };
  
  let series = [];
  for (var i = 0; i < dataSource.length - 1 ; i++) {
    series.push(lineRow);
  };
  series.push(pie);

  let option = {
        title: title,
        grid: grid,
        color: colors,
        legend: legend,
        tooltip: {
            trigger: "axis",
            showDelay: 1
        },
        dataZoom: [
          {
            startValue: created,
            bottom: "0",
            height : "25px"
          },
          {
            type: "inside"
          }
        ],
        dataset: {
          source: createDatasetSource()
        },
        xAxis: {
          type: "category",
          boundaryGap: false
        },
        yAxis: {
          gridIndex: 0
        },
        series: series
    };
    
    chart.on("updateAxisPointer", (event) => {
        let xAxisInfo = event.axesInfo[0];
        if (xAxisInfo) {
            let dimension = xAxisInfo.value + 1;
            chart.setOption({
                series: {
                  id: "pie",
                  label: {
                    formatter: "{b}: ({d}%)"
                  },
                  encode: {
                    value: dimension,
                    tooltip: dimension
                  }
                }
            });
            changeTitle(dimension - 1);
        }
    });
    
    chart.setOption(option);
    angular.element($window).on("resize", onResize);
}, 1000)' , '{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Total"
      ]
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
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
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
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
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
  "JOB_NAME": "",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": ""
}', false);



INSERT INTO WIDGET_TEMPLATES (NAME, DESCRIPTION, TYPE, SQL, CHART_CONFIG, PARAMS_CONFIG, PARAMS_CONFIG_SAMPLE, HIDDEN) VALUES ('TESTS FAILURES BY SUITE', 'Shows all test cases with failures count per appropriate period and possibility to view detailed information for each suite/test.', 'TABLE', '<#global IGNORE_TOTAL_PARAMS = ["DEVICE", "APP_VERSION", "LOCALE", "LANGUAGE", "JOB_NAME", "PARENT_JOB", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "TEST_SUITE_FILE": join(TEST_SUITE_FILE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "DEVICE": join(DEVICE),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "LANGUAGE": join(LANGUAGE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

  SELECT
      TEST_SUITE_FILE AS "SUITE",
      TEST_METHOD_NAME AS "NAME",
      --STABILITY_URL as "NAME",
      SUM(FAILED) AS "FAILURES COUNT",
      SUM(TOTAL) AS "TOTAL COUNT",
      ROUND(SUM(FAILED)*100/COUNT(*)) AS "FAILURE %"
    FROM ${VIEW}
    ${WHERE_MULTIPLE_CLAUSE}
    GROUP BY TEST_SUITE_FILE, TEST_METHOD_NAME--, STABILITY_URL
    HAVING SUM(FAILED) > 0


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
</#function>', '{"columns": ["SUITE", "NAME", "FAILURES COUNT", "TOTAL COUNT", "FAILURE %"]}', '{
    "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
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
  "TEST_SUITE_FILE": {
    "valuesQuery": "SELECT DISTINCT(FILE_NAME) FROM TEST_SUITES WHERE FILE_NAME IS NOT NULL AND FILE_NAME <> '' ORDER BY 1;",
    "multiple": true,
    "required": true
  },
  "PROJECT": {
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '' ORDER BY 1;",
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
    "valuesQuery": "SELECT DISTINCT DEVICE FROM TEST_CONFIGS WHERE DEVICE IS NOT NULL AND DEVICE <> '' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '';",
    "multiple": true
  },
  "LOCALE": {
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '';",
    "multiple": true
  },
  "LANGUAGE": {
    "valuesQuery": "SELECT DISTINCT LANGUAGE FROM TEST_CONFIGS WHERE LANGUAGE IS NOT NULL AND LANGUAGE <> '';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', '{
  "PERIOD": "Last 7 Days",
  "PERSONAL": "false",
  "GROUP_BY": "TEST_SUITE_NAME",
  "TEST_SUITE_FILE":[],
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
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', false);
