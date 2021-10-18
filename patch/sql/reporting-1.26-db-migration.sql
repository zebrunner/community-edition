--#2316 adjust cron schedule for materialzied views refresh
SET SCHEMA 'cron';
DELETE FROM JOB;
SELECT cron.schedule ('0 0 1 * *', $$REFRESH MATERIALIZED VIEW CONCURRENTLY zafira.YEAR_MATERIALIZED$$);
SELECT cron.schedule ('10 0 1 1 *', $$REFRESH MATERIALIZED VIEW CONCURRENTLY zafira.TOTAL_MATERIALIZED$$);

--#2317 remove DEFECTS DETAILS widget template
SET SCHEMA 'zafira';
DELETE FROM WIDGETS WHERE WIDGET_TEMPLATE_ID IN (SELECT ID FROM MANAGEMENT.WIDGET_TEMPLATES WHERE NAME='DEFECTS DETAILS');
SET SCHEMA 'management';
DELETE FROM MANAGEMENT.WIDGET_TEMPLATES WHERE NAME='DEFECTS DETAILS';

--#2322 remove TEST CASES BY STABILITY widget template
SET SCHEMA 'zafira';
DELETE FROM WIDGETS WHERE WIDGET_TEMPLATE_ID IN (SELECT ID FROM MANAGEMENT.WIDGET_TEMPLATES WHERE NAME='TEST CASES BY STABILITY');
SET SCHEMA 'management';
DELETE FROM MANAGEMENT.WIDGET_TEMPLATES WHERE NAME='TEST CASES BY STABILITY';

--#2314 bump up to the latest version of views and widgets
SET SCHEMA 'management';
UPDATE WIDGET_TEMPLATES
SET NAME='DEFECTS COUNT', DESCRIPTION='A number of unique application bugs discovered and submitted by automation.', TYPE='TABLE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>

<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

  SELECT OWNER AS "OWNER",
    ''<div title="'' || string_agg(DISTINCT(BUG), '', '') || ''">'' || COUNT(DISTINCT(BUG))::TEXT || ''</div>'' AS "COUNT"
  FROM ${VIEW}
  ${WHERE_CLAUSE}
  GROUP BY 1
  ORDER BY 2 DESC

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "WHERE KNOWN_ISSUE > 0"/>
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>    

  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
</#function>',
        CHART_CONFIG='{"columns": ["OWNER", "COUNT"]}',
        LEGEND_CONFIG='',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  } 
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Today",
  "currentUserId": 2,
  "dashboardName": "",  
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='DEFECTS COUNT';



UPDATE WIDGET_TEMPLATES
SET NAME='FAILURES BY RUN', DESCRIPTION='Show failures per run.', TYPE='TABLE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>

<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

  SELECT
      RUN_NAME AS "RUN",
      SUM(FAILED) AS "FAILURES COUNT",
      SUM(TOTAL) AS "TOTAL COUNT",
      ROUND(SUM(FAILED)/SUM(TOTAL)*100) AS "FAILURE %"
    FROM ${VIEW}
    ${WHERE_CLAUSE}
    GROUP BY 1
    HAVING SUM(FAILED) > 0
    ORDER BY 1

    
<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>    
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "${VIEW}.PROJECT_ID=${projectId?c}", result) />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
</#function>',
        CHART_CONFIG='{"columns": ["RUN", "FAILURES COUNT", "TOTAL COUNT", "FAILURE %"]}',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Today",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='FAILURES BY RUN';

UPDATE WIDGET_TEMPLATES
SET NAME='FAILURES BY REASON', DESCRIPTION='Summarized information about failures grouped by reason.', TYPE='TABLE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES, PERIOD) />

SELECT 
  (SELECT substring(MESSAGE from 1 for 200) FROM TEST_EXECUTIONS WHERE MESSAGE_HASH_CODE = MESSAGE_HASHCODE LIMIT 1) AS "REASON",
  CASE
  WHEN (INTEGRATION_JIRA_CONFIGS.URL IS NULL OR INTEGRATION_JIRA_CONFIGS.ENABLED=false)
    THEN BUG
    ELSE ''<a href="'' || INTEGRATION_JIRA_CONFIGS.URL || ''/browse/'' || BUG || ''" target="_blank">'' || BUG || ''</a>''
  END AS "DEFECT",
  SUM(TOTAL) as "#",
  <#if projectId?has_content>
    ''<a href="projects/'' || ${projectId?c} || ''/dashboards/'' || 
      (select ID from dashboards where title=''Failures analysis'') ||
        ''?PERIOD=${PERIOD}&hashcode='' || MESSAGE_HASHCODE || ''">View</a>'' AS "REPORT",
  <#else>
    ''<a href="dashboards/'' || (select ID from dashboards where title=''Failures analysis'') || 
      ''?PERIOD=${PERIOD}&hashcode='' || MESSAGE_HASHCODE  || ''">View</a>'' AS "REPORT",
  </#if>
  (SELECT to_char(date_trunc(''day'', MIN(START_TIME)), ''YYYY-MM-DD'') FROM TEST_EXECUTIONS WHERE MESSAGE_HASH_CODE=MESSAGE_HASHCODE) AS "SINCE",
  to_char(date_trunc(''day'', MAX(STARTED_AT)), ''YYYY-MM-DD'') AS "REPRO"
  FROM ${VIEW}
    LEFT JOIN INTEGRATION_JIRA_CONFIGS ON 1 = INTEGRATION_JIRA_CONFIGS.ID
  ${WHERE_CLAUSE}
  GROUP BY "REASON", "DEFECT", MESSAGE_HASHCODE
  HAVING COUNT(*) >= ${ERROR_COUNT}
  ORDER BY 3 DESC, 1, 2

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map, period>
  <#local result = "WHERE MESSAGE_HASHCODE IS NOT NULL AND MESSAGE_HASHCODE <> 0" />

  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "${VIEW}.PROJECT_ID=${projectId?c}", result) />
  </#if>
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
</#function>',
        CHART_CONFIG='{"columns": ["REASON", "DEFECT", "#", "REPORT", "SINCE", "REPRO"]}',
        LEGEND_CONFIG='',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "ERROR_COUNT": {
    "value": "0",
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Today",
  "ERROR_COUNT": 0,
  "currentUserId": -1,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='FAILURES BY REASON';

UPDATE WIDGET_TEMPLATES
SET NAME='FAILURES DETAILS', DESCRIPTION='Detailed information about same/similar errors.', TYPE='TABLE',
        SQL='<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(PERIOD) />

SELECT 
	TEST_SUITE_EXECUTIONS.NAME AS "RUN",
	<#if projectId?has_content>
	  ''<a div="'' || LPAD(TEST_EXECUTIONS.ID::text, 10, ''0'') || ''" href="projects/'' || TEST_SUITE_EXECUTIONS.PROJECT_ID || ''/test-runs/'' || TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID || ''/tests/'' || TEST_EXECUTIONS.ID || ''">'' || TEST_EXECUTIONS.NAME || ''</a>'' AS "TEST",
	<#else>
	  ''<a div="'' || LPAD(TEST_EXECUTIONS.ID::text, 10, ''0'') || ''" href="test-runs/'' || TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID || ''/tests/'' || TEST_EXECUTIONS.ID || ''">'' || TEST_EXECUTIONS.NAME || ''</a>'' AS "TEST",
	 </#if>
  CASE
    WHEN (INTEGRATION_JIRA_CONFIGS.URL IS NULL OR INTEGRATION_JIRA_CONFIGS.ENABLED=false)
      THEN ISSUE_REFERENCES.VALUE
      ELSE ''<a href="'' || INTEGRATION_JIRA_CONFIGS.URL || ''/browse/'' || ISSUE_REFERENCES.VALUE || ''" target="_blank">'' || ISSUE_REFERENCES.VALUE || ''</a>''
  END AS "DEFECT" 	
FROM TEST_EXECUTIONS
	INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID = TEST_SUITE_EXECUTIONS.ID
	LEFT JOIN ISSUE_REFERENCES ON TEST_EXECUTIONS.ISSUE_REFERENCE_ID = ISSUE_REFERENCES.ID
	LEFT JOIN INTEGRATION_JIRA_CONFIGS ON 1 = INTEGRATION_JIRA_CONFIGS.ID
${WHERE_CLAUSE}
ORDER BY 1, 2 DESC
--ORDER BY 2 DESC

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause period>
  <#local result = "WHERE TEST_EXECUTIONS.MESSAGE_HASH_CODE<>0 AND TEST_EXECUTIONS.MESSAGE_HASH_CODE =${hashcode}"/>
  
  <#switch period>
    <#case "Last 24 Hours">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''1 day'')" />
      <#break>
    <#case "Last 7 Days">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''7 day'')" />
      <#break>
    <#case "Last 14 Days">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''14 day'')" />
      <#break>
    <#case "Last 30 Days">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''30 day'')" />
      <#break>
    <#case "Last 90 Days">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''90 day'')" />
      <#break>
    <#case "Last 365 Days">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= (current_date - interval ''365 day'')" />
      <#break>
    <#case "Today">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= current_date" />
      <#break>
    <#case "Week">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= date_trunc(''week'', current_date)" />
      <#break>
    <#case "Month">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= date_trunc(''month'', current_date)" />
      <#break>
    <#case "Quarter">    
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= date_trunc(''quarter'', current_date)" />
      <#break>
    <#case "Year">
      <#local result += " AND TEST_EXECUTIONS.START_TIME >= date_trunc(''year'', current_date)" />
      <#break>
  </#switch>
  

  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "TEST_SUITE_EXECUTIONS.PROJECT_ID=${projectId?c}", result) />
  </#if>
 
  <#return result>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>',
        CHART_CONFIG='{"columns": ["RUN", "TEST", "DEFECT"]}',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  }
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 30 Days",
  "hashcode": -1
}',
        HIDDEN=true
WHERE NAME='FAILURES DETAILS';

UPDATE WIDGET_TEMPLATES
SET NAME='FAILURES INFO', DESCRIPTION='Information about same/similar errors.', TYPE='TABLE',
        SQL='<#global WHERE_CLAUSE = generateWhereClause() />
<#global VIEW = PERIOD?replace(" ", "_") />

SELECT SUM(TOTAL)::text AS "#",
  substring((SELECT TEST_EXECUTIONS.MESSAGE FROM TEST_EXECUTIONS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID = TEST_SUITE_EXECUTIONS.ID WHERE TEST_EXECUTIONS.MESSAGE_HASH_CODE=MIN(MESSAGE_HASHCODE) LIMIT 1) from 1 for 512) as "ERROR/STABILITY",
	to_char(date_trunc(''day'', MIN(STARTED_AT)), ''YYYY-MM-DD'') AS "SINCE",
	to_char(date_trunc(''day'', MAX(STARTED_AT)), ''YYYY-MM-DD'') AS "REPRO"
FROM ${VIEW}
  ${WHERE_CLAUSE}


<#--
  Generates WHERE clause 
  @return - generated WHERE clause
-->
<#function generateWhereClause>
  <#local result = "WHERE MESSAGE_HASHCODE<>0 AND MESSAGE_HASHCODE IN (${hashcode})"/>

  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>
 
  <#return result>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>',
        CHART_CONFIG='{"columns": ["#", "ERROR/STABILITY", "SINCE", "REPRO"]}',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  }
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Today",
  "hashcode": -1
}',
        HIDDEN=true
WHERE NAME='FAILURES INFO';


UPDATE WIDGET_TEMPLATES
SET NAME='PASS RATE (BAR)', DESCRIPTION='Pass rate bar chart with an extra grouping by owner, env, locale etc.', TYPE='BAR',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

SELECT ${GROUP_BY} AS "GROUP_FIELD",
  sum( PASSED ) AS "PASSED",
  sum( KNOWN_ISSUE ) AS "KNOWN ISSUE",
  0 - sum( FAILED ) AS "FAILED",
  0 - sum( SKIPPED ) AS "SKIPPED",
  0 - sum( ABORTED ) AS "ABORTED"
FROM ${VIEW}
${WHERE_CLAUSE}
GROUP BY 1
ORDER BY 1 DESC


<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>  
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>
  
  <#if result?length != 0>
    <#local result = "WHERE " + result/>
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "OWNER",
      "ENV",
      "LOCALE",
      "BUILD",
      "RUN_NAME",
      "PLATFORM",
      "BROWSER",
      "PRIORITY"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Today",
  "GROUP_BY": "PLATFORM",  
  "currentUserId": 2,
  "dashboardName": "",  
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='PASS RATE (BAR)';


UPDATE WIDGET_TEMPLATES
SET NAME='PASS RATE (CALENDAR)', DESCRIPTION='Calendar view of the pass rate per month, quarter or year.', TYPE='OTHER',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>

<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

SELECT 
    to_char(STARTED_AT, ''YYYY-MM-DD'') as "date",
    ROUND(sum(passed)*100/sum(total)) AS "value",
    ''${PASSED_VALUE}'' as "passed"
    FROM TOTAL
    ${WHERE_CLAUSE}
  GROUP BY 1

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />

  <#if PERIOD?length = 4 || PERIOD = "YEAR">
    <#if PERIOD = "YEAR">
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY'') LIKE to_char(CURRENT_DATE, ''YYYY'')", result) />
    <#else>
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY'') LIKE ''${PERIOD}''", result) />
    </#if>
  <#elseif PERIOD != "MONTH" && PERIOD?substring(5, 6) == "Q" || PERIOD = "QUARTER" >
    <#if PERIOD = "QUARTER">
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY-Q'') LIKE to_char(CURRENT_DATE, ''YYYY-Q'')", result) />
    <#else>
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY'') || ''-Q'' || to_char(STARTED_AT, ''Q'') LIKE ''${PERIOD}''", result) />
    </#if>
  <#else>
    <#if PERIOD = "MONTH">
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY-MM'') LIKE to_char(CURRENT_DATE, ''YYYY-MM'')", result) />
    <#else>
      <#local result = result + addCondition("AND", "to_char(STARTED_AT, ''YYYY-MM'') LIKE ''${PERIOD}''", result) />
    </#if>
  </#if>

  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>

  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>  

  <#if result?length != 0>
    <#local result = "WHERE " + result/>
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
    "valuesQuery": "SELECT ''YEAR'' UNION ALL SELECT ''QUARTER'' UNION ALL SELECT ''MONTH'' UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY'') FROM TOTAL UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY'') || ''-Q'' || to_char(STARTED_AT, ''Q'') FROM TOTAL UNION ALL SELECT DISTINCT to_char(STARTED_AT, ''YYYY-MM'') FROM TOTAL ORDER BY 1 DESC;",
    "required": true
  },
  "PASSED_VALUE": {
    "value": 75,
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  } 
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "MONTH",
  "PASSED_VALUE": "75",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='PASS RATE (CALENDAR)';


UPDATE WIDGET_TEMPLATES
SET NAME='PASS RATE (LINE)', DESCRIPTION='Consolidated tests status data supporting 10+ extra filters.', TYPE='LINE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />
<#global GROUP_AND_ORDER_BY = getStartedAt(PERIOD) />

SELECT
  ${GROUP_AND_ORDER_BY} AS "STARTED_AT",
  SUM( PASSED ) AS "PASSED",
  SUM( FAILED ) AS "FAILED",
  SUM( SKIPPED ) AS "SKIPPED",
  SUM( KNOWN_ISSUE ) AS "KNOWN ISSUE",
  SUM( ABORTED ) AS "ABORTED"
FROM ${VIEW}
${WHERE_CLAUSE}
GROUP BY ${GROUP_AND_ORDER_BY}
ORDER BY ${GROUP_AND_ORDER_BY};

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />

  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>    
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>

  <#if result?length != 0>
    <#local result = "WHERE " + result/>
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
    <#case "Today">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 90 Days">
    <#case "Quarter">    
      <#local result = "to_char(date_trunc(''month'', STARTED_AT), ''YYYY-MM'')" />
      <#break>
    <#case "Last 365 Days">
    <#case "Year">
    <#case "Total">
      <#local result = "to_char(date_trunc(''quarter'', STARTED_AT), ''YYYY-" + ''"Q"'' + "Q'')" />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Month",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='PASS RATE (LINE)';


UPDATE WIDGET_TEMPLATES
SET NAME='PASS RATE (PIE)', DESCRIPTION='Consolidated tests status data supporting 10+ extra filters.', TYPE='PIE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

<#if isPersonal() >
SELECT
  unnest(array[OWNER,
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
${WHERE_CLAUSE}
GROUP BY OWNER

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
${WHERE_CLAUSE}
</#if>

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>

  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>  
  
  <#if result?length != 0>
    <#local result = "WHERE " + result/>
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Total",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='PASS RATE (PIE)';


UPDATE WIDGET_TEMPLATES
SET NAME='PASS RATE (PIE + LINE)', DESCRIPTION='Consolidated tests status data supporting 10+ extra filters.', TYPE='OTHER',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>

<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />
<#global GROUP_AND_ORDER_BY = getGroupBy(PERIOD) />

SELECT
  ${GROUP_AND_ORDER_BY} AS "STARTED_AT",
  SUM( PASSED ) AS "PASSED",
  SUM( FAILED ) AS "FAILED",
  SUM( SKIPPED ) AS "SKIPPED",
  SUM( KNOWN_ISSUE ) AS "KNOWN ISSUE",
  SUM( ABORTED ) AS "ABORTED"
FROM ${VIEW}
${WHERE_CLAUSE}
GROUP BY ${GROUP_AND_ORDER_BY}
ORDER BY ${GROUP_AND_ORDER_BY};

<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>  
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>  
  
  <#if result?length != 0>
    <#local result = "WHERE " + result/>
  </#if>
  <#return result>
</#function>


<#function getGroupBy Period>
  <#local result = getStartedAt(PERIOD) />
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
    <#case "Today">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 90 Days">      
    <#case "Quarter">
      <#local result = "to_char(date_trunc(''month'', STARTED_AT), ''YYYY-MM'')" />
      <#break>
    <#case "Last 365 Days">
    <#case "Year">
    <#case "Total">
      <#local result = "to_char(date_trunc(''quarter'', STARTED_AT), ''YYYY-" + ''"Q"'' + "Q'')" />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Total",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}', HIDDEN=false
WHERE NAME='PASS RATE (PIE + LINE)';


UPDATE WIDGET_TEMPLATES
SET NAME='TEST CASE DURATION TREND', DESCRIPTION='All kind of duration metrics per test case.', TYPE='LINE',
        SQL='<#global WHERE_CLAUSE = generateWhereClause() />

SELECT
      ROUND(AVG(EXTRACT(EPOCH FROM (TEST_EXECUTIONS.FINISH_TIME - TEST_EXECUTIONS.START_TIME)))::numeric, 2) as "AVG TIME",
      ROUND(MAX(EXTRACT(EPOCH FROM (TEST_EXECUTIONS.FINISH_TIME - TEST_EXECUTIONS.START_TIME)))::numeric, 2) as "MAX TIME",
      ROUND(MIN(EXTRACT(EPOCH FROM (TEST_EXECUTIONS.FINISH_TIME - TEST_EXECUTIONS.START_TIME)))::numeric, 2) as "MIN TIME",
      to_char(date_trunc(''month'', TEST_EXECUTIONS.START_TIME), ''YYYY-MM'') AS "TESTED_AT"
FROM TEST_EXECUTIONS
  INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID = TEST_SUITE_EXECUTIONS.ID
${WHERE_CLAUSE}
GROUP BY date_trunc(''month'', TEST_EXECUTIONS.START_TIME)
ORDER BY "TESTED_AT"


<#--
  Generates WHERE clause 
  @return - generated WHERE clause
-->
<#function generateWhereClause>
  <#local result = "WHERE TEST_FUNCTION_ID=${testFunctionId} AND TEST_EXECUTIONS.FINISH_TIME IS NOT NULL AND TEST_EXECUTIONS.START_TIME IS NOT NULL AND TEST_EXECUTIONS.STATUS <> ''IN_PROGRESS''"/>

  <#return result>
</#function>



<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>',
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
        PARAMS_CONFIG_SAMPLE='{"testFunctionId": "1"}',
        HIDDEN=true
WHERE NAME='TEST CASE DURATION TREND';


UPDATE WIDGET_TEMPLATES
SET NAME='TEST CASE INFO', DESCRIPTION='Detailed test case information.', TYPE='TABLE',
        SQL='SELECT
  TEST_FUNCTIONS.TEST_CLASS || ''.'' || TEST_FUNCTIONS.TEST_METHOD AS "TEST METHOD",
  TEST_FUNCTIONS.CREATED_AT::date::text AS "CREATED AT"
FROM TEST_FUNCTIONS
WHERE TEST_FUNCTIONS.ID=${testFunctionId}',
        CHART_CONFIG='{"columns": ["TEST METHOD", "CREATED AT"]}',
        PARAMS_CONFIG='{}',
        PARAMS_CONFIG_SAMPLE='{"testFunctionId": "1"}',
        HIDDEN=true
WHERE NAME='TEST CASE INFO';

UPDATE WIDGET_TEMPLATES
SET NAME='TEST CASES DEVELOPMENT TREND', DESCRIPTION='A number of new automated cases per priod.', TYPE='BAR',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>

<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />
<#global CREATED_AT = getCreatedAt(PERIOD) />

SELECT
  ${CREATED_AT} AS "CREATED_AT",
  COUNT(distinct(TEST_FUNCTIONS.ID)) AS "AMOUNT"
FROM ${VIEW}
  INNER JOIN TEST_EXECUTIONS on ${VIEW}.TEST_RUN_ID = TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID
  INNER JOIN TEST_FUNCTIONS ON TEST_EXECUTIONS.TEST_FUNCTION_ID = TEST_FUNCTIONS.ID
${WHERE_CLAUSE}
GROUP BY 1 
ORDER BY 1


<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#if PERIOD == "Today">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= current_date", result) />
  <#elseif PERIOD == "Last 24 Hours">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''hour'', current_date - interval ''24'' hour)", result) />
  <#elseif PERIOD == "Week">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''week'', current_date)  - interval ''2'' day", result) />
  <#elseif PERIOD == "Last 7 Days">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''day'', current_date - interval ''7'' day)", result) />
  <#elseif PERIOD == "Last 14 Days">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''day'', current_date - interval ''14'' day)", result) />
  <#elseif PERIOD == "Last 30 Days">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''day'', current_date - interval ''30'' day)", result) />
  <#elseif PERIOD == "Last 90 Days">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''day'', current_date - interval ''90'' day)", result) />    
  <#elseif PERIOD == "Month" >
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''week'', current_date)", result) />
  <#elseif PERIOD == "Quater" >
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''month'', current_date)", result) />
  <#elseif PERIOD == "Last 365 Days">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''day'', current_date - interval ''365'' day)", result) />
  <#elseif PERIOD == "Year">
    <#local result = result + addCondition("AND", "TEST_FUNCTIONS.CREATED_AT >= date_trunc(''year'', current_date)", result) />
  </#if>
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>      
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "${VIEW}.PROJECT_ID=${projectId?c}", result) />
  </#if>  
  
  <#if result?length != 0>
    <#local result = "WHERE " + result/>
  </#if>
  <#return result>
</#function>

<#--
    Retrieves actual CREATED_BY grouping  by abstract view description
    @value - abstract view description
    @return - actual view name
  -->
<#function getCreatedAt value>
  <#local result = "to_char(date_trunc(''day'', TEST_FUNCTIONS.CREATED_AT), ''MM/DD'')" />
  <#switch value>
    <#case "Last 24 Hours">
    <#case "Today">
      <#local result = "to_char(date_trunc(''hour'', TEST_FUNCTIONS.CREATED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 90 Days">    
    <#case "Quarter">
      <#local result = "to_char(date_trunc(''month'', TEST_FUNCTIONS.CREATED_AT), ''YYYY-MM'')" />
      <#break>
    <#case "Last 365 Days">
    <#case "Year">
    <#case "Total">
      <#local result = "to_char(date_trunc(''quarter'', TEST_FUNCTIONS.CREATED_AT), ''YYYY-" + ''"Q"'' + "Q'')" />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  }  
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 30 Days",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='TEST CASES DEVELOPMENT TREND';

UPDATE WIDGET_TEMPLATES
SET NAME='TEST CASE STABILITY', DESCRIPTION='Aggregated stability metric for a test case.', TYPE='PIE',
        SQL='<#global WHERE_CLAUSE = generateWhereClause() />

SELECT 
  unnest(array[''STABILITY'',
                  ''FAILURE'',
                  ''OMISSION'',
                  ''KNOWN ISSUE'',
                  ''INTERRUPT'']) AS "label",
  unnest(array[ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''PASSED'' THEN 1 ELSE 0 END) * 100 /COUNT(*)::numeric, 0),                  
               ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''FAILED'' AND TEST_EXECUTIONS.KNOWN_ISSUE = FALSE THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''SKIPPED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''FAILED'' AND TEST_EXECUTIONS.KNOWN_ISSUE = TRUE THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0),
               ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''ABORTED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)::numeric, 0)]) AS "value"
FROM TEST_EXECUTIONS
  INNER JOIN TEST_FUNCTIONS ON TEST_EXECUTIONS.TEST_FUNCTION_ID = TEST_FUNCTIONS.ID
  INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID = TEST_SUITE_EXECUTIONS.ID
${WHERE_CLAUSE}


<#--
  Generates WHERE clause 
  @return - generated WHERE clause
-->
<#function generateWhereClause>
  <#local result = "WHERE TEST_FUNCTION_ID=${testFunctionId} AND TEST_EXECUTIONS.FINISH_TIME IS NOT NULL AND TEST_EXECUTIONS.START_TIME IS NOT NULL AND TEST_EXECUTIONS.STATUS <> ''IN_PROGRESS''"/>

  <#return result>
</#function>



<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>',
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
        PARAMS_CONFIG_SAMPLE='{"testFunctionId": "1"}',
        HIDDEN=true
WHERE NAME='TEST CASE STABILITY';


UPDATE WIDGET_TEMPLATES
SET NAME='TEST CASE STABILITY TREND', DESCRIPTION='Test case stability trend on a monthly basis.', TYPE='LINE',
        SQL='<#global WHERE_CLAUSE = generateWhereClause() />

SELECT
    ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''PASSED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "STABILITY",
    ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''FAILED'' AND TEST_EXECUTIONS.KNOWN_ISSUE = FALSE THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "FAILURE",
    ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''SKIPPED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "OMISSION",
    ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''FAILED'' AND TEST_EXECUTIONS.KNOWN_ISSUE = TRUE THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "KNOWN ISSUE",
    ROUND(SUM(CASE WHEN TEST_EXECUTIONS.STATUS = ''ABORTED'' THEN 1 ELSE 0 END) * 100 / COUNT(*)) as "INTERRUPT",
    to_char(date_trunc(''month'', TEST_EXECUTIONS.START_TIME), ''YYYY-MM'') AS "TESTED_AT"
FROM TEST_EXECUTIONS
  INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID = TEST_SUITE_EXECUTIONS.ID
${WHERE_CLAUSE}
GROUP BY date_trunc(''month'', TEST_EXECUTIONS.START_TIME)
ORDER BY "TESTED_AT"

<#--
  Generates WHERE clause 
  @return - generated WHERE clause
-->
<#function generateWhereClause>
  <#local result = "WHERE TEST_FUNCTION_ID=${testFunctionId} AND TEST_EXECUTIONS.FINISH_TIME IS NOT NULL AND TEST_EXECUTIONS.START_TIME IS NOT NULL AND TEST_EXECUTIONS.STATUS <> ''IN_PROGRESS''"/>

  <#return result>
</#function>



<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>',
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
        PARAMS_CONFIG_SAMPLE='{"testFunctionId": "1"}',
        HIDDEN=true
WHERE NAME='TEST CASE STABILITY TREND';


UPDATE WIDGET_TEMPLATES
SET NAME='TESTS EXECUTION ROI (MAN-HOURS)', DESCRIPTION='Monthly team/user test execution ROI. 160h+ per person for UI tests indicates that ROI is great.', TYPE='BAR',
        SQL='<#global MULTIPLE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(MULTIPLE_VALUES) />
<#global GROUP_AND_ORDER_BY = getStartedAt(PERIOD) />

SELECT
  ROUND(SUM(TOTAL_SECONDS)/3600) AS "ACTUAL",
  ROUND(SUM(TOTAL_ETA_SECONDS)/3600) AS "ETA",
  --to_char(STARTED_AT, ''YYYY-MM'') AS "STARTED_AT"
  ${GROUP_AND_ORDER_BY} AS "STARTED_AT"
FROM ${VIEW}
${WHERE_CLAUSE}
GROUP BY "STARTED_AT"
ORDER BY "STARTED_AT";


<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />
  
  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>    
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
  </#if>
  
  <#if result?length != 0>
    <#local result = "WHERE " + result/>
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
    <#case "Today">
      <#local result = "to_char(date_trunc(''hour'', STARTED_AT), ''HH24:MI'')" />
      <#break>
    <#case "Last 90 Days">
    <#case "Quarter">    
      <#local result = "to_char(date_trunc(''month'', STARTED_AT), ''YYYY-MM'')" />
      <#break>
    <#case "Last 365 Days">
    <#case "Year">
    <#case "Total">
      <#local result = "to_char(date_trunc(''quarter'', STARTED_AT), ''YYYY-" + ''"Q"'' + "Q'')" />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
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
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },  
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  } 
}',
        PARAMS_CONFIG_SAMPLE = '{
  "PERIOD": "Month",
  "currentUserId": 1,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='TESTS EXECUTION ROI (MAN-HOURS)';


UPDATE WIDGET_TEMPLATES
SET NAME='TESTS SUMMARY', DESCRIPTION='Detailed information about passed, failed, skipped, etc tests.', TYPE='TABLE',
        SQL='<#global WHERE_VALUES = {
  "RUN_STATUS": join(STATUS),
  "BUG": join(DEFECT),
  "BUILD": join(BUILD),
  "ENV": join(ENV),
  "LOWER(PLATFORM)": join(PLATFORM),
  "LOWER(BROWSER)": join(BROWSER),
  "LOCALE": join(LOCALE),
  "PRIORITY": join(PRIORITY),
  "RUN_NAME": join(RUN),
  "OWNER": join(USER)
}>
<#global VIEW = PERIOD?replace(" ", "_") />
<#global WHERE_CLAUSE = generateWhereClause(WHERE_VALUES) />

SELECT
      <#if GROUP_BY="OWNER" >
        <#if projectId?has_content>
          ''<a href="projects/'' || PROJECT_ID || ''/dashboards/'' || (select ID from dashboards where title=''Personal'') || ''?userId='' || OWNER_ID || ''&PERIOD=${PERIOD}">'' || OWNER || ''</a>'' AS "NAME",
        <#else>
          ''<a href="dashboards/'' || (select ID from dashboards where title=''Personal'') || ''?userId='' || OWNER_ID || ''&PERIOD=${PERIOD}">'' || OWNER || ''</a>'' AS "NAME",
        </#if>
      <#elseif GROUP_BY="RUN_NAME">
        RUN_NAME AS "NAME",
      <#elseif GROUP_BY="BUILD">
        BUILD AS "NAME",
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
    ${WHERE_CLAUSE}
    GROUP BY 1
    ORDER BY 1



<#--
  Generates WHERE clause 
  @map - collected multiple choosen data (key - DB column name : value - expected DB value)
  @return - generated WHERE clause
-->
<#function generateWhereClause map>
  <#local result = "" />

  <#list map?keys as key>
    <#if map[key]?has_content && map[key]?contains("null")>
      <#local result = result + addCondition("AND", "(${key} LIKE ANY (''{" + map[key] + "}'') OR ${key} IS NULL)", result) />
    <#elseif map[key]?has_content>
      <#local result = result + addCondition("AND", "${key} LIKE ANY (''{" + map[key] + "}'')", result) />
    </#if>
  </#list>
  
  <#if isPersonal() && !USERS?has_content>
    <!-- USERS filter has higher priority and if provided we should ignore personal board -->
    <#local result = result + addCondition("AND", "OWNER_ID=${currentUserId}", result) />
  </#if>    
  
  <#if projectId?has_content>
    <#local result = result + addCondition("AND", "PROJECT_ID=${projectId?c}", result) />
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
    Correct string value removing ending comma if any
    @line - to analyze and correct
    @return - corrected line
  -->
<#function correct line>
  <#if line?has_content>
    <!-- trim line and remove ending comma if present -->
    <#return line?trim?remove_ending(",") />
  <#else>
    <!-- return empty line if line is null or empty-->
    <#return "" />
  </#if>
</#function>

<#--
    Add valid SQL clause using condition and operator
    @operator - AND/OR/BETWEEN etc
    @condition - field(s) condition
    @query - existing where conditions
    @return - concatenated where clause conditions
  -->
<#function addCondition operator, condition, query>
  <#if query?length != 0>
    <#return " " + operator + " " + condition>
  <#else>
    <#return condition>
  </#if>
</#function>

<#--
    retrun true if dashboard name is ''Personal'' or ''User Performance''
    @return - boolean
  -->
<#function isPersonal>
  <#local result = false />
  <#if dashboardName?has_content>
    <#if dashboardName == "Personal" || dashboardName == "User Performance">
      <#local result = true />  
    </#if>
  </#if>
  <#return result />
</#function>',
        CHART_CONFIG='{"columns": ["NAME", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "FAIL RATE (%)"]}',
        LEGEND_CONFIG='{"legend": ["NAME", "PASS", "FAIL", "DEFECT", "SKIP", "ABORT", "TOTAL", "PASSED (%)", "FAILED (%)", "KNOWN ISSUE (%)", "SKIPPED (%)", "FAIL RATE (%)"]}',
        PARAMS_CONFIG='{
  "PERIOD": {
    "values": [
      "Today",
      "Last 24 Hours",
      "Week",
      "Last 7 Days",
      "Last 14 Days",
      "Month",
      "Last 30 Days",
      "Quarter",
      "Last 90 Days",
      "Year",
      "Last 365 Days",
      "Total"
    ],
    "required": true
  },
  "GROUP_BY": {
    "values": [
      "OWNER",
      "RUN_NAME",
      "BUILD"
    ],
    "required": true
  },
  "STATUS": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(STATUS)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "DEFECT": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(VALUE) FROM ISSUE_REFERENCES INNER JOIN TEST_EXECUTIONS ON ISSUE_REFERENCES.ID=TEST_EXECUTIONS.ISSUE_REFERENCE_ID INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID=TEST_SUITE_EXECUTIONS.ID ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "USER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(USERS.USERNAME) FROM TEST_SUITE_EXECUTIONS INNER JOIN TEST_EXECUTIONS ON TEST_SUITE_EXECUTIONS.ID=TEST_EXECUTIONS.TEST_SUITE_EXECUTION_ID INNER JOIN USERS ON TEST_EXECUTIONS.MAINTAINER_ID=USERS.ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PRIORITY": {
    "values": [],
    "valuesQuery": "select unnest(array[''P0'', ''P1'', ''P2'', ''P3'', ''P4'', ''P5'', ''P6'']);",
    "multiple": true
  },
  "ENV": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(UPPER(ENVIRONMENT)) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "PLATFORM": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(TEST_EXECUTION_CONFIGS.PLATFORM)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "BROWSER": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOWER(BROWSER)) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },
  "LOCALE": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(LOCALE) FROM TEST_EXECUTION_CONFIGS INNER JOIN TEST_SUITE_EXECUTIONS ON TEST_EXECUTION_CONFIGS.ID=TEST_SUITE_EXECUTIONS.CONFIG_ID ${whereClause} ORDER BY 1;",
    "multiple": true
  },  
  "BUILD": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(BUILD) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1 DESC;",
    "multiple": true
  },
  "RUN": {
    "values": [],
    "valuesQuery": "SELECT DISTINCT(NAME) FROM TEST_SUITE_EXECUTIONS ${whereClause} ORDER BY 1;",
    "multiple": true
  } 
}',
        PARAMS_CONFIG_SAMPLE='{
  "PERIOD": "Last 30 Days",
  "GROUP_BY": "RUN_NAME",
  "currentUserId": 2,
  "dashboardName": "",
  "STATUS": [],
  "DEFECT": [],
  "BUILD": [],    
  "ENV": [],
  "PLATFORM": [],
  "BROWSER": [],
  "LOCALE": [],
  "PRIORITY": [],
  "RUN": [],
  "USER": []
}',
        HIDDEN=false
WHERE NAME='TESTS SUMMARY';

