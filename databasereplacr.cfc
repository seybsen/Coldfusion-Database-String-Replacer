<cfcomponent output="false" accessors="true">
	<cfproperty name="datasource" type="string" hint="I'm the datasource in which to search and replace" />

	<cffunction name="init" output="false" returntype="component">
		<cfargument name="datasource" type="string" required="yes" />

		<cfset THIS.setDatasource(arguments.datasource) />

		<cfreturn THIS />
	</cffunction>

	<cffunction name="ReplaceInDB" access="public" returntype="any" output="false" hint="I replace all occurencies of substring in all text columns with given replacestring">
		<cfargument name="substring" type="string" required="yes" default="foo" hint="I'm gettin replaced">
		<cfargument name="replacestring" type="string" required="yes" default="bar" hint="I'm the new string">

		<cfset var result = arraynew(1) />

		<cfset var qTables = getTableNames() />

		<cfloop query="qTables">
			<cfset var lFields = arraytolist(getFields(qTables["table_name"][qTables.currentrow])) />

			<cfif listlen(lFields)>
				<cfquery result="qReplace" datasource="#THIS.getDatasource()#">
					UPDATE `#qTables["table_name"][qTables.currentrow]#`
					SET
					<cfloop from="1" to="#listlen(lFields)#" index="idx">
						`#listGetAt(lFields,idx)#` = REPLACE(`#listGetAt(lFields,idx)#`, <cfqueryparam value="#arguments.substring#" cfsqltype="cf_sql_varchar" />,<cfqueryparam value="#arguments.replacestring#" cfsqltype="cf_sql_varchar" />)<cfif listlen(lFields) NEQ idx>,</cfif>
					</cfloop>
					WHERE 2 = 1
					<cfloop from="1" to="#listlen(lFields)#" index="idx">
						OR `#listGetAt(lFields,idx)#` LIKE <cfqueryparam value="%#arguments.substring#%" cfsqltype="cf_sql_varchar" />
					</cfloop>
				</cfquery>

				<cfset arrayappend(result, {"affected_rows"=qReplace.recordCount, "statement"=qReplace.sql}) />
			</cfif>
		</cfloop>

		<cfreturn result />
	</cffunction>

	<cffunction name="getTableNames" access="private" output="false" returntype="query" hint="I get all Tablenames from given database">
		<cfdbinfo type="tables" name="qTables" datasource="#THIS.getDatasource()#" />

		<cfreturn qTables />
	</cffunction>

	<cffunction name="getTextFieldsInTable" access="private" output="false" returntype="array" hint="I get all text fields from table as array from describe-query">
		<cfargument name="fields" type="query" required="yes">
		<cfset var aFields = arraynew(1) />

		<cfloop query="fields">
			<cfif listfindnocase("char,text",right(fields.type_name,4))>
				<cfset arrayappend(aFields,fields.column_name) />
			</cfif>
		</cfloop>

		<cfreturn aFields />
	</cffunction>

	<cffunction name="getFields" access="private" output="false" returntype="array" hint="I DESCRIBE a table">
		<cfargument name="table" type="string" required="yes">

		<cfdbinfo name="qFields" datasource="#THIS.getDatasource()#" type="columns" table="#arguments.table#" />

		<cfreturn getTextFieldsInTable(qFields) />
	</cffunction>
</cfcomponent>
