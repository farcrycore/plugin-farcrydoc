<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Tag XML --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif (stObj.typename neq "docTag" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getTag(url.ref) />
</cfif>

<doc:xml />

<cfoutput>
	<tag name="#stObj.name#" single="#stObj.single#" xmlstyle="#stObj.xmlstyle#" hint="#stObj.hint#">
		<description><![CDATA[ #stObj.description# ]]></description>
		<examples><![CDATA[ #stObj.examples# ]]></examples>
		<attributes><cfloop from="1" to="#arraylen(stObj.attributes)#" index="i">
			<attribute<cfloop collection="#stObj.attributes[i]#" item="thiskey"> #lcase(thiskey)#="#xmlformat(stObj.attributes[i][thiskey])#"</cfloop> /></cfloop>
		</attributes>
	</tag>
</cfoutput>

<cfsetting enablecfoutputonly="false" />