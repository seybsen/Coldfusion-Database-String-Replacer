simple script to replace `substring` with `string` in all char/text-columns of given datasource.

**usage:**
    <cfset dbr = new databasereplacr() />
    <cfset dbr.datasource = dsn />
    <cfset info = dbr.ReplaceInDB("foo","bar") />
