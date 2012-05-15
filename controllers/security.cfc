<cfcomponent>

	<cfscript>

	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public any function checkAuthorization(rc) {
		if (!session.loggedIn) {
			//writeOutput('not allowed'); abort;
			variables.fw.redirect('security.login');
		}
	}

	public any function logout(rc) {
		/*session.loggedin = false;
		session.token = "";
		session.username = "";
		session.authDetails = structNew();*/
		structClear(session);
		variables.fw.redirect('');
	}


	public any function facebook(rc) {
		//writedump(cgi);abort;

		session.authMethod = "facebook";
		if (!session.loggedin) {
			location('https://www.facebook.com/dialog/oauth?client_id=459365380744568&redirect_uri=#urlEncodedFormat('http://cfo12.billycravens.com/index.cfm?action=security.dofacebooklogin')#&state=#session.sessionid#');
		}
	}


	public any function dofacebooklogin(rc) {
		//writeDump(session.objMonkehTweet);

		//writeDump(rc);abort;
		if (isDefined('rc.code')) {

			fbAuth = getFBauth(rc.code);


			authVar = listFirst(fbAuth,"&");
			session.token = listLast(authVar,"=");
			

			userDetails = getFBuser(session.token);
			//writeDump(userDetails);abort;

			userStruct = deserializeJSON(userDetails);

			session.username = userStruct.name;

			session.loggedin = true;
			
			variables.fw.redirect('');

			//writeDump(fbAuth);abort;
			
				//authResult = deserializeJSON(fbAuth); // error returned as JSON - handle error here
			
			//writeDump(authResult);abort;

		}
		if (isDefined('rc.error')) {

			// handle error

		}
	}

	public any function dologingoogle(rc) {
		//writedump(request);abort;

		if (isDefined('rc.access_token')) {
			auth = deserializeJson(validateGoogleToken(rc.access_token));
			//writeDump(deserializeJson(auth));abort;
			if (auth.audience=="277638459153.apps.googleusercontent.com") {
				userDetails = deserializeJson(getGoogleProfile(rc.access_token));
				//writeDump(userDetails);
				session.authDetails.img = userDetails.picture;
				session.username = userDetails.given_name & ' ' & userDetails.family_name;
				session.loggedIn = true;
				variables.fw.redirect('');
			}
		}

	}


	public any function dologintwitter(rc) {
		//writeDump(rc);abort;

		accessToken = session.objMonkehTweet.getAccessToken(
				requestToken = session.authDetails.token,
				requestSecret = session.authDetails.token_secret,
				verifier = rc.oauth_verifier
			);
		//writeDump(accessToken);abort;
		//session.username = accessToken.screen_name;
		session.authDetails.userid = accessToken.user_id;

		session.loggedin = true;
		session.token = accessToken.token;
		session.token_secret = accessToken.token_secret; 
		//writeDump(accessToken);abort;

		userDetails = session.objMonkehTweet.getUserDetails(
				user_id = accessToken.user_id,
				format="json"
			);
		session.authDetails.img = userDetails.profile_image_url;
		session.username = userDetails.name;
		//writeDump(userDetails);abort;
		variables.fw.redirect('');
	}



	public any function twitter(rc) {

		session.objMonkehTweet = new com.coldfumonkeh.monkehTweet(
				consumerKey = 'NnSlMaRPP1rAc2che2iKg',
				consumerSecret = 'XtHyl4ltLQHhnDomo6lPaz3d35RQuMGv6Cm5OXOrjE',
				parseResults = true
			);	
		//writeDump(objMonkehTweet);abort;
		auth = session.objMonkehTweet.getAuthorisation(callBackURL="http://cfo12.billycravens.com#variables.fw.buildUrl('security.dologintwitter')#");
		//writeDump(auth);abort;
		if (auth.success) {
			session.authDetails.token = auth.token;
			session.authDetails.token_secret = auth.token_secret;
			session.authDetails.authURL = auth.authURL;
			location(auth.authURL);
		}

	}

	


	public any function google(rc) {
		response_type = "token";
		client_id = "277638459153.apps.googleusercontent.com";
		redirect_uri = "http://cfo12.billycravens.com/index.cfm?action=security.dologingoogle";
		//redirect_uri = "http://cfo12.billycravens.com/oauth2callback";
		
		scope = "https://www.googleapis.com/auth/userinfo.profile";

		if (!session.loggedin) {
			location('https://accounts.google.com/o/oauth2/auth?response_type=#response_type#&client_id=#client_id#&redirect_uri=#urlEncodedFormat(redirect_uri)#&scope=#urlEncodedFormat(scope)#');

		}

	}
</cfscript>


<cffunction name="getFBauth">
	<cfargument name="fbCode">

	


	<cfhttp url="https://graph.facebook.com/oauth/access_token?client_id=459365380744568&redirect_uri=#urlEncodedFormat('http://cfo12.billycravens.com/index.cfm?action=security.dofacebooklogin')#&client_secret=f5e53d26acb5fdb54a9a37e78baaf8fd&code=#urlEncodedFormat(arguments.fbCode)#">
	</cfhttp>

	<cfreturn cfhttp.fileContent>

</cffunction>


<cffunction name="getFBuser">

	<cfargument name="token">

	<cfhttp url="https://graph.facebook.com/me?access_token=#arguments.token#"></cfhttp>

	<cfreturn cfhttp.fileContent>

</cffunction>


<cffunction name="validateGoogleToken">


	<cfargument name="access_token">

	<cfhttp url="https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#arguments.access_token#"></cfhttp>

	<cfreturn cfhttp.fileContent>


</cffunction>

<cffunction name="getGoogleProfile">

	<cfargument name="access_token">


	<cfhttp url="https://www.googleapis.com/oauth2/v1/userinfo?access_token=#arguments.access_token#"></cfhttp>

	<cfreturn cfhttp.fileContent>

</cffunction>



</cfcomponent>