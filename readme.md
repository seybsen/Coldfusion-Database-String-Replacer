##Usage:

	<cfset dbr = new databasereplacr() />
	<cfset dbr.datasource = "mydsn" />
	<cfset info = dbr.ReplaceInDB("foo","bar") />