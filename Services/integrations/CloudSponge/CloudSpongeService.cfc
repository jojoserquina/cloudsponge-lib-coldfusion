/**
 * Integration controller for CloudSponge - Service methods.
 * 
 * @author	SignUpGenius
 **/
component output="false" persistent="false" {

	
	// init function
    public any function init(){
    	return this;
    }
    
    
    
    /**
	 * csWebAuthorize - CloudSponge web-based authorization proxy service
	 * 
	 * @strAuthURL - Required. the authorization URL (e.g. https://api.cloudsponge.com/begin_import/user_consent)
	 * @strDomainKey - Required. the Domain_Key provided by CloudSponge
	 * @strDomainPassword - Required. the Domain_Password provided by CloudSponge
	 * @strService  - Required. the service to connect to (valid values: gmail, yahoo, windowslive, aol, plaxo)
	 * @strReturnFormat - return format (valid values: json or xml)
	 **/
	package struct function csWebAuthorize(	required string strAuthURL, 
											required string strDomainKey,
											required string strDomainPassword,
											required string strService,
											string strReturnFormat='json' ){
		
		var stcResult = {};
			stcResult.success = true;
			stcResult.httpResult = {};
		var AuthURL = Arguments.strAuthURL & '.' & Arguments.strReturnFormat;
		var httpService = new http(); 
		    httpService.setMethod("POST"); 
		    httpService.setCharset("utf-8"); 
		    httpService.setUrl( AuthURL ); 

			// add params
		    httpService.addParam(type="URL", name="service", value=Arguments.strService); 
		    httpService.addParam(type="URL", name="domain_key", value=Arguments.strDomainKey); 
		    httpService.addParam(type="URL", name="domain_password", value=Arguments.strDomainPassword); 
		    httpService.addParam(type="URL", name="echo", value=Arguments.strService); 
		    
		    if( Arguments.strService == 'addressbook' || Arguments.strService == 'outlook'){
				httpService.addParam(type="URL", name="csv", value="true"); 
			}
			
		// call service
		try{
		    var rawResult = httpService.send().getPrefix(); 
		    stcResult.httpResult = deserializeJSON(rawResult.FileContent.tostring());
		} catch( any e ){
			// do some logging here....
		}
		
	    // return result
    	return stcResult;
	}

	
	/**
	 * csWebAuthorize - CloudSponge local machine authorization proxy service
	 * 
	 * @strAuthURL - Required. the authorization URL (e.g. https://api.cloudsponge.com/begin_import/desktop_applet)
	 * @strDomainKey - Required. the Domain_Key provided by CloudSponge
	 * @strDomainPassword - Required. the Domain_Password provided by CloudSponge
	 * @strService  - Required. the service to connect to (outlook, addressbook)
	 * @strReturnFormat - return format (valid values: json or xml)
	 **/
	package struct function csLocalAuthorize( required string strAuthURL, 
											  required string strDomainKey,
											  required string strDomainPassword,
											  required string strService,
											  string strReturnFormat='json' ){
		
		var stcResult = {};
			stcResult.success = true;
			stcResult.httpResult = {};
		var AuthURL = Arguments.strAuthURL & '.' & Arguments.strReturnFormat;
		var httpService = new http(); 
		    httpService.setMethod("POST"); 
		    httpService.setCharset("utf-8"); 
		    httpService.setUrl( AuthURL ); 
			
			// add params
		    httpService.addParam(type="URL", name="service", value=Arguments.strService); 
		    httpService.addParam(type="URL", name="domain_key", value=Arguments.strDomainKey); 
		    httpService.addParam(type="URL", name="domain_password", value=Arguments.strDomainPassword); 
		    httpService.addParam(type="URL", name="echo", value=Arguments.strService); 
		    if( Arguments.strService == 'addressbook' ){
				httpService.addParam(type="URL", name="csv", value="true"); 
			}
		
		// call service
		try{
		    var rawResult = httpService.send().getPrefix(); 
		    stcResult.httpResult = deserializeJSON(rawResult.FileContent.tostring());
		} catch( any e ){
			// do some logging here....
		}
		
	    // return result
    	return stcResult;
	    
	}
	
	/**
	 * returns CloudSponge API authorization response
	 * @strAuthURL - Required. the authorization URL (e.g. https://api.cloudsponge.com/begin_import/desktop_applet)
	 * @strServiceToken - the response token from the requested service (typically from csBeginImport() request) - cgi.query_string
 	 * @strDomainKey - Required. the Domain_Key provided by CloudSponge
	 * @strDomainPassword - Required. the Domain_Password provided by CloudSponge
	 **/
	package any function csAuthorize( required string strAuthURL, 
									  required string strServiceToken, 
									  required string strDomainKey, 
									  required string strDomainPassword ){
		
		var stcResult = {};
			stcResult.success = true;
			stcResult.httpResult = {};
		var AuthURL = Arguments.strAuthURL & Arguments.strServiceToken;
		var httpService = new http(); 
		    httpService.setMethod("POST"); 
		    httpService.setCharset("utf-8"); 
		    httpService.setUrl( AuthURL ); 

			// add params
			httpService.addParam( type="cgi", Name="Content-type", value ="application/x-www-form-urlencoded", encoded="no"); 
		
		// call service
		try{
		    var rawResult = httpService.send().getPrefix(); 
		    stcResult.httpResult = rawResult;
		} catch( any e ){
			// do some logging here....
		}
		
	    // return result
    	return stcResult;
	}
	
	
	/**
	 * checkCSImport - proxy to CloudSponge API. Returns the status of a given import_ID
	 * 
	 * @strEventURL - Required. the event URL (e.g. https://api.cloudsponge.com/events)
	 * @strDomainKey - Required. the Domain_Key provided by CloudSponge
	 * @strDomainPassword - Required. the Domain_Password provided by CloudSponge
	 * @intImportID - The import_ID associated to the request
	 * @strReturnFormat - return format (valid values: json or xml)
	 **/
	package struct function checkCSImport( required string strEventURL, 
									       required string strDomainKey,
									       required string strDomainPassword,
									       required numeric intImportID,
									       string strReturnFormat='json'
									      ){
		
		var stcResult = {};
			stcResult.success = true;
			stcResult.httpResult = {};
		var strSvcEventURL = Arguments.strEventURL & '.' & Arguments.strReturnFormat & '/' & arguments.intImportID;
		var httpEventSvc = new http(); 
		    httpEventSvc.setMethod("GET"); 
		    httpEventSvc.setCharset("utf-8"); 
			httpEventSvc.setUrl( strSvcEventURL ); 
			// add params
			httpEventSvc.addParam(type="URL", name="import_id", value=arguments.intImportID); 
		    httpEventSvc.addParam(type="URL", name="domain_key", value=Arguments.strDomainKey); 
		    httpEventSvc.addParam(type="URL", name="domain_password", value=Arguments.strDomainPassword); 
		    httpEventSvc.addParam(type="URL", name="echo", value=Arguments.intImportID); 
		
		
		// call service
		try{
		    var events = httpEventSvc.send().getPrefix(); 
		    stcResult.httpResult = deserializeJSON(events.FileContent.tostring());
		} catch( any e ){
			// do some logging here....
			stcResult.success = false;
			stcResult.error = e.message;
		}
		
	    // return result
    	return stcResult;
    	
	}
    
    
    /**
	 * getCSData - proxy to CloudSponge API. Returns the status of a given import_ID
	 * 
	 * @strDownloadURL - Required. the event URL (e.g. https://api.cloudsponge.com/contacts)
	 * @strDomainKey - Required. the Domain_Key provided by CloudSponge
	 * @strDomainPassword - Required. the Domain_Password provided by CloudSponge
	 * @intImportID - The import_ID associated to the request
	 * @strReturnFormat - return format (valid values: json or xml)	 
	 **/
	package struct function getCSData( required string strDownloadURL, 
								       required string strDomainKey,
								       required string strDomainPassword,
								       required numeric intImportID,
								       string strReturnFormat='json' ){
	
		var stcResult = {};
			stcResult.success = true;
			stcResult.httpResult = {};
		var DownloadURL = Arguments.strDownloadURL & '.' & Arguments.strReturnFormat & '/' & Arguments.intImportID;
		var httpDownload = new http(); 
		    httpDownload.setMethod("GET"); 
		    httpDownload.setCharset("utf-8"); 
			httpDownload.setUrl( DownloadURL ); 
			// add params
			httpDownload.addParam(type="URL", name="import_id", value=arguments.intImportID); 
		    httpDownload.addParam(type="URL", name="domain_key", value=Arguments.strDomainKey); 
		    httpDownload.addParam(type="URL", name="domain_password", value=Arguments.strDomainPassword); 
		    httpDownload.addParam(type="URL", name="echo", value=Arguments.intImportID); 
		
		// call service
		try{
		    var contacts = httpDownload.send().getPrefix();	  
		    stcResult.httpResult = contacts.FileContent;
		} catch( any e ){
			// do some logging here....
		}
		
		// return result
		return stcResult;
		
	}
	
}