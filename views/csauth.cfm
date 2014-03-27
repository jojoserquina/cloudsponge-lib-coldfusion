<cfsetting showdebugoutput="false" />
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
	    objCloudSponge = application.CloudSponge;
		blnAuthenticate = false;
		strRedirectURI = '';
		intImpID = '';
		
	    if( StructKeyExists(URL, "Service") && URL.Service != '' ){
		   	strService = URL.Service;
		   	stcResult = objCloudSponge.csBeginImport( strService=strService );

			if( structKeyExists(stcResult,'status') && stcResult.status == 'error' ){
				writeoutput( stcResul.error );
				abort;
			} 
			else {
				blnAuthenticate = stcResult.blnAuthenticate;
				intImpID = stcResult.intImportID;
				strRedirectURI = stcResult.strRedirectURI;
				// override for applet type import (addressbook,outlook)
				if( ListFindNoCase(objCloudSponge.getLocalSupportedMails(), URL.Service) )
	   				strRedirectURI = '#application.apphost#/views/csLocalAuth.cfm?import_id=#intImpID#&service=#strService#';
			}
		   	 
	    } 
	    
	    // gmail, windows live, aol
	    else if( StructKeyExists(URL, "state") && FindNoCase('import_id',URL.state) ){
	   		// pass authentication from service
	   		authResult = objCloudSponge.csAuthorize(strServiceToken=cgi.QUERY_STRING);
	   		blnAuthenticate = false;
	   	} 
	   	
	   	// yahoo
	   	else if( StructKeyExists(URL, "oauth_token") && len(URL.oauth_token) > 0 ){
	   		// pass authentication from service
	   		authResult = objCloudSponge.csAuthorize(strServiceToken=cgi.QUERY_STRING);
	   		blnAuthenticate = false;
	   	}
	   	
	   	if( IsDefined("authResult.ErrorDetail") && len(authResult.ErrorDetail) > 0 ){
	    	writeoutput("Error: " & authResult.ErrorDetail);
	    	abort;	
	    }
	</cfscript>
	
	<cfoutput>
	<cfif blnAuthenticate>
		<script>
			// user authorization process
			strAuthURL = '#strRedirectURI#';
			newpopup = window.parent.standardPopup(strAuthURL, 540, 540);
	
			// while the proper user authorization is being process, redirect the page to the import status screen
			strImportURL = '#application.apphost#/views/csimport.cfm?import_id=#intImpID#&service=#strService#';
			mainPopUp = setTimeout("window.parent.launchPopUp('', strImportURL)",5000);
	
			// autoclose the auth popup window
			if (focus)
				newpopup.focus(); 
			else 
				window.focus(); 
			
		</script>

	<cfelseif Not blnAuthenticate>
		<script type="text/javascript"> 
			try { 
				window.open('','_parent',''); 
			} catch(e) {} 
			
			try { 
				window.opener=top; 
			} catch(e) {} 
			
			try { 
				this.close(); 
			} catch(e) {} 
		</script>
	</cfif>
	</cfoutput>
	
</body>
</html>