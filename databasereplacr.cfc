<CFCOMPONENT output="false">
	<CFPROPERTY name="datasource" type="string" hint="I'm the datasource in which to search and replace" />
	
	<CFFUNCTION name="ReplaceInDB" access="public" returntype="any" output="false" hint="I replace all occurencies of substring in all text columns with given replacestring">
		<CFARGUMENT name="substring" type="string" required="yes" default="foo" hint="I'm gettin replaced">
		<CFARGUMENT name="replacestring" type="string" required="yes" default="bar" hint="I'm the new string">
		
		<cfset var erg = arraynew(1) />
		
		<cfset var qTables = getTableNames() />
		
		<CFLOOP query="qTables">
			<cfset var lFields = arraytolist(getFields(qTables["table_name"][qTables.currentrow])) />
			
			<CFIF listlen(lFields)>
				<CFQUERY result="qReplace" datasource="#this.datasource#">
					UPDATE #qTables["table_name"][qTables.currentrow]#
					SET
					<CFLOOP from="1" to="#listlen(lFields)#" index="idx">
						#listGetAt(lFields,idx)# = REPLACE(#listGetAt(lFields,idx)#, <CFQUERYPARAM value="#arguments.substring#" cfsqltype="cf_sql_varchar" />,<CFQUERYPARAM value="#arguments.replacestring#" cfsqltype="cf_sql_varchar" />)<CFIF listlen(lFields) NEQ idx>,</CFIF>
					</CFLOOP>
					WHERE 2 = 1
					<CFLOOP from="1" to="#listlen(lFields)#" index="idx">
						OR #listGetAt(lFields,idx)# LIKE <CFQUERYPARAM value="%#arguments.substring#%" cfsqltype="cf_sql_varchar" />
					</CFLOOP>
				</CFQUERY>
	
				<cfset arrayappend(erg, {"affected_rows"=qReplace.recordCount, "statement"=qReplace.sql}) />
			</CFIF>
		</CFLOOP>
		
		<CFRETURN erg />
	</CFFUNCTION>
	
	<CFFUNCTION name="getTableNames" access="private" output="false" returntype="query" hint="I get all Tablenames from given database">
		<CFDBINFO type="tables" name="qTables" datasource="#this.datasource#" />
		
		<CFRETURN qTables />
	</CFFUNCTION>
	
	<CFFUNCTION name="getTextFieldsInTable" access="private" output="false" returntype="array" hint="I get all text fields from table as array from describe-query">
		<CFARGUMENT name="fields" type="query" required="yes">
		<cfset var aFields = arraynew(1) /> 
		
		<CFLOOP query="fields">
			<CFIF listfindnocase("char,text",right(fields.type_name,4))>
				<cfset arrayappend(aFields,fields.column_name) />
			</CFIF>
		</CFLOOP>
		
		<CFRETURN aFields />
	</CFFUNCTION>
	
	<CFFUNCTION name="getFields" access="private" output="false" returntype="array" hint="I DESCRIBE a table">
		<CFARGUMENT name="table" type="string" required="yes">
		
		<CFDBINFO name="qFields" datasource="#this.datasource#" type="columns" table="#arguments.table#" />

		<CFRETURN getTextFieldsInTable(qFields) />
	</CFFUNCTION>
</CFCOMPONENT>