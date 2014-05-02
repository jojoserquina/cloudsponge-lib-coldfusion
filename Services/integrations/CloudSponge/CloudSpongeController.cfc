/**
 * Proxy integration for CloudSponge
 * 
 * @author	SignUpGenius
 **/
component output="false" {
	
	// CloudSponge property
	variables.csDK = '';
	variables.csDP = '';
	variables.csBaseURL = '';
	variables.csAuthURL = '';
	variables.csBeginURL = '';
	variables.csDesktopURL = '';
	variables.csDownloadURL = '';
	variables.csEventURL = '';
	variables.webBasedMail = '';
	variables.localBasedMail = '';
	variables.appletURL = '';
	
	// application specific settings
	variables.enabledServices = '';
	variables.excludedDomains = '';
	variables.includeNonPrimaryEmails = '';
	variables.validateEmail = '';
	variables.sugAppletURL = '';
	variables.branding = '';
	
	// constants
	variables.csJSON = '.json';
    variables.csXML = '.xml';
    
    // service obj
	variables.objCSService = new CloudSpongeService().init();
	
	/* 
	* init()
	* @csConfig		string containing xml configuration
	**/
    public any function init( required XML csConfig ){
    	
    	var conf = Arguments.csConfig;
    	var CloudSponge = conf.cs.XmlAttributes;
    	var app = conf.cs.app.XmlAttributes;
    	
    	// CloudSponge
    	variables.csDK = CloudSponge.domain_key;
		variables.csDP = CloudSponge.domain_password;
		variables.csBaseURL = CloudSponge.BaseURL;
		variables.csAuthURL = CloudSponge.AuthURL;
		variables.csBeginURL = CloudSponge.BeginURL;
		variables.csDesktopURL = CloudSponge.DesktopURL;
		variables.csDownloadURL = CloudSponge.DownloadURL;
		variables.csEventURL = CloudSponge.EventURL;
		variables.webBasedMail = CloudSponge.webBasedMail;
		variables.localBasedMail = CloudSponge.localMail;
		variables.appletURL = CloudSponge.appletURL;
		
		// application 
		variables.enabledServices = app.enabledServices;
		variables.excludedDomains = app.excludedDomains;
		variables.includeNonPrimaryEmails = app.includeNonPrimaryEmails;
		variables.validateEmail = app.ValidateEmail;
		variables.sugAppletURL = app.appletURL;
		variables.branding = app.branding;
		
    	return this;
    }

	/**
	 * returns application specific setting
	 **/
	public string function getEnabledServices(){
		return variables.enabledServices;
	}
	
	/**
	 * returns application specific setting
	 **/
	public string function getExcludedDomains(){
		return variables.excludedDomains;
	}
	
	/**
	 * returns application specific setting
	 **/
	public boolean function doIncludeNonPrimaryEmails(){
		return variables.includeNonPrimaryEmails;
	}
	
	/**
	 * returns application specific setting
	 **/
	public boolean function validateEmail(){
		return variables.validateEmail;
	}
	
	/**
	 * returns application specific setting
	 **/
	public string function getLocalAppletURL(){
		return variables.sugAppletURL;
	}
	
	/**
	 * returns application specific setting
	 **/
	public string function getBranding(){
		return variables.branding;
	}
	
	/**
	 * returns CloudSponge API domain key
	 **/
	public string function getCSDomainKey(){
		return variables.csDK;
	}

	/**
	 * returns CloudSponge API domain key
	 **/
	public string function getCSDomainPassword(){
		return variables.csDP;
	}

	/**
	 * returns CloudSponge API Base URL
	 **/
	public string function getCSBaseURL(){
		return variables.csBaseURL;
	}
	
	/**
	 * returns CloudSponge API Applet URL
	 **/
	public string function getAppletURL(){
		return variables.csBaseURL & variables.appletURL;
	}
		
	/**
	 * returns CloudSponge API Auth URL
	 **/
	public string function getCSAuthURL(){
		return variables.csBaseURL & variables.csAuthURL;
	}
	
	/**
	 * returns CloudSponge API Import and consent URL
	 **/
	public string function getCSImportConsentURL(){
		return variables.csBaseURL & variables.csBeginURL;
	}
	
	/**
	 * returns CloudSponge API LocalAuth URL
	 **/
	public string function getCSLocalAuth(){
		return variables.csBaseURL & variables.csDesktopURL;
	}
	
	/**
	 * returns CloudSponge API Event URL
	 **/
	public string function getCSEventURL(){
		return variables.csBaseURL & variables.csEventURL;
	}
	
	/**
	 * returns CloudSponge API Download URL
	 **/
	public string function getCSDownloadURL(){
		return variables.csBaseURL & variables.csDownloadURL;
	}
	
	/**
	 * returns CloudSponge supported web-based mail
	 **/
	public string function getWebSupportedMails(){
		return variables.webBasedMail;
	}
	
	/**
	 * returns CloudSponge supported local mail
	 **/
	public string function getLocalSupportedMails(){
		return variables.localBasedMail;
	}
	
	/**
	 * returns CloudSpong API authorization response
	 * @strService 	The service to connect to (valid values: gmail, yahoo, windowslive, aol, plaxo, outlook, addressbook)
	 **/
	public struct function csBeginImport(required string strService){
		
		var stcResult = {};
		
		// if importing using web-based services
		if( ListFindNoCase(variables.webBasedMail, Arguments.strService ) ){
			stcResult = objCSService.csWebAuthorize( strAuthURL=getCSImportConsentURL(), 
													 strDomainKey=getCSDomainKey(), 
													 strDomainPassword=getCSDomainPassword(), 
													 strService=Arguments.strService);
			// evaluate result
			if( stcResult.success )
				return fEvaluateBeginImport( stcResult.httpResult, Arguments.strService );
			else
				return {status='error', error='An unknown error occurred processing your request.'};
		}
		// if importing using local services
		else if( ListFindNoCase(variables.localBasedMail,Arguments.strService) ){
			stcResult = objCSService.csLocalAuthorize( strAuthURL=getCSLocalAuth(), 
													   strDomainKey=getCSDomainKey(), 
													   strDomainPassword=getCSDomainPassword(), 
													   strService=Arguments.strService);
			
			// evaluate result
			if( stcResult.success )
				return fEvaluateBeginImport( stcResult.httpResult, Arguments.strService );
			else
				return {status='error', error='An unknown error occurred while processing your request.'};
				
		}
		   
	}
	
	
	/**
	 * returns CloudSponge API authorization response
	 * @strServiceToken - the response token from the requested service (typically from csBeginImport() request) - cgi.query_string
	 **/
	public any function csAuthorize(required string strServiceToken){
		
		var stcResult = objCSService.csAuthorize( strAuthURL=getCSAuthURL(),
												  strServiceToken=Arguments.strServiceToken,
												  strDomainKey=getCSDomainKey(),
												  strDomainPassword=getCSDomainPassword() );
													
		// evaluate result
		if( stcResult.success )
			return stcResult.httpResult;
		else
			return;
		   
	}
	
	
	/**
	 * returns CloudSponge API event structure for a given import ID
	 * @intImportID		The import_ID associated to the request
	 **/
	public struct function checkCSImport( required numeric intImportID ){
				
		var stcReturn = {strStatus='',strEventType='',intEventValue='',blnKeepChecking='true',blnProceed='false',error=''};				    
		var stcResult = objCSService.checkCSImport( strEventURL=getCSEventURL(),
													strDomainKey=getCSDomainKey(),
													strDomainPassword=getCSDomainPassword(),
													intImportID=Arguments.intImportID );
													
		// evaluate result
		if( stcResult.success ){
			var events = stcResult.httpResult;
			for(event in events.events){
		 		// event result
		 		stcReturn.strStatus = event['status'];
		 		stcReturn.strEventType = event['event_type'];
		 		stcReturn.intEventValue = val(event['value']);
		 		
		 		if(stcReturn.strStatus == 'ERROR'){
		 			stcReturn.blnKeepChecking = false;
		 			stcReturn.error = event['description'];
		 			break;
		 		} else if( stcReturn.strEventType == "COMPLETE" && stcReturn.strStatus == "COMPLETED" && stcReturn.intEventValue == 0) {
		 			stcReturn.blnKeepChecking = false;
		 			stcReturn.blnProceed = true;
		 		}
		    }
		    
		} else {
			stcReturn.strStatus = 'ERROR';
			stcReturn.error = stcResult.error;
			stcReturn.blnKeepChecking = false;
		}
		
		// return result
		return stcReturn;
		
	}
	
	
	/**
	 * returns CloudSponge API download contacts
	 * @intImportID		The import_ID associated to the request
	 * @strReturnType	The type of data to return. Default is query. Valid values: query,json
	 **/
	public any function getCSData( required numeric intImportID, string strReturnType='query' ){
	
		var stcResult = objCSService.getCSData( strDownloadURL=getCSDownloadURL(),
												strDomainKey=getCSDomainKey(),
												strDomainPassword=getCSDomainPassword(),
												intImportID=Arguments.intImportID );
		
		var jsonResult = deserializeJSON(stcResult.httpResult.tostring());
		
		// evaluate result
		if( stcResult.success )
			if( Arguments.strReturnType == 'query' ){
				return formatResultToQuery( jsonData = stcResult.httpResult.tostring() );
			} else {
				// return json
				return jsonResult;
			}
		else
			return;
		
	}
	
	
	/**
	* helper function to convert json data into a query
	**/
	private query function formatResultToQuery( required string jsonData, boolean validateData="true" ){
	
		var qContacts = QueryNew("email,first_name,last_name","VarChar,VarChar,VarChar");
		var domainBlackList = variables.excludedDomains; 
		var blnIncludeAll = variables.includeNonPrimaryEmails; 
		var contacts = '';
        var rawJSONData = deserializeJSON(Arguments.jsonData);

        /* gotta make sure that contacts were imported before trying to parse it */        
        if( IsDefined("rawJSONData.contacts") )
		    contacts = rawJSONData.contacts;
		else
		    return qContacts; // no need to proceed. return an empty query, to prevent erroring out.
		
	    // extract contacts
	    for( contact in contacts ){
	    	
	    	var blnIsPrimary = false;
	    	/** 
	    	 * we only want the records with email addresses. we can potentially, also add additional validations
	    	 * e.g 
	    	 * 	1) Validate that email is valid ( blnValidateEmail = objCloudSponge.validateEmail() )
	    	 *	2) Exclude a blacklist of domains that are not allowed (@craigslist, @ebay, @quibids, etc.)
	    	 * 	3) Filter for group type emails (@yahoogroups.com, etc.)
	    	 * 	4) Potentially pull other data (phone, address, etc.)
	    	 **/
	    	if( IsDefined("contact.email") && ArrayLen(contact.email) > 0 ){
		    	try{
			    	// evaluate if there are multiple emails for the same user
			    	if( ArrayLen(contact.email) == 1 && !ListFindNoCase(domainBlackList,ListLast(contact.email[1].address,'@')) && IsValid('email',contact.email[1].address) ){
			    		// add new row and set cells
				    	QueryAddRow(qContacts,1);
				    	QuerySetCell(qContacts,'email',contact.email[1].address);
				    	QuerySetCell(qContacts,'first_name',contact.first_name);
				    	QuerySetCell(qContacts,'last_name',contact.last_name);
			    	} 
			    	else {
			    		for( var c=1; c <= ArrayLen(contact.email); c++ ){
							
							blnIsPrimary = false;
			    			strEmailDomain = ListLast(contact.email[c].address,'@');
			    			if( !ListFindNoCase(domainBlackList,strEmailDomain) && IsValid('email',contact.email[c].address) ){
				    			// gmail, aol, yahoo
				    			try { 
				    				 blnIsPrimary = contact.email[c].primary;
				    			} catch( any e ){ 
				    				// array primary doesn't exist 
				    			} 
				    			
				    			// windows live, outlook, hotmail
				    			try {
				    				strType = contact.email[c].type;
				    				blnIsPrimary = ( strType == 'preferred' || strType == 'Email 1' ) ? true : false;
				    			} catch( any e ){ 
				    				// array primary doesn't exist 
				    			} 
				    			
				    			// if email is primary OR to include all emails and email's domain is not part of the excluded list
				    			if( (blnIsPrimary || blnIncludeAll) && !ListFindNoCase(domainBlackList,ListLast(contact.email[c].address,'@')) ){
				    				QueryAddRow(qContacts,1);
				    				QuerySetCell(qContacts,'email',contact.email[c].address);
							    	QuerySetCell(qContacts,'first_name',contact.first_name);
							    	QuerySetCell(qContacts,'last_name',contact.last_name);
					    		}
			    			}
			    		}
			    		
			    	}
			    	
			    	
		    	} catch( any e ){
		    		// log error if so desired
		    		continue;
		    	}
		    	
	    	} // end array length
	    	
	    } // end for each	
	    
	    // retun query
	    return qContacts;
	}
	
	
	/**
	* private helper function
	**/
	private struct function fEvaluateBeginImport( required struct httpResult, required string strService ){
		
		var stcHttpResult = Arguments.httpResult;
		var stcResult = { intImportID = 0, 
						  strService = Arguments.strService, 
						  blnAuthenticate='false', 
						  strRedirectURI='', 
						  error='', 
						  status='' };
		
		// evaluate result
		if( StructKeyExists(stcHttpResult, 'URL') && len(stcHttpResult.URL) > 0 ){

			stcResult.intImportID = stcHttpResult.ID;
			stcResult.blnAuthenticate = true;
			
			if( ListFindNoCase(getWebSupportedMails(), Arguments.strService) )
	   			stcResult.strRedirectURI = stcHttpResult.URL; 
	   		else if( ListFindNoCase(getLocalSupportedMails(), Arguments.strService) )
	   			stcResult.strRedirectURI = 'applet';
		} 
		else if( StructKeyExists(stcHttpResult, "status") && stcHttpResult.status == 'error' ){
			stcResult.status = stcHttpResult.status;
			stcResult.error = "An error occurred while processing your request: " & stcHttpResult.error.message;
		}
		
		// return result
		return stcResult;
		
	}
	
	
}