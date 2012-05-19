component extends="org.corfield.framework" {
	
	/*
		This is provided for illustration only - you should not use this in
		a real program! Only override the defaults you need to change!
	variables.framework = {
		// the name of the URL variable:
		action = 'action',
		// whether or not to use subsystems:
		usingSubsystems = false,
		// default subsystem name (if usingSubsystems == true):
		defaultSubsystem = 'home',
		// default section name:
		defaultSection = 'main',
		// default item name:
		defaultItem = 'default',
		// if using subsystems, the delimiter between the subsystem and the action:
		subsystemDelimiter = ':',
		// if using subsystems, the name of the subsystem containing the global layouts:
		siteWideLayoutSubsystem = 'common',
		// the default when no action is specified:
		home = defaultSubsystem & ':' & defaultSection & '.' & defaultItem,
		-- or --
		home = defaultSection & '.' & defaultItem,
		// the default error action when an exception is thrown:
		error = defaultSubsystem & ':' & defaultSection & '.error',
		-- or --
		error = defaultSection & '.error',
		// the URL variable to reload the controller/service cache:
		reload = 'reload',
		// the value of the reload variable that authorizes the reload:
		password = 'true',
		// debugging flag to force reload of cache on each request:
		reloadApplicationOnEveryRequest = false,
		// whether to force generation of SES URLs:
		generateSES = false,
		// whether to omit /index.cfm in SES URLs:
		SESOmitIndex = false,
		// location used to find layouts / views:
		base = getDirectoryFromPath( CGI.SCRIPT_NAME ),
		// either CGI.SCRIPT_NAME or a specified base URL path:
		baseURL = 'useCgiScriptName',
		// location used to find controllers / services:
		// cfcbase = essentially base with / replaced by .
		// whether FW/1 implicit service call should be suppressed:
		suppressImplicitService = true,
		// list of file extensions that FW/1 should not handle:
		unhandledExtensions = 'cfc',
		// list of (partial) paths that FW/1 should not handle:
		unhandledPaths = '/flex2gateway',
		// flash scope magic key and how many concurrent requests are supported:
		preserveKeyURLKey = 'fw1pk',
		maxNumContextsPreserved = 10,
		// set this to true to cache the results of fileExists for performance:
		cacheFileExists = false,
		// change this if you need multiple FW/1 applications in a single CFML application:
		applicationKey = 'org.corfield.framework'
	};
	*/

	variables.framework = {
		reloadApplicationOnEveryRequest = true
	};

	this.sessionManagement = true;
	
	function setupRequest() {
		
		rc.twitter = {
			key = "consumer_key_as_provided_by_twitter",
			secret = "consumer_secret_as_provided_by_twitter"
		};
		rc.facebook = {
			key = "app_id_as_provided_by_facebook",
			secret = "app_secret_as_provided_by_facebook"
		};
		rc.google = {
			key = "consumer_key_as_provided_by_twitter",
			secret = "consumer_secret_as_provided_by_twitter"
		};
		




		if (!isDefined('session.loggedin')) {
			session.loggedin=false;
		}
		if (!isDefined('session.authMethod')) {
			session.authMethod = '';
		}
		securityBypass="security,test";
		if (!listFind(securityBypass,getSection())) {
			controller('security.checkAuthorization');
		}

	}

	function setupApplication() {


	}

	
}