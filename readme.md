# Usage

	<cfset dbr = new databasereplacr(datasource="mydsn") />
	<cfset info = dbr.ReplaceInDB("foo","bar") />

The replace is case sensitive and uses MySQL's [REPLACE-Function][1]

[1]: http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_replace
