<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.showundocumented" default="0" />

<cfset qRules = getRuleQuery(url.showundocumented,url.refreshdocs) />

<cfquery dbtype="query" name="qIndex">
	select		typename as [value], displayname as label
	from		qRules
	order by 	displayname asc
</cfquery>

<doc:doctoc qIndex="#qIndex#">
	<skin:view typename="docRule" stObject="#getRule(url.ref)#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />