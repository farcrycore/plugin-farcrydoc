<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Function documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />

<!--- Always include undocumented stuff in the XML --->
<cfset qComponents = getComponentQuery(1,url.refreshdocs) />

<doc:xml />

<cfoutput><components></cfoutput>
<cfoutput query="qComponents" group="packageref">
	<package location="#qComponents.location#" name="#qComponents.package#"><cfoutput>
		<skin:view typename="docComponent" stObject="#getComponent(qComponents.path)#" webskin="displayDocXML" /></cfoutput>
	</package>
</cfoutput>
<cfoutput></components></cfoutput>

<cfsetting enablecfoutputonly="false" />