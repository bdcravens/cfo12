component {

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

	public any function dologin(rc) {
		writeDump(session.objMonkehTweet);
	}

	public any function twitter(rc) {

		/*rc.objMonkehTweet = new com.coldfumonkeh.monkehTweet(
				consumerKey = 'NnSlMaRPP1rAc2che2iKg',
				consumerSecret = 'XtHyl4ltLQHhnDomo6lPaz3d35RQuMGv6Cm5OXOrjE',
				parseResults = true
			);	*/
		//writeDump(objMonkehTweet);abort;
		//auth = session.objMonkehTweet.getAuthorisation(callBackURL="http://cfo12.dev/#variables.fw.buildUrl('security.dologin')#");
		
		/*if (auth.success) {
			location(auth.authURL);
		}*/

	}

}