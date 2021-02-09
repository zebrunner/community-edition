SET SCHEMA 'management';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTS EXECUTION ROI (MAN-HOURS)', DESCRIPTION='Monthly team/personal automation ROI by tests execution. 160+ hours per person for UI tests indicate that your execution ROI is very good.', TYPE='BAR', 
	SQL='
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
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
      to_char(STARTED_AT, ''YYYY-MM'') AS "STARTED_AT"
  FROM TOTAL_VIEW
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "STARTED_AT"
  ORDER BY "STARTED_AT";


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
</#function>', 
	CHART_CONFIG = '{
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
        "trigger": "axis",
        "extraCssText": "transform: translateZ(0);"
    },
    "dimensions": [
        "STARTED_AT",
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
}', 
	PARAMS_CONFIG = '{
  "PERSONAL": {
    "values": [
      "false",
      "true"
    ],
    "type": "radio",
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  }
}', 
	PARAMS_CONFIG_SAMPLE = '{
  "PERSONAL": "true",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": ["DEMO", "PROD"],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": ["*"],
  "BROWSER":[],
  "TASK": [],
  "BUG": []
}', 
	HIDDEN=false
WHERE NAME='TESTS EXECUTION ROI (MAN-HOURS)';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST CASE STABILITY TREND', DESCRIPTION='Test case stability trend on a monthly basis.', TYPE='LINE', 
	SQL='SELECT
    ROUND(SUM(CASE WHEN TESTS.STATUS = ''PASSED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "STABILITY",
    ROUND(SUM(CASE WHEN TESTS.STATUS = ''FAILED'' AND TESTS.KNOWN_ISSUE = FALSE THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "FAILURE",
    ROUND(SUM(CASE WHEN TESTS.STATUS = ''SKIPPED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "OMISSION",
    ROUND(SUM(CASE WHEN TESTS.STATUS = ''FAILED'' AND TESTS.KNOWN_ISSUE = TRUE THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "KNOWN ISSUE",
    ROUND(SUM(CASE WHEN TESTS.STATUS = ''ABORTED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "INTERRUPT",
    to_char(date_trunc(''month'', TESTS.START_TIME), ''YYYY-MM'') AS "TESTED_AT"
FROM TESTS
WHERE TEST_CASE_ID = ''${testCaseId}''
  AND TESTS.FINISH_TIME IS NOT NULL
  AND TESTS.START_TIME IS NOT NULL
  AND TESTS.STATUS <> ''IN_PROGRESS''
GROUP BY date_trunc(''month'', TESTS.START_TIME)
ORDER BY "TESTED_AT"
', 
	CHART_CONFIG='{
    "grid": {
        "right": "5%",
        "left": "5%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis",
        "extraCssText": "transform: translateZ(0);"
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
}', 
	PARAMS_CONFIG='{}', 
	PARAMS_CONFIG_SAMPLE='{"testCaseId": "1"}', 
	HIDDEN=true
WHERE NAME='TEST CASE STABILITY TREND';

UPDATE WIDGET_TEMPLATES 
SET NAME='PASS RATE (BAR)', DESCRIPTION='Pass rate percent with an extra grouping by project, owner, etc.', TYPE='BAR', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOCALE", "JOB_NAME", "PARENT_BUILD"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "ENV": join(ENV),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE)
}>

<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES, PARENT_JOB, PARENT_BUILD) />
<#global VIEW = getView(PERIOD) />

SELECT lower(${GROUP_BY}) AS "GROUP_FIELD",
      sum( PASSED ) AS "PASSED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      0 - sum( FAILED ) AS "FAILED",
      0 - sum( SKIPPED ) AS "SKIPPED",
      0 - sum( ABORTED ) AS "ABORTED"
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
       <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, JOB_NAME-->
       <#continue>
      </#if>
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
     </#if>
 </#list>

<#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>

 <#if PERIOD != "Total" && PARENT_JOB != "" && PARENT_BUILD == "LATEST">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PERIOD != "Total" && PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='setTimeout(() => {
  const dimensions = [
    "GROUP_FIELD",
    "PASSED",
    "FAILED",
    "SKIPPED",
    "KNOWN ISSUE",
    "ABORTED"
  ];
  let note = true;
  
  const createSource = () => {
    let source = [];
    
    for (let i = 0; i < dataset.length; i++) {
      let sourceData = [];
      dimensions.forEach((value, index) => sourceData.push(dataset[i][value]));
      source.push(sourceData);
    };
    
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
  
  const getTotalValue = (value) => {
    let total = 0;
    value.map( a => {
      if (typeof a === "number") total += a > 0 ? a : a * -1;
    });
    return total;
  };

  numberDataSource.forEach((value) => {
    let total = getTotalValue(value);
    createPercentSource(value, total);
  });

  const formatterFunc = (params, index) => {
    let total = getTotalValue(params.value);
    let controlValue = params.value[index] * 100 / total;
    controlValue = controlValue > 0 ? controlValue : controlValue * -1;
    if (controlValue > 5) return `${params.value[index]}${note ? "%" : ""}`;
    else return "";
  };
  
  let series = [];
  for (var i = 0; i < dimensions.length - 1 ; i++) {
    let index = i + 1;
    let seriesBar = {
      type: "bar",
      name: dimensions[index],
      stack: "stack",
      label: {
        normal: {
          show: true,
          position: "inside",
          formatter: (params) =>  formatterFunc(params, index)
        }
      }
    }
    series.push(seriesBar);
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
      },
      extraCssText: "transform: translateZ(0)"
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
        type: "value",
        min: "-100",
        max: "100"
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
      "#b5b5b5"
    ],
    dataset: {
      source: percentDataSource
    },
    dimensions: dimensions,
    series: series
  };
  
  chart.setOption(option);
  angular.element($window).on("resize", onResize);
  
  const changeValue = (text, source, { min, max } ) => {
    chart.setOption({
      dataset: { source },
      title: { text },
      xAxis: [{ min, max }],
    });
  };
  
  chart.on("click", (event) => {
    let text = `Note: click on bar to show ${!note ? "absolute numbers" : "numbers in percent"}`;
    note = !note
    if (!note) changeValue(text, numberDataSource, { min: null, max: null });
    else changeValue(text, percentDataSource, { min:-100, max:100 });
  });
}, 1000)', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly",
      "Total"
    ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "PLATFORM",
      "BROWSER",
      "OWNER_USERNAME",
      "PROJECT",
      "DEVICE",
      "ENV",
      "APP_VERSION",
      "LOCALE",
      "JOB_NAME",
      "PRIORITY",
      "FEATURE",
      "TASK"
    ],
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Monthly",
  "GROUP_BY": "PLATFORM",
  "PROJECT": [],
  "USER": [],
  "PLATFORM": [],
  "PLATFORM_VERSION": [],
  "BROWSER": [],
  "BROWSER_VERSION": [],
  "ENV": [],
  "LOCALE": [],
  "PRIORITY": [],
  "FEATURE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', 
	HIDDEN=false
WHERE NAME='PASS RATE (BAR)';

UPDATE WIDGET_TEMPLATES 
SET NAME='APPLICATION ISSUES (BLOCKERS) COUNT', DESCRIPTION='A number of unique application bugs discovered and submitted by automation.', TYPE='TABLE', 
	SQL='<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "ENV": join(ENV),
  "APP_VERSION": join(APP_VERSION),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE)
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
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
    </#if>
  </#list>

 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
 <#if PERIOD != "Total" && PARENT_JOB != "" && PARENT_BUILD?lower_case == "latest">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PERIOD != "Total" && PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["PROJECT", "COUNT"]}',
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
    ],
    "required": true
  },
  "BLOCKER": {
    "values": [
      "false",
      "true"
    ],
    "type": "radio",
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' AND PLATFORM IS NOT NULL ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "APP_VERSION": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT APP_VERSION FROM TEST_CONFIGS WHERE APP_VERSION IS NOT NULL AND APP_VERSION <> '''';",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
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
}', 
	PARAMS_CONFIG_SAMPLE='{
  "GROUP_BY": "PLATFORM",
  "PROJECT": [],
  "USER": [],
  "PLATFORM": [],
  "PLATFORM_VERSION": [],
  "BROWSER": [],
  "BROWSER_VERSION": [],
  "ENV": [],
  "APP_VERSION": [],
  "LOCALE": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PERIOD": "Monthly",
  "BLOCKER": "false",
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "LATEST"
}', 
	HIDDEN=false
WHERE NAME='APPLICATION ISSUES (BLOCKERS) COUNT';

UPDATE WIDGET_TEMPLATES 
SET NAME='PASS RATE (LINE)', DESCRIPTION='Consolidated test status trend with the ability to specify 10+ extra filters and grouping by hours, days, month etc.', TYPE='LINE', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOCALE", "JOB_NAME", "PARENT_JOB"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />
<#global GROUP_AND_ORDER_BY = getStartedAt(PERIOD) />

SELECT
    ${GROUP_AND_ORDER_BY} AS "STARTED_AT",
    sum( PASSED ) AS "PASSED",
    sum( FAILED ) AS "FAILED",
    sum( SKIPPED ) AS "SKIPPED",
    sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
    sum( ABORTED ) AS "ABORTED"
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

  <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
<#function getStartedAt value>
  <#local result = "to_char(date_trunc(''day'', STARTED_AT), ''YYYY-MM-DD'')" />
  <#switch value>
    <#case "Last 24 Hours">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''MM-DD HH24:MI'')" />
      <#break>
    <#case "Nightly">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 7 Days">
    <#case "Last 14 Days">
    <#case "Last 30 Days">
    <#case "Weekly">
    <#case "Monthly">
      <#local result = "to_char(date_trunc(''day'', STARTED_AT), ''YYYY-MM-DD'')" />
      <#break>
    <#case "Total">
      <#local result = "to_char(date_trunc(''month'', STARTED_AT), ''YYYY-MM'')" />
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='let lineRow = {
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

let series = [];
  for (var i = 0; i < 5 ; i++) {
    series.push(lineRow);
  };

let option = {
    "grid": {
        "right": "8%",
        "left": "10%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {
      "icon": "roundRect"
    },
    "tooltip": {
        "trigger": "axis",
        "extraCssText": "transform: translateZ(0);"
    },
    "color": [
        "#61c8b3",
        "#e76a77",
        "#fddb7a",
        "#9f5487",
        "#b5b5b5"
    ],
    "xAxis": {
        "type": "category",
        "boundaryGap": false
    },
    "yAxis": {},
    "series": series,
    "defaultSize": {
      "height": 8,
      "width": 11
    }
}

window.onresize = function(event) {
  const leftCorner = chart.getWidth() < 700 ? "10%" : "8%";
  option.grid.left = leftCorner;
  chart.setOption(option);
};

chart.setOption(option);', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly",
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
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Total",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER":[],
  "LOCALE": [],
  "JOB_NAME": "",
  "PARENT_JOB": ""
}', 
	HIDDEN=false
WHERE NAME='PASS RATE (LINE)';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST FAILURE COUNT', DESCRIPTION='High-level information about similar errors.', TYPE='TABLE', 
	SQL='<#global VIEW = getView(PERIOD) />

SELECT COUNT(*) AS "COUNT",
    STABILITY_URL AS "STABILITY",
    MESSAGE AS "STACKTRACE"
  FROM ${VIEW}
  WHERE MESSAGE_HASHCODE=''${hashcode}''
  GROUP BY MESSAGE, STABILITY_URL
  LIMIT 1
  
<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#return value?replace(" ", "_") + "_view">
</#function>
', 
	CHART_CONFIG='{"columns": ["COUNT", "STABILITY", "STACKTRACE"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
    ],
    "required": true
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 24 Hours",
  "hashcode": "38758212"
}', 
	HIDDEN=true
WHERE NAME='TEST FAILURE COUNT';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTS IMPLEMENTATION PROGRESS', DESCRIPTION='A number of new automated cases per period.', TYPE='BAR', 
	SQL='<#global IGNORE_PERSONAL_PARAMS = ["USERS.USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECTS.NAME": multiJoin(PROJECT, projects),
  "USERS.USERNAME": join(USER)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global CREATED_AT = getCreatedAt(PERIOD) />
<#global GROUP_AND_ORDER_BY = getGroupAndOrder(PERIOD) />

SELECT
      ${CREATED_AT} AS "CREATED_AT",
      count(*) AS "AMOUNT"
    FROM TEST_CASES
    INNER JOIN PROJECTS ON TEST_CASES.PROJECT_ID = PROJECTS.ID
    INNER JOIN USERS ON TEST_CASES.PRIMARY_OWNER_ID = USERS.ID
    ${WHERE_MULTIPLE_CLAUSE}
    ${GROUP_AND_ORDER_BY}


  <#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->
<#function generateMultipleWhereClause map>
  <#local result = "" />

   <#if PERIOD == "Nightly">
    <#local result = result + "TEST_CASES.CREATED_AT >= current_date"/>
  <#elseif PERIOD == "Last 24 Hours">
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''hour'', current_date - interval ''24'' hour)"/>
  <#elseif PERIOD == "Weekly">
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''week'', current_date)  - interval ''2'' day"/>
  <#elseif PERIOD == "Last 7 Days">
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''day'', current_date - interval ''7'' day)"/>
  <#elseif PERIOD == "Last 14 Days">
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''day'', current_date - interval ''14'' day)"/>
  <#elseif PERIOD == "Last 30 Days">
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''day'', current_date - interval ''30'' day)"/>
  <#elseif PERIOD == "Monthly" >
    <#local result = result + "TEST_CASES.CREATED_AT >= date_trunc(''week'', current_date)"/>  
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
    Retrieves actual CREATED_BY grouping  by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getCreatedAt value>
  <#local result = "to_char(date_trunc(''day'', TEST_CASES.CREATED_AT), ''MM/DD'')" />
  <#switch value>
    <#case "Last 24 Hours">
    <#case "Nightly">
      <#local result = "to_char(date_trunc(''hour'', TEST_CASES.CREATED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 7 Days">
    <#case "Weekly">
    <#case "Last 14 Days">
      <#local result = "to_char(date_trunc(''day'', TEST_CASES.CREATED_AT), ''MM/DD'')" />
      <#break>
    <#case "Last 30 Days">
    <#case "Monthly">
      <#local result = "to_char(date_trunc(''week'', TEST_CASES.CREATED_AT), ''MM/DD'')" />
      <#break>
    <#case "Total">
      <#local result = "to_char(date_trunc(''quarter'', TEST_CASES.CREATED_AT), ''YYYY-" + ''"Q"'' + "Q'')" />
      <#break>
  </#switch>
  <#return result>
</#function>

<#function getGroupAndOrder value>
  <#local result = "GROUP BY 1 ORDER BY 1;" />
  <#switch value>
    <#case "Last 24 Hours">
    <#case "Last 7 Days">
    <#case "Last 14 Days">
    <#case "Last 30 Days">
      <#local result = "GROUP BY 1, to_char(date_trunc(''week'', TEST_CASES.CREATED_AT), ''YY/MM/DD'')
        ORDER BY to_char(date_trunc(''week'', TEST_CASES.CREATED_AT), ''YY/MM/DD'');" />
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
</#function>', 
	CHART_CONFIG='let data = [], invisibleData = [], xAxisData = [], lineData = [];
let invisibleDataStep = 0, lineDataStep = 0;

dataset.map(({CREATED_AT, AMOUNT}) => {
  xAxisData.push(CREATED_AT);
  data.push(AMOUNT);  //used in second bar series for building
  invisibleData.push(invisibleDataStep);  //used in first bar series for creating step-effect
  lineDataStep += AMOUNT;
  lineData.push(lineDataStep); //used in line series for creating dashed-line
  invisibleDataStep += AMOUNT; //the first element must be 0
});
  
option = {
  grid: {
    right: "2%",
    left: "4%",
    top: "8%",
    bottom: "8%"
    },
  tooltip : {
    trigger: "axis",
    axisPointer : {            
      type : "shadow"        
    },
    formatter: function (params) {
      let total = params[2]; // pick params.total
      return total.name + "<br/>" + "Total" + " : " + total.value;
    },
    extraCssText: "transform: translateZ(0);"
  },
  color: ["#7fbae3", "#7fbae3"],
  xAxis: {
    type : "category",
    splitLine: {
      show: false
    },
    data : xAxisData
  },
  yAxis: {
    type : "value"
  },
  series: [
    {
      type: "bar",
      stack: "line",
      itemStyle: {
        normal: {
          barBorderColor: "rgba(0,0,0,0)",
          color: "rgba(127, 186, 227, 0.1)"
        },
        emphasis: {
          barBorderColor: "rgba(0,0,0,0)",
          color: "rgba(127, 186, 227, 0.1)"
        }
      },
      data: invisibleData
      },
      {
        type: "bar",
        stack: "line",
        label: {
          normal: {
            show: true,
            distance: -15,
            position: "top",
            color: "black",
             formatter: (params) => {
              if (params.dataIndex === 0) return "";
              return params.value;
            }
          }
        },
        data: data
      },
      {
        type: "line",
        smooth: true,
        label: {
          normal: {
            show: true
          }
        },
        lineStyle: {
          color: "rgba(0,0,0,0)" // default invisible
        },
        data: lineData
      }
    ]
};
chart.setOption(option);', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Total",
      "2020",
      "2020-Q2"
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
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Total",
  "PROJECT": ["UNKNOWN"],
  "PERSONAL": "false",
  "currentUserId": 1,
  "USER": []
}', 
	HIDDEN=false
WHERE NAME='TESTS IMPLEMENTATION PROGRESS';

UPDATE WIDGET_TEMPLATES 
SET NAME='PASS RATE (PIE)', DESCRIPTION='Consolidated test status information with the ability to specify 10+ extra filters including daily, weekly, monthly etc period.', TYPE='PIE', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOCALE", "JOB_NAME", "PARENT_BUILD"] > 
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
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
              ''ABORTED'']) AS "label",
     unnest(
      array[0,
          sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
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
              ''ABORTED'']) AS "label",
     unnest(
      array[0,
          sum(PASSED),
          sum(FAILED),
          sum(SKIPPED),
          sum(KNOWN_ISSUE),
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
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, JOB_NAME-->
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
 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
  <#if PARENT_JOB != "" && PARENT_BUILD?lower_case == "latest">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='option = {
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
        "formatter": "{b0}<br>{d0}%",
        "extraCssText": "transform: translateZ(0);"
    },
    "color": [
        "#ffffff",
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
                "70%"
            ]
        }
    ]
}
chart.setOption(option);', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly",
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
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Monthly",
  "PERSONAL": "false",
  "currentUserId": 2,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER":[],
  "LOCALE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "LATEST"
}', 
	HIDDEN=false
WHERE NAME='PASS RATE (PIE)';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTS FAILURES BY REASON', DESCRIPTION='Summarized information about tests failures grouped by reason.', TYPE='TABLE', 
	SQL='<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT count(*) AS "COUNT",
      ENV AS "ENV",
      ''<a href=${JIRA_URL}'' || ''/'' || BUG || '' target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      ''<a href="dashboards/'' || (select ID from dashboards where title=''Failures analysis'') || ''?hashcode='' || max(MESSAGE_HASHCODE)  || ''">Failures Analysis</a>'' AS "REPORT",
      substring(MESSAGE from 1 for 210) as "MESSAGE"
  FROM ${VIEW}
  ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY "ENV", "BUG", "SUBJECT", MESSAGE
  HAVING count(*) >= ${ERROR_COUNT}
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

 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
 <#if PARENT_JOB != "" && PARENT_BUILD == "LATEST">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
  </#if>

 <#if result?length != 0 && PERSONAL == "true">
   <!-- add personal filter by currentUserId with AND -->
   <#local result = result + " AND OWNER_ID=${currentUserId} "/>
 <#elseif result?length == 0 && PERSONAL == "true">
 <!-- add personal filter by currentUserId without AND -->
   <#local result = " OWNER_ID=${currentUserId} "/>
 </#if>


 <#if result?length != 0>
  <#local result = " WHERE MESSAGE IS NOT NULL AND MESSAGE <> '''' AND " + result/>
 <#else>
  <#local result = " WHERE MESSAGE IS NOT NULL AND MESSAGE <> ''''"/>
 </#if>
 <#return result>
</#function>

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["COUNT", "ENV", "REPORT", "MESSAGE", "BUG", "SUBJECT"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
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
  "BLOCKER": {
    "values": [
      "false",
      "true"
    ],
    "type": "radio",
    "required": true
  },
  "JIRA_URL": {
    "value": "https://mycompany.atlassian.net/browse",
    "required": true
  },
  "ERROR_COUNT": {
    "value": "0",
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "Separator": {
    "value": "Below params are not applicable for Total period!",
    "type": "title",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', 
	LEGEND_CONFIG='{"legend": ["COUNT", "ENV", "REPORT", "MESSAGE", "BUG", "SUBJECT"]}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 7 Days",
  "PERSONAL": "false",
  "ERROR_COUNT": 0,
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER":[],
  "LOCALE": [],
  "BLOCKER": "false",
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "JIRA_URL": "https://mycompany.atlassian.net/browse"}', 
	HIDDEN=false
WHERE NAME='TESTS FAILURES BY REASON';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST FAILURE DETAILS', DESCRIPTION='All tests with a similar failure.', TYPE='TABLE', 
	SQL='<#global VIEW = getView(PERIOD) />

SELECT ENV AS "ENV",
      ''<a href=${JIRA_URL}'' || ''/'' || BUG || '' target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      TEST_INFO_URL AS "REPORT"
  FROM ${VIEW}
  WHERE MESSAGE_HASHCODE=''${hashcode}''
  GROUP BY "ENV", "BUG", "SUBJECT", "REPORT"
  ORDER BY "ENV"

<#--
    Retrieves actual view name by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getView value>
 <#return value?replace(" ", "_") + "_view">
</#function>', 
	CHART_CONFIG='{"columns": ["ENV", "REPORT", "BUG", "SUBJECT"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
    ],
    "required": true
  },
  "JIRA_URL": {
    "value": "https://mycompany.atlassian.net/browse",
    "required": true
  }   
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 24 Hours",
  "hashcode": "-1996341284",
  "JIRA_URL": "https://mycompany.atlassian.net/browse"
}', 
	HIDDEN=true
WHERE NAME='TEST FAILURE DETAILS';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTCASE INFO', DESCRIPTION='Detailed test case information.', TYPE='TABLE', 
	SQL='SELECT
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
', 
	CHART_CONFIG='{"columns": ["OWNER", "PROJECT", "TEST METHOD", "TEST SUITE", "CREATED AT"]}', 
	PARAMS_CONFIG='{}', 
	PARAMS_CONFIG_SAMPLE='{"testCaseId": "1"}',
	HIDDEN=true
WHERE NAME='TESTCASE INFO';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST CASE DURATION TREND', DESCRIPTION='All kind of duration metrics per test case.', TYPE='LINE', 
	SQL='SELECT
      ROUND(AVG(EXTRACT(EPOCH FROM (TESTS.FINISH_TIME - TESTS.START_TIME)))::numeric, 2) as "AVG TIME",
      ROUND(MAX(EXTRACT(EPOCH FROM (TESTS.FINISH_TIME - TESTS.START_TIME)))::numeric, 2) as "MAX TIME",
      ROUND(MIN(EXTRACT(EPOCH FROM (TESTS.FINISH_TIME - TESTS.START_TIME)))::numeric, 2) as "MIN TIME",
      to_char(date_trunc(''month'', TESTS.START_TIME), ''YYYY-MM'') AS "TESTED_AT"
FROM TESTS
WHERE TEST_CASE_ID = ''${testCaseId}''
  AND TESTS.FINISH_TIME IS NOT NULL
  AND TESTS.START_TIME IS NOT NULL
  AND TESTS.STATUS <> ''IN_PROGRESS''
GROUP BY date_trunc(''month'', TESTS.START_TIME)
ORDER BY "TESTED_AT"', 
	CHART_CONFIG='{
    "grid": {
        "right": "2%",
        "left": "2%",
        "top": "8%",
        "bottom": "8%"
    },
    "legend": {},
    "tooltip": {
        "trigger": "axis",
        "extraCssText": "transform: translateZ(0);"
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
}', 
	PARAMS_CONFIG='{}', 
	PARAMS_CONFIG_SAMPLE='{"testCaseId": "1"}', 
	HIDDEN=true
WHERE NAME='TEST CASE DURATION TREND';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST CASE STABILITY', DESCRIPTION='Aggregated stability metric for a test case.', TYPE='PIE', 
	SQL='SELECT 
  unnest(array[''STABILITY'',
                  ''FAILURE'',
                  ''OMISSION'',
                  ''KNOWN ISSUE'',
                  ''INTERRUPT'']) AS "label",
  unnest(array[ROUND(SUM(CASE WHEN TESTS.STATUS = ''PASSED'' THEN 1 ELSE 0 END) * 100 /COUNT(*)::numeric, 0),                  
               ROUND(SUM(CASE WHEN TESTS.STATUS = ''FAILED'' AND TESTS.KNOWN_ISSUE = FALSE THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TESTS.STATUS = ''SKIPPED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TESTS.STATUS = ''FAILED'' AND TESTS.KNOWN_ISSUE = TRUE THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TESTS.STATUS = ''ABORTED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0)]) AS "value"
FROM TESTS
         INNER JOIN
     TEST_CASES ON TESTS.TEST_CASE_ID = TEST_CASES.ID
WHERE TEST_CASE_ID = ''${testCaseId}''
  AND TESTS.FINISH_TIME IS NOT NULL
  AND TESTS.START_TIME IS NOT NULL
  AND TESTS.STATUS <> ''IN_PROGRESS''
', 
	CHART_CONFIG='{
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
        "formatter": "{b0}<br>{d0}%",
        "extraCssText": "transform: translateZ(0);"
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
}', 
	PARAMS_CONFIG='{}', 
	PARAMS_CONFIG_SAMPLE='{"testCaseId": "1"}', 
	HIDDEN=true
WHERE NAME='TEST CASE STABILITY';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTS SUMMARY', DESCRIPTION='Detailed information about passed, failed, skipped etc tests.', TYPE='TABLE', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOCALE", "JOB_NAME", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT
        <#if GROUP_BY="OWNER_USERNAME" >
          ''<a href="dashboards/'' || (select ID from dashboards where title=''Personal'') || ''?userId='' || OWNER_ID || ''">'' || OWNER_USERNAME || ''</a>'' AS "OWNER",
        <#elseif GROUP_BY="TEST_SUITE_NAME">
          ''<a href="test-runs/'' || TEST_RUN_ID || ''">'' || TEST_SUITE_NAME || ''</a>'' AS "SUITE",
          ${GROUP_BY} AS "${GROUP_BY}",
        <#elseif GROUP_BY="APP_VERSION">
          APP_VERSION AS "BUILD",
        </#if>
        SUM(PASSED) AS "PASS",
        SUM(FAILED) AS "FAIL",
        SUM(KNOWN_ISSUE) AS "DEFECT",
        SUM(SKIPPED) AS "SKIP",
        SUM(ABORTED) AS "ABORT",
        SUM(TOTAL) AS "TOTAL",
        round (100.0 * SUM(PASSED) / (SUM(TOTAL)), 0)::integer AS "PASSED (%)",
        round (100.0 * SUM(FAILED) / (SUM(TOTAL)), 0)::integer AS "FAILED (%)",
        round (100.0 * SUM(KNOWN_ISSUE) / (SUM(TOTAL)), 0)::integer AS "KNOWN ISSUE (%)",
        round (100.0 * SUM(SKIPPED) / (SUM(TOTAL)), 0)::integer AS "SKIPPED (%)",
        round (100.0 * (SUM(TOTAL)-SUM(PASSED)) / (SUM(TOTAL)), 0)::integer AS "FAIL RATE (%)"
    FROM ${VIEW}
    ${WHERE_MULTIPLE_CLAUSE}
    <#if GROUP_BY="OWNER_USERNAME" >
      GROUP BY OWNER_ID, OWNER_USERNAME
    <#elseif GROUP_BY="TEST_SUITE_NAME">
      GROUP BY TEST_RUN_ID, TEST_SUITE_NAME
    <#elseif GROUP_BY="APP_VERSION">
      GROUP BY APP_VERSION
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
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, JOB_NAME-->
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

 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
 <#if PARENT_JOB != "" && PARENT_BUILD == "LATEST">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["OWNER", "SUITE", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "FAIL RATE (%)"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
    ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "OWNER_USERNAME",
      "TEST_SUITE_NAME",
      "APP_VERSION"
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
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', 
	LEGEND_CONFIG='{"legend": ["OWNER", "SUITE", "BUILD", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "QUEUE", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "QUEUED (%)", "FAIL RATE (%)"]}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 24 Hours",
  "GROUP_BY": "TEST_SUITE_NAME",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', 
	HIDDEN=false
WHERE NAME='TESTS SUMMARY';

UPDATE WIDGET_TEMPLATES 
SET NAME='APPLICATION ISSUES (BLOCKERS) DETAILS', DESCRIPTION='Detailed information about known issues and blockers.', TYPE='TABLE', 
	SQL='<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />

SELECT
      ''<a href=${JIRA_URL}'' || ''/'' || BUG || '' target="_blank">'' || BUG || ''</a>'' AS "BUG",
      BUG_SUBJECT AS "SUBJECT",
      ''<a href=${JIRA_URL}'' || ''/'' || TASK || '' target="_blank">'' || TASK || ''</a>'' AS "TASK",
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

 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
 <#if PARENT_JOB != "" && PARENT_BUILD == "LATEST">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["BUG", "SUBJECT", "TASK", "PROJECT", "ENV", "OWNER", "PLATFORM", "PLATFORM_VERSION", "BROWSER", "BROWSER_VERSION", "APP_VERSION", "DEVICE", "LOCALE", "SUITE NAME", "TEST_INFO_URL", "Error Message"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
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
  "BLOCKER": {
    "values": [
      "false",
      "true"
    ],
    "type": "radio",
    "required": true
  },
  "JIRA_URL": {
    "value": "https://mycompany.atlassian.net/browse",
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
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
}', 
	LEGEND_CONFIG='{"legend": ["BUG", "SUBJECT", "TASK", "PROJECT", "ENV", "OWNER", "PLATFORM", "PLATFORM_VERSION", "BROWSER", "BROWSER_VERSION", "APP_VERSION", "DEVICE", "LOCALE", "SUITE NAME", "TEST_INFO_URL", "Error Message"]}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 30 Days",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": [],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "BLOCKER": "false",
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": "",
  "JIRA_URL": "https://mycompany.atlassian.net/browse"
}', 
	HIDDEN=false
WHERE NAME='APPLICATION ISSUES (BLOCKERS) DETAILS';

UPDATE WIDGET_TEMPLATES 
SET NAME='TEST CASES BY STABILITY', DESCRIPTION='Shows all test cases with low stability percent rate per appropriate period (default - less than 10%).', TYPE='TABLE', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOWER(PLATFORM)", "OWNER_USERNAME", "ENV", "PRIORITY", "FEATURE", "BROWSER", "LOCALE", "JOB_NAME"] >

<#global MULTIPLE_VALUES = {
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "OWNER_USERNAME": join(USER),
  "PROJECT": multiJoin(PROJECT, projects),
  "ENV": join(ENV),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE)
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
      <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, JOB_NAME-->
        <#continue>
      </#if>
      
      <#if result?length != 0>
       <#local result = result + " AND "/>
      </#if>
      <#local result = result + key + " LIKE ANY (''{" + map[key] + "}'')"/>
    </#if>
  </#list>


  <#if PARENT_JOB != "" && PERIOD != "Total" && PERIOD != "Monthly">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["PROJECT", "TEST METHOD", "STABILITY"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
    ],
    "required": true
  },
  "PERCENT": {
    "value": "10",
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 30 Days",
  "PROJECT": [],
  "PERCENT": 0,
  "USER": [],
  "PLATFORM": [],
  "PLATFORM_VERSION": [],
  "BROWSER": [],
  "BROWSER_VERSION": [],
  "ENV": [],
  "LOCALE": [],
  "PARENT_JOB": "",
  "JOB_NAME": "",
  "PRIORITY": [],
  "FEATURE": []
}', 
	HIDDEN=false
WHERE NAME='TEST CASES BY STABILITY';

UPDATE WIDGET_TEMPLATES 
SET NAME='PASS RATE (PIE + LINE)', DESCRIPTION='Consolidated test status trend with the ability to specify 10+ extra filters and grouping by hours, days, month etc.', TYPE='OTHER',
	SQL='<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />
<#global VIEW = getView(PERIOD) />
<#global GROUP_AND_ORDER_BY = getGroupBy(PERIOD, PARENT_JOB) />

SELECT
      ${GROUP_AND_ORDER_BY} AS "STARTED_AT",
      sum( PASSED ) AS "PASSED",
      sum( FAILED ) AS "FAILED",
      sum( SKIPPED ) AS "SKIPPED",
      sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
      sum( ABORTED ) AS "ABORTED"
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

 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
    <#local result = getStartedAt(PERIOD) />
  </#if>
 <#return result>
</#function>
<#--
    Retrieves actual CREATED_BY grouping  by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getStartedAt value>
  <#local result = "to_char(date_trunc(''day'', STARTED_AT), ''YYYY-MM-DD'')" />
  <#switch value>
    <#case "Last 24 Hours">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''MM-DD HH24:MI'')" />
      <#break>
    <#case "Nightly">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 7 Days">
    <#case "Last 14 Days">
    <#case "Last 30 Days">
    <#case "Weekly">
    <#case "Monthly">
      <#local result = "to_char(date_trunc(''day'', STARTED_AT), ''YYYY-MM-DD'')" />
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>' , 
	CHART_CONFIG='setTimeout(function() {
  const created = dataset[0].STARTED_AT.toString();
  const lastCount = dataset.length - 1;
  const lastValue = dataset[lastCount].STARTED_AT.toString();
  
  let dataSource = [["STARTED_AT"], ["PASSED"], ["FAILED"], ["SKIPPED"], ["ABORTED"], ["KNOWN ISSUE"]];
  
  const createDatasetSource = () => {
    let amount = dataset.length;
    for (let i = 0; i < amount; i++) {
      dataSource.forEach((value, index) => {
        let valueName = value[0];
        let pushValue = dataset[i][valueName];
        if (valueName === "STARTED_AT") value.push(pushValue.toString());
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
      if (testName === "STARTED_AT") continue;
      total +=  dataset[value][testName];
    }
    
    for (let i = 0; i < dataSource.length; i++){
      newDataObj[dataSource[i][0]] = dataset[value][dataSource[i][0]]
    }
    
    Object.entries(newDataObj).forEach(([key, value]) => {
      if (value === 0) return;
      if (key === "STARTED_AT") return name = typeof value == "number"? `{BUILD|Build: ${value}}` : `{BUILD|Date: ${value}}`;

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
  
let colors = ["#61c8b3", "#e76a77", "#fddb7a", "#b5b5b5", "#9f5487"];
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
      itemName: "STARTED_AT",
      value: lastValue,
      tooltip: lastValue
    },
    selectedMode : true,
      label: {
        show: true,
        position: "inside",
        formatter: (params) => {
          if(params.percent <= 2) return "";
          return `${params.value[params.encode.value[0]]} \n (${params.percent}%)`
        }
      }
  }
  
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
            showDelay: 1,
            "extraCssText": "transform: translateZ(0);"
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
                     formatter: (params) => {
                    if(params.percent <= 2) return "";
                    return `${params.value[params.encode.value[0]]} \n (${params.percent}%)`
                    }
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
}, 1000)' , 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
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
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
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
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Monthly",
  "PERSONAL": "false",
  "currentUserId": 2,
  "PROJECT": [],
  "USER": ["anonymous"],
  "ENV": [],
  "PRIORITY": [],
  "FEATURE": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "Carina-Demo-Regression-Pipeline",
  "PARENT_BUILD": ""
}', HIDDEN=false
WHERE NAME='PASS RATE (PIE + LINE)';

UPDATE WIDGET_TEMPLATES 
SET NAME='TESTS FAILURES BY SUITE', DESCRIPTION='Shows all test cases with failures count per appropriate period and possibility to view detailed information for each suite/test.', TYPE='TABLE', 
	SQL='<#global IGNORE_TOTAL_PARAMS = ["LOCALE", "JOB_NAME", "PARENT_BUILD"] >
<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "TEST_SUITE_FILE": join(TEST_SUITE_FILE),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE)
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
        <#-- Ignore non supported filters for Total View: PLATFORM, DEVICE, APP_VERSION, LOCALE, JOB_NAME-->
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


 <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
 </#if>
 
 <#if PARENT_JOB != "" && PARENT_BUILD == "LATEST">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = (
            SELECT MAX(UPSTREAM_JOB_BUILD_NUMBER)
            FROM TEST_RUNS INNER JOIN
              JOBS ON TEST_RUNS.UPSTREAM_JOB_ID = JOBS.ID
            WHERE JOBS.NAME=''${PARENT_JOB}'')"/>
  <#elseif PARENT_JOB != "" && PARENT_BUILD != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_BUILD_NUMBER = ''" + PARENT_BUILD + "''"/>  
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
 <#return value?replace(" ", "_") + "_view">
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
</#function>', 
	CHART_CONFIG='{"columns": ["SUITE", "NAME", "FAILURES COUNT", "TOTAL COUNT", "FAILURE %"]}', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Last 24 Hours",
      "Last 7 Days",
      "Last 14 Days",
      "Last 30 Days",
      "Nightly",
      "Weekly",
      "Monthly",
      "Quarterly"
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
  "TEST_SUITE_FILE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(FILE_NAME) FROM TEST_SUITES WHERE FILE_NAME IS NOT NULL AND FILE_NAME <> '''' ORDER BY 1;",
    "multiple": true,
    "required": true
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOCALE FROM TEST_CONFIGS WHERE LOCALE IS NOT NULL AND LOCALE <> '''';",
    "multiple": true
  },
  "JOB_NAME": {
    "value": "",
    "required": false
  },
  "PARENT_BUILD": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Monthly",
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
  "BROWSER": [],
  "LOCALE": [],
  "JOB_NAME": "",
  "PARENT_JOB": "",
  "PARENT_BUILD": ""
}', 
	HIDDEN=false
WHERE NAME='TESTS FAILURES BY SUITE';

UPDATE WIDGET_TEMPLATES 
SET NAME='PASS RATE (CALENDAR)', DESCRIPTION='Calendar view of the pass rate per month, quarter or year.', TYPE='OTHER', 
	SQL='<#global IGNORE_PERSONAL_PARAMS = ["OWNER_USERNAME"] >

<#global MULTIPLE_VALUES = {
  "PROJECT": multiJoin(PROJECT, projects),
  "OWNER_USERNAME": join(USER),
  "ENV": join(ENV),
  "PRIORITY": join(PRIORITY),
  "FEATURE": join(FEATURE),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER)
}>
<#global WHERE_MULTIPLE_CLAUSE = generateMultipleWhereClause(MULTIPLE_VALUES) />

SELECT 
    to_char(STARTED_AT, ''YYYY-MM-DD'') as "date",
    ROUND(sum(passed)*100/sum(total)) AS "value",
    ''${PASSED_VALUE}'' as "passed"
    FROM total_view
    ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY 1
UNION ALL
SELECT 
    to_char(STARTED_AT, ''YYYY-MM-DD'') as "date",
    ROUND(sum(passed)*100/sum(total)) AS "value",
    ''${PASSED_VALUE}'' as "passed"
    FROM nightly_view
    ${WHERE_MULTIPLE_CLAUSE}
  GROUP BY 1 
  ORDER BY 1


<#--
    Generates WHERE clause for multiple choosen parameters
    @map - collected data to generate ''where'' clause (key - DB column name : value - expected DB value)
    @return - generated WHERE clause
  -->

<#function generateMultipleWhereClause map>
  <#local result = "" />
    <#if PERIOD?length = 4 || PERIOD = "YEAR">
      <#if PERIOD = "YEAR">
        <#local result = result + " to_char(STARTED_AT, ''YYYY'') " + " LIKE to_char(CURRENT_DATE, ''YYYY'')"/>
      <#else>
        <#local result = result + " to_char(STARTED_AT, ''YYYY'') " + " LIKE ''${PERIOD}''"/>
      </#if>
    <#elseif PERIOD != "MONTH" && PERIOD?substring(5, 6) == "Q" || PERIOD = "QUARTER" >
      <#if PERIOD = "QUARTER">
        <#local result = result + " to_char(STARTED_AT, ''YYYY-Q'') " + " LIKE to_char(CURRENT_DATE, ''YYYY-Q'')"/>
      <#else>
        <#local result = result + " to_char(STARTED_AT, ''YYYY'') || ''-Q'' || to_char(STARTED_AT, ''Q'') " + " LIKE ''${PERIOD}''"/>
      </#if>
    <#else>
      <#if PERIOD = "MONTH">
        <#local result = result + " to_char(STARTED_AT, ''YYYY-MM'') " + " LIKE to_char(CURRENT_DATE, ''YYYY-MM'')"/>
      <#else>
        <#local result = result + " to_char(STARTED_AT, ''YYYY-MM'') " + " LIKE ''${PERIOD}''"/>
      </#if>
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

  <#if result?length != 0 && PERSONAL == "true">
    <!-- add personal filter by currentUserId with AND -->
    <#local result = result + " AND OWNER_ID=${currentUserId} "/>
  <#elseif result?length == 0 && PERSONAL == "true">
    <!-- add personal filter by currentUserId without AND -->
    <#local result = " OWNER_ID=${currentUserId} "/>
  </#if>

  <#if PARENT_JOB != "">
    <#if result?length != 0>
      <#local result = result + " AND "/>
    </#if>
    <#local result = result + "UPSTREAM_JOB_NAME = ''" + PARENT_JOB + "''"/>
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
</#function>', 
	CHART_CONFIG='const data = [];
const range = () => {
  let ranges = new Set();

  dataset.forEach(({date, value}) => {
    const d = new Date(date);
    const range =  d.getFullYear() + "-" + (d.getMonth() + 1);
    const newDate = range + "-" +  d.getDate();

    ranges.add(range);
    data.push(new Array(newDate, value));
  });

  let temporary = [];
  for (let value of ranges) temporary.push(value);

  return [temporary[0], data[data.length -1][0]]
};

const color = () => {
    const red = "#e76a77";
    const yellow = "#fddb7a";
    const green = "#61c8b3";
    const colorArrLenght = 20;
    const greenValue = dataset[0].passed || 75;
    let colors = [];

    const creatorColorArr = (color, count) => {
      for (var i = 0; i < Math.round(count); i++) colors.push(color);
    }

    let passed = colorArrLenght - (colorArrLenght*greenValue/100);
    let aboard = (colorArrLenght - passed)/3;
    let failed = colorArrLenght - passed - aboard

    creatorColorArr(green, passed);
    creatorColorArr(yellow, aboard);
    creatorColorArr(red, failed);

    return colors.reverse()
};


let option = {
    tooltip: {
      position: "top",
      formatter: (p) => p.data[1] + "%",
      "extraCssText": "transform: translateZ(0);"
    },
    visualMap: {
      min: 0,
      max: 100,
      calculable: true,
      orient: "vertical",
      bottom: 20,
      right:20,
      inRange: {
        color: color(),
        symbolSize: [10, 100]
      } 
    },
    calendar: {
      left: 40,
      right: 80,
      top: 50,
      bottom:20,
      orient: "horizontal",
      range: range(),
      cellSize: 30,
      dayLabel: {
        nameMap: "en",
        firstDay: 1, // start on Monday
        margin: 5
      },
      yearLabel:{
        position: "top"
      },
      itemStyle: {
        color: ["white"],
        borderWidth: 1,
        borderColor: "#ccc"
      }
    },
    series: [{
      type: "heatmap",
      coordinateSystem: "calendar",
      calendarIndex: 0,
      label: {
        show: true,
        formatter: function (params) {
            let d = echarts.number.parseDate(params.value[0]);
            return d.getDate();
        },
        color: "#000"
      },
      data: data
    }]
};

chart.setOption(option);', 
	PARAMS_CONFIG='{
  "PERIOD": {
    "values": [],
    "valuesQuery": "SELECT ''YEAR'' UNION ALL SELECT ''QUARTER'' UNION ALL SELECT ''MONTH'' UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY'') FROM total_view UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY'') || ''-Q'' || to_char(STARTED_AT, ''Q'') FROM total_view UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY-MM'') FROM total_view UNION SELECT DISTINCT to_char(STARTED_AT, ''YYYY-MM'') FROM NIGHTLY_VIEW ORDER BY 1 DESC;",
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
  "PASSED_VALUE": {
    "value": 75,
    "required": false
  },
  "PROJECT": {
    "values": [],
    "valuesQuery": "SELECT NAME FROM PROJECTS WHERE NAME <> '''' ORDER BY 1;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT USERNAME FROM USERS ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(PLATFORM) FROM TEST_CONFIGS WHERE PLATFORM <> '''' ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT LOWER(BROWSER) FROM TEST_CONFIGS WHERE BROWSER <> '''' ORDER BY 1;",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT ENV FROM TEST_CONFIGS WHERE ENV IS NOT NULL AND ENV <> '''' ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''priority'' ORDER BY 1;",
    "multiple": true
  },
  "FEATURE": {
    "values": [],
    "valuesQuery": "SELECT VALUE FROM LABELS WHERE KEY=''feature'' ORDER BY 1;",
    "multiple": true
  },
  "PARENT_JOB": {
    "value": "",
    "required": false
  }
}', 
	PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "MONTH",
  "PASSED_VALUE": "75",
  "PERSONAL": "false",
  "currentUserId": 1,
  "PROJECT": [],
  "USER": ["anonymous"],
  "PLATFORM": [],
  "BROWSER": [],
  "FEATURE": [],
  "ENV": [],
  "PRIORITY": [],
  "PARENT_JOB": ""
}', 
	HIDDEN=false
WHERE NAME='PASS RATE (CALENDAR)';

