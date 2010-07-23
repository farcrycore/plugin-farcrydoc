<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Initialise this response an XML document --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.force" default="false" />

<cfif thistag.ExecutionMode eq "start" and not isdefined("application.config.docs.css") or application.config.docs.css>
	<skin:loadCSS id="farcrydoc" />
	<skin:loadJS id="jquery" />
	<skin:loadJS id="farcrydoc" />
</cfif>

<cfsetting enablecfoutputonly="false" />