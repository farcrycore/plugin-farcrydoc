<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.ref" default="" />

<!--- Always include undocumented stuff in the XML --->
<cfset qRules = getRuleQuery(1,url.refreshdocs) />

<doc:xml />

<cfoutput><rules></cfoutput>

<cfloop query="qRules">
	<skin:view typename="docRule" stObject="#getRule(qRules.typename)#" webskin="displayDocXML" />
</cfloop>

<cfoutput></rules></cfoutput>

<cfsetting enablecfoutputonly="false" />