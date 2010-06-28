<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.showundocumented" default="0" />

<cfset qTypes = getTypeQuery(url.showundocumented,url.refreshdocs) />

<cfquery dbtype="query" name="qIndex">
	select		typename as [value], displayname as label
	from		qTypes
	order by 	displayname asc
</cfquery>

<doc:doctoc qIndex="#qIndex#">
	<skin:view typename="docType" stObject="#getType(url.ref)#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />