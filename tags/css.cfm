<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Initialise this response an XML document --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.force" default="false" />

<cfif thistag.ExecutionMode eq "start" and not isdefined("application.config.docs.css") or application.config.docs.css>
	<cfif request.mode.ajax and (attributes.force or not structkeyexists(request,"outputeddoccss"))>
		<cfset request.outputeddoccss = true />
		<cfoutput><style type="text/css"><cfinclude template="../www/css/docs.css" /></style></cfoutput>
	<cfelseif not request.mode.ajax>
		<skin:htmlHead id="farcrydocs"><cfoutput><style type="text/css"><cfinclude template="../www/css/docs.css" /></style></cfoutput></skin:htmlHead>
	</cfif>
</cfif>

<cfsetting enablecfoutputonly="false" />