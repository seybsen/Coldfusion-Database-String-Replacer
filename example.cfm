<cfset dsn = "example" />

<cfset dbr = new databasereplacr() />
<cfset dbr.datasource = dsn />
<cfset info = dbr.ReplaceInDB("Sebastian","seybsen") />