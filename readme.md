simple script to replace `substring` with `string` in all char/text-columns of given datasource.

## usage:
1. Create instace
        <cfset dbr = new databasereplacr() />
2. Set datasource-name in which to search&replace
        <cfset dbr.datasource = dsn />
3. Call the ReplaceInDB-function
        <cfset info = dbr.ReplaceInDB("foo","bar") />

