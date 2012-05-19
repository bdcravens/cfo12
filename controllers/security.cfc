component {

	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public any function checkAuthorization(rc) {
		if (!session.loggedIn) {
			variables.fw.redirect('security.login');
		}
	}

	public any function logout(rc) {
		structClear(session);
		variables.fw.redirect('');
	}


	public any function facebook(rc) {
		//writedump(cgi);abort;

		session.authMethod = "facebook";
		if (!session.loggedin) {
			location('https://www.facebook.com/dialog/oauth?client_id=#rc.facebook.key#&redirect_uri=#urlEncodedFormat('#getServer()#/index.cfm?action=security.dofacebooklogin')#&state=#session.sessionid#');
		}
	}


	public any function dofacebooklogin(rc) {
		
		if (isDefined('rc.code')) {

			fbAuth = getFBauth(rc.code,rc.facebook.key,rc.facebook.secret);


			authVar = listFirst(fbAuth,"&");
			session.token = listLast(authVar,"=");
			

			userDetails = getFBuser(session.token);

			userStruct = deserializeJSON(userDetails);

			session.username = userStruct.name;

			session.loggedin = true;
			
			variables.fw.redirect('');

			//authResult = deserializeJSON(fbAuth); // error returned as JSON - handle error here
			
			

		}
		if (isDefined('rc.error')) {

			// handle error (error reported by Facebook, not a CF error)

		}
	}

	public any function dologingoogle(rc) {

		if (isDefined('rc.access_token')) {
			auth = deserializeJson(validateGoogleToken(rc.access_token));

			if (auth.audience==rc.google.key) {
				userDetails = deserializeJson(getGoogleProfile(rc.access_token,rc.google.key,rc.google.secret));
				session.authDetails.img = userDetails.picture;
				session.username = userDetails.given_name & ' ' & userDetails.family_name;
				session.loggedIn = true;
				variables.fw.redirect('');
			}
		}

	}


	public any function dologintwitter(rc) {

		accessToken = session.objMonkehTweet.getAccessToken(
				requestToken = session.authDetails.token,
				requestSecret = session.authDetails.token_secret,
				verifier = rc.oauth_verifier
			);

		session.authDetails.userid = accessToken.user_id;

		session.loggedin = true;
		session.token = accessToken.token;
		session.token_secret = accessToken.token_secret; 

		userDetails = session.objMonkehTweet.getUserDetails(
				user_id = accessToken.user_id,
				format="json"
			);
		session.authDetails.img = userDetails.profile_image_url;
		session.username = userDetails.name;
		variables.fw.redirect('');
	}



	public any function twitter(rc) {

		session.objMonkehTweet = new com.coldfumonkeh.monkehTweet(
				consumerKey = rc.twitter.key,
				consumerSecret = rc.twitter.secret,
				parseResults = true
			);	

		auth = session.objMonkehTweet.getAuthorisation(callBackURL="#getServer()##variables.fw.buildUrl('security.dologintwitter')#");
		
		if (auth.success) {
			session.authDetails.token = auth.token;
			session.authDetails.token_secret = auth.token_secret;
			session.authDetails.authURL = auth.authURL;
			location(auth.authURL);
		}

	}

	


	public any function google(rc) {
		response_type = "token";
		client_id = rc.google.key;
		redirect_uri = "#getServer()#/index.cfm?action=security.dologingoogle";
		
		scope = "https://www.googleapis.com/auth/userinfo.profile";

		if (!session.loggedin) {
			location('https://accounts.google.com/o/oauth2/auth?response_type=#response_type#&client_id=#client_id#&redirect_uri=#urlEncodedFormat(redirect_uri)#&scope=#urlEncodedFormat(scope)#');

		}

	}


	function getFBauth(fbCode, key, secret) {
		http url="https://graph.facebook.com/oauth/access_token?client_id=#arguments.key#&redirect_uri=#urlEncodedFormat('#getServer()#/index.cfm?action=security.dofacebooklogin')#&client_secret=#arguments.secret#&code=#urlEncodedFormat(arguments.fbCode)#";
		return cfhttp.fileContent;		
	}

	function getFBuser(token) {
		http url="https://graph.facebook.com/me?access_token=#arguments.token#";
		return cfhttp.fileContent;
	}

	function validateGoogleToken(access_token) {
		http url="https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#arguments.access_token#";
		return cfhttp.fileContent;
	}

	function getGoogleProfile(access_token) {
		http url="https://www.googleapis.com/oauth2/v1/userinfo?access_token=#arguments.access_token#";
		return cfhttp.fileContent;
	}

	function getServer(){
		if (left(cgi.server_protocol,5)=='HTTPS') {
			protocol = 'https';
			port = (cgi.server_port != 443) ? ':#cgi.server_port#' : '';
		} else {
			protocol = 'http';
			port = (cgi.server_port != 80) ? ':#cgi.server_port#' : '';
		}
		return "#protocol#://#cgi.server_name##port#";
	}
}