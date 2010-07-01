<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Function documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.showundocumented" default="0" />

<cfset qComponents = getComponentQuery(url.showundocumented,url.refreshdocs) />

<cfquery dbtype="query" name="qIndex">
	select		path as [value], location as [group], package || '.' || component as label
	from		qComponents
	order by 	locationorder asc, package asc, component asc
</cfquery>

<doc:doctoc qIndex="#qIndex#" indexgroup="group">
	<skin:view typename="docComponent" stObject="#getComponent(url.ref)#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />