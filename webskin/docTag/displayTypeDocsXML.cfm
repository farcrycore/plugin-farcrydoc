<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Tag documentation --->
<!--- @@description: Reports on tags --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />'
<cfimport taglib="../../tags" prefix="doc" />

<cfparam name="url.refreshdocs" default="0" />

<!--- Always include undocumented stuff in the XML --->
<cfset qTags = getTagQuery(1,url.refreshdocs) />
<cfset stTags = getTagData(url.refreshdocs) />

<doc:xml />

<cfoutput><tags></cfoutput>
<cfoutput query="qTags" group="prefix">
	<library location="#qTags.location#" library="#qTags.library#" prefix="#qTags.prefix#" taglib="#stTags[qTags.location][qTags.library].taglib#"><cfoutput>
		<skin:view typename="docTag" stObject="#getTag('#qTags.location#.#qTags.library#.#qTags.tagname#')#" webskin="displayDocXML" /></cfoutput>
	</library>
</cfoutput>
<cfoutput></tags></cfoutput>

<cfsetting enablecfoutputonly="false" />