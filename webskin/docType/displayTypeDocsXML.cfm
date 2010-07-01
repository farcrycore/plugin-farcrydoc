<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />

<!--- Always include undocumented stuff in the XML --->
<cfset qTypes = getTypeQuery(1,url.refreshdocs) />

<doc:xml />

<cfoutput><types></cfoutput>

<cfloop query="qTypes">
	<skin:view typename="docType" stObject="#getType(qTypes.typename)#" webskin="displayDocXML" />
</cfloop>

<cfoutput></types></cfoutput>

<cfsetting enablecfoutputonly="false" />