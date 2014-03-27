component output="false"  {
	
	this.name = 'CFCloudSponge';
	
	
	public any function onApplicationStart(){
		
		application.apphost = 'http://localhost:8000';
		
		// initialize this elsewhere
		var rp = GetDirectoryFromPath( GetCurrentTemplatePath() );
		var rootpath = Left( rp, Len( rp ) - 1 );
		var csConfig = XMLParse( rootpath & '\csconfig.xml' );
		application.CloudSponge = new Services.integrations.CloudSponge.CloudSpongeController(csConfig);

	}
	
}