<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Formtool documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.showundocumented" default="0" />

<cfset qFormtools = getFormtoolQuery(url.showundocumented,url.refreshdocs) />
<cfset stFormtools = getFormtoolData(false) />

<cfquery dbtype="query" name="qIndex">
	select		typename as [value], displayname as label
	from		qFormtools
	order by 	displayname asc
</cfquery>

<doc:doctoc qIndex="#qIndex#">
	<skin:view typename="docFormtool" stObject="#getFormtool(url.ref)#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />