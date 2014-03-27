<cfsetting showdebugoutput="false" />
<cfif Not StructKeyExists(URL, "import_id") AND Not StructKeyExists(URL, "service")>
	Invalid request. Missing required information.
	<cfabort />
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<title>Importing Contacts</title>
	<meta http-equiv="cache-control" content="no-cache;no-store;max-age=0;must-revalidate" />
	<meta http-equiv="expires" content="Fri, 01 Jan 1990 00:00:00 GMT" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" />
	<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
	<link href="/style/overrides.css" rel="stylesheet" type="text/css" />
	<script src="/js/cs.js" type="text/javascript" language="Javascript"></script>
</head>
<body>
	<h3>Email Import</h3>
	<cfscript> 
		objCloudSponge = application.CloudSponge;
		
		if( StructKeyExists(URL, "import_id") && val(URL.import_id) > 0 ){
	    	// monitor the import
	    	intImpID = URL.import_id;
	    	qContacts = objCloudSponge.getCSData(intImportID=intImpID,strReturnType='query');
	    } 
	</cfscript>
	
	<!--- if records were returned, draw the rest of the screen --->
	<cfif IsDefined("qContacts.RecordCount") and qContacts.RecordCount GT 0>
		<cfform name="contactlist" id="contactlist" action="#cgi.SCRIPT_NAME#">
		<div style="display:block;width:98%;">
			<div class="downloadDiv">
			<table border="0" cellpadding="0" cellspacing="0" id="addrContentDtl" width="100%">
			  <tr>
			    <td>
			       <table class="tblHeader" border="0" cellpadding="4" cellspacing="1" width="100%">
			         <tr>
				        <td class="smalltextbold" width="15%" align="center"><cfinput type="button" value="ALL" name="btnChkUnchk" id="btnChkUnchk" onclick="javascript:checkAll(this.value)" class="button" /></th>
			            <td class="smalltextbold">Email</th>
			            <td class="smalltextbold" width="25%">First Name</th>
			            <td class="smalltextbold" width="25%">Last Name</th>
			         </tr>
			       </table>
			    </td>
			  </tr>
			  <tr>
			    <td style="background-color:rgb(204,204,204)">
			    	<cfset height = (qContacts.RecordCount GTE 10) ? "300px" : "auto"/>
			        <div id="divRecords" style="overflow-y:auto;overflow-x:hidden;height:<cfoutput>#height#</cfoutput>;">
			         <table border="0" cellpadding="4" cellspacing="1" id="tblRecords" width="100%" style="table-layout:fixed;">
			         <cfloop query="qContacts">
					 	<tr>
					 		<td class="smalltext smallText2" width="15%" align="center"><input type="checkbox" value="<cfoutput>#email#||#first_name#||#last_name#</cfoutput>" name="<cfoutput>#email#</cfoutput>" /></td>
					 		<td class="smalltext smallText2"><cfoutput>#email#</cfoutput></td>
					 		<td class="smalltext smallText2" width="25%"><cfoutput>#first_name#</cfoutput></td>
					 		<td class="smalltext smallText2" width="25%"><cfoutput>#last_name#</cfoutput></td>
						</tr>
					 </cfloop>
			         </table>  
			       </div>
			    </td>
			  </tr>
			</table>
			</div>
		</div>
		<br />
		</cfform>
	<cfelse>
		<hr />
		<span>No records were returned.</span><br />
	</cfif>
	
	<script type="text/javascript">
		newPop = window.open('', 'newPopWindow');
		if (undefined != newPop) {
			newPop.close();
		}
	</script>
	
</body>
</html>