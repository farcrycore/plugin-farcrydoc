<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Function documentation --->
<!--- @@description: Reports on tags --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />

<cfset qComponents = getComponentQuery(url.refreshdocs) />
<cfset stComponents = getComponentData(url.refreshdocs) />

<cfquery dbtype="query" name="qIndex">
	select	location || '.' || package || '.' || component as [value], location as [group], package || '.' || component as label
	from	qComponents
</cfquery>

<doc:doctoc qIndex="#qIndex#" indexgroup="group">
	<cfset stComponent = getComponent(url.ref) />
	<skin:view typename="docComponent" stObject="#stComponent#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />