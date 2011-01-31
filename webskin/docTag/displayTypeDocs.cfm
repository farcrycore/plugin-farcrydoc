<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Tag documentation --->
<!--- @@description: Reports on tags --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfparam name="url.refreshdocs" default="0" />
<cfparam name="url.showundocumented" default="0" />

<cfset qTags = getTagQuery(url.showundocumented,url.refreshdocs) />
<cfset stTags = getTagData(url.refreshdocs) />

<cfquery dbtype="query" name="qIndex">
	select	location || '-' || library as [group], location || '.' || library || '.' || tagname as [value], tagname as label
	from	qTags
</cfquery>

<doc:doctoc qIndex="#qIndex#" indexgroup="group">
	<skin:view typename="docTag" stObject="#getTag(url.ref)#" webskin="displayDoc" />
</doc:doctoc>

<cfsetting enablecfoutputonly="false" />