<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>DBR-Test</title>
</head>

<body>
<cfset dsn = "ddd" />
<cfset dbr = new databasereplacr() />
<cfset dbr.datasource = dsn />
<cfdump VAR="#dbr#" />
<cfset erg = dbr.ReplaceInDB("""Sebastian""","seybsen") />
<cfdump VAR="#erg#" />
</body>
</html>