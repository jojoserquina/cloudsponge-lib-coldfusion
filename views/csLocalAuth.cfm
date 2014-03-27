<cfsetting showdebugoutput="false" />
<cfif Not StructKeyExists(URL, "import_id")>
	Invalid request. Missing required information.
	<cfabort />
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache;no-store;max-age=0;must-revalidate" />
	<meta http-equiv="expires" content="Fri, 01 Jan 1990 00:00:00 GMT" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>User Authorization</title>
</head>

<body>
	<strong>Processing request...Do not close the window.</strong>
	<cfscript>
		objCloudSponge = application.CloudSponge;
		intImpID = URL.import_id;
		if ( objCloudSponge.getBranding() == 'partial' OR objCloudSponge.getBranding() == 'full' ){
			signedApplet = application.apphost & objCloudSponge.getLocalAppletURL();
		} else {
			signedApplet = objCloudSponge.getAppletURL() ;
		}
	</cfscript>
	
	<cfoutput>
	<!--[if !IE]> Firefox and others will use outer object -->
	<object classid="java:ContactsApplet" type="application/x-java-applet" archive="#signedApplet#" height="530" width="530">
	  <!-- Konqueror browser needs the following param -->
	  <param name="archive" value="#signedApplet#" />
	  <param name="importId" value="#intImpID#"/>
	  <param name="frameName" value="cs_container_frame"/>
	  <param name="csv" value="true" />
	  <!--<![endif]-->
	  <!-- MSIE (Microsoft Internet Explorer) will use inner object --> 
	  <object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" 
	  	codebase="http://java.sun.com/update/1.6.0/jinstall-6u24-windows-i586.cab" height="530" width="530"> 
	    <param name="code" value="ContactsApplet" />
	    <param name="archive" value="#signedApplet#" />
	    <param name="importId" value="#intImpID#"/>
	    <param name="csv" value="true" />
	    <param name="frameName" value="cs_container_frame"/>
	    <applet archive="#signedApplet#" code="ContactsApplet" height="530" width="530">
	      <param name="importId" value="#intImpID#"/>
	      <param name="frameName" value="cs_container_frame"/>
	      <param name="csv" value="true" />
	      <strong>
	        This browser does not have a Java Plug-in.<br/>
	        Get the latest Java Plug-in <a href="http://javadl.sun.com/webapps/download/AutoDL?BundleId=47376" onclick="startOver(); return true;">here</a>.
	      </strong>
	    </applet>
	  </object> 
	<!--[if !IE]> close outer object -->
	</object>
	<!--<![endif]-->
	</cfoutput>
</body>
</html>