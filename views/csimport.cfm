<cfsetting showdebugoutput="false" />
<cfif Not StructKeyExists(URL, "import_id") AND Not StructKeyExists(URL, "service")>
	Invalid request. Missing required information.
	<cfabort />
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache;no-store;max-age=0;must-revalidate" />
	<meta http-equiv="expires" content="Fri, 01 Jan 1990 00:00:00 GMT" />
	<title>Importing Contacts</title>
	<link href="/style/overrides.css" rel="stylesheet" type="text/css" />
</head>

<body>
	<strong>Processing request...Do not close the window.</strong><br />
	<cfscript> 
		
		if( StructKeyExists(URL, "import_id") && URL.import_id > 0 ){
			objCloudSponge = application.CloudSponge;
	    	// monitor the import
	    	intImpID = URL.import_id;
	    	strService = URL.service;
	    	// check status
	    	stcResult = objCloudSponge.checkCSImport(intImportID=intImpID);
	    	
	    	if( !StructKeyExists(stcResult,'strStatus') || stcResult.strStatus == 'ERROR' ){
	    		WriteOutput('An error occurred processing your request.');
	    		if( StructKeyExists(stcResult,'error') )
	    			WriteOutput('<br />' & 'Details: ' & stcResult.error );
	    		abort;
	    	}
	    }
	</cfscript>
	
	<cfoutput>
		<script type="text/javascript">
			<cfif stcResult.blnKeepChecking>
				strImportURL = '#application.apphost#/views/csimport.cfm?import_id=#intImpID#&service=#strService#';
				mainPopUp = setTimeout("window.parent.launchPopUp('', strImportURL)",3000);
			<cfelseif stcResult.blnProceed>
				strDownloadURL = '#application.apphost#/views/csdownload.cfm?import_id=#intImpID#&service=#strService#';
				mainPopUp = window.parent.launchPopUp('', strDownloadURL);
			</cfif>
		</script>
	</cfoutput>
	
</body>
</html>