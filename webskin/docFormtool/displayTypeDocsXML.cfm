<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Formtool documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.ref" default="" />

<!--- Always include undocumented stuff in the XML --->
<cfset qFormtools = getFormtoolQuery(1,url.refreshdocs) />
<cfset stFormtools = getFormtoolData(false) />

<doc:xml />

<cfoutput><formtools></cfoutput>

<cfloop query="qFormtools">
	<skin:view typename="docFormtool" stObject="#getFormtool(qFormtools.typename)#" webskin="displayDocXML" />
</cfloop>

<cfoutput></formtools></cfoutput>

<cfsetting enablecfoutputonly="false" />