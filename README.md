# CloudSponge ColdFusion Library
ColdFusion library for CloudSponge integration. This implementation is to demostrate how to interface with the CloudSponge API. Use, modify, as you see fit.

# Requirements
* ColdFusion 9+

# Installation:
* Unzip files to your web directory
* Review and update csconfig.xml with your domain key and password 

# Files:
* csconfig.xml - CloudSponge configuration file. Update file with your domain key and pass code. The rest of the settings are self-explanatory.
* Services/Integration/CloudSponge/CloudSpongeController.cfc - controller component that interfaces with the services.
* Services/Integration/CloudSponge/CloudSpongeService.cfc - component that interfaces with CloudSponge
* views/CloudSponge.cfm - Landing page
* views/csauth.cfm - Initiate of 'begin_import'. Also as a return_url when establishing user consumer credentials in CloudSponge
* views/csLocalAuth.cfm - Used when local applet or partial/full rebranding of the java applet
* views/csimport.cfm - Used for monitoring the status of the import 
* views/csDownload.cfm - Download page

