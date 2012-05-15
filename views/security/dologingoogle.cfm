<cfif not isDefined('rc.access_token')>



<script>
//alert(document.location.hash
var s = document.location.hash;
while(s.charAt(0) == '#')
    s = s.substr(1);
location.href='http://cfo12.billycravens.com/index.cfm?action=security.dologingoogle&'+s;
</script>

<cfelse>

	<!--- <cfdump var="#rc#"> --->
</cfif>