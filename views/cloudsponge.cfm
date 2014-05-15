<cfsetting showdebugoutput="false" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" />
	<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
	<link href="/style/overrides.css" rel="stylesheet" type="text/css" />
	<script src="/js/cs.js" type="text/javascript" language="Javascript"></script>
</head>

<body>
<form name="frmContact" method="post">
	<input type="hidden" name="groupData" id="groupData" />
	
	<div id="divImportEntry" style="display:block; padding-left:17px;padding-top:5px;">
		<div class="roundedDiv">
			<cfloop list="#application.CloudSponge.getEnabledServices()#" index="service">
				<cfscript>
				if( service == 'yahoo' ) strImgTitle = 'Yahoo!';
				else if ( service == 'windowslive' ) strImgTitle = 'Windows Live(Outlook, Live, Hotmail)';
				else if ( service == 'gmail' ) strImgTitle = 'Gmail';
				else if ( service == 'aol' ) strImgTitle = 'AOL';
				else if ( service == 'plaxo' ) strImgTitle = 'Plaxo';
				else if ( service == 'outlook' ) strImgTitle = 'Outlook (Windows)';
				else if ( service == 'addressbook' ) strImgTitle = 'Addressbook (Mac)';
				else if ( service == 'facebook' ) strImgTitle = 'Facebook';
				else if ( service == 'linkedin' ) strImgTitle = 'LinkedIn';
			</cfscript>
				<cfoutput>
					<img src="#application.apphost#/images/#service#.png" border="0" onclick="javascript:launchPopUp('#service#','#application.apphost#/views/csauth.cfm?service=#service#');" title="#strImgTitle#" height="25px" />
				</cfoutput>
			</cfloop>
		</div>
	</div>
	<br /><br />
	<!--- this is where the data will be displayed after it is imported --->
	<div id="divAddrContentDtl" style="display:none;width:590px;">
		<div id="importedRecords">
		<table border="0" cellpadding="0" cellspacing="0" id="addrContentDtl" width="100%">
		  <tr>
		    <td>
		       <table class="tblHeader" border="0" cellpadding="4" cellspacing="1" width="100%">
		         <tr style="height:22px;">
		            <td class="smalltextbold">Email</td>
		            <td class="smalltextbold" width="30%">First Name</td>
		            <td class="smalltextbold" width="30%">Last Name</td>
		         </tr>
		       </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="background-color:rgb(204,204,204)">
		       <div id="divRecords" style="overflow-y:auto;overflow-x:hidden;">
		         <table border="0" cellpadding="4" cellspacing="1" id="tblRecords" width="100%" style="table-layout:fixed;">
		           <tr style="display:none;"></tr>
		         </table>  
		       </div>
		    </td>
		  </tr>
		</table>
		</div>
		<div>
			<span>No. of Records: </span><span id="importTotal" style="font-weight:bold;"></span>
		</div>
	<br />
	</div>

	<div id="popupWindow"></div>
	<div id="webAuth"></div>
</form>
</body>
</html>