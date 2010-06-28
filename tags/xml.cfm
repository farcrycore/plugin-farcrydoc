<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Initialise this response an XML document --->

<cfif thistag.ExecutionMode eq "start" and not isdefined("request.xmlheader")>
	<cfcontent reset="true" type="text/xml" />
	<cfoutput><?xml version="1.0" encoding="ISO-8859-1"?></cfoutput>
	<cfset request.xmlheader = true />
	<cfset request.mode.ajax = true />
</cfif>

<cfsetting enablecfoutputonly="false" />