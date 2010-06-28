<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Function documentation --->
<!--- @@description: Reports on tags --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />

<cfset qComponents = getComponentQuery(url.refreshdocs) />
<cfset stComponents = getComponentData(url.refreshdocs) />

<doc:xml />

<cfquery dbtype="query" name="qIndex">
	select	location || '.' || package as packageref,component
	from	qComponents
</cfquery>

<cfoutput><components></cfoutput>
<cfoutput query="qIndex" group="packageref">
	<package location="#listfirst(qIndex.packageref,'.')#" name="#listlast(qIndex.packageref,'.')#"><cfoutput>
		<skin:view typename="docComponent" stObject="#getComponent('#qIndex.packageref#.#qIndex.component#')#" webskin="displayDocXML" /></cfoutput>
	</package>
</cfoutput>
<cfoutput></components></cfoutput>

<cfsetting enablecfoutputonly="false" />