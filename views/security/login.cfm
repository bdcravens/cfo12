


<h1>You must login</h1>


<div class="hero-unit">
	<cfoutput>
	<a href='#buildUrl('security.twitter')#' class="btn btn-info btn-large">Twitter</a>
	<a href='#buildUrl('security.facebook')#' class="btn btn-primary btn-large">Facebook</a>
	<a href='#buildUrl('security.google')#' class="btn btn-inverse btn-large">Google</a>
	</cfoutput>
</div>




<cfscript>
/**
 * Returns the number of seconds since January 1, 1970, 00:00:00
 * 
 * @param DateTime      Date/time object you want converted to Epoch time. 
 * @return Returns a numeric value. 
 * @author Chris Mellon (mellan@mnr.org) 
 * @version 1, February 21, 2002 
 */
function GetEpochTime() {
    var datetime = 0;
    if (ArrayLen(Arguments) is 0) {
        datetime = Now();

    }
    else {
        if (IsDate(Arguments[1])) {
            datetime = Arguments[1];
        } else {
            return NULL;
        }
    }
    return DateDiff("s", "January 1 1970 00:00", datetime);
        
        
}
</cfscript>