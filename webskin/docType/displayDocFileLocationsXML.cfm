<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: File and image locations --->

<cfset qMetadata = application.stCOAPI[stObj.name].qMetadata />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfoutput>
	<filelocations><cfloop from="1" to="#arraylen(stObj.aFileLocations)#" index="i">
		<location property="#stObj.aFileLocations[i].property#" type="#stObj.aFileLocations[i].type#" relativepath="#stObj.aFileLocations[i].relativepath#"<cfloop collection="#stObj.aFileLocations[i]#" item="thisattr"><cfif not listcontainsnocase('property,type,relativepath,fullpath',thisattr)> #lcase(thisattr)#="#xmlformat(stObj.aFileLocations[i][thisattr])#"</cfif></cfloop> /></cfloop>
	</filelocations></cfoutput>

<cfsetting enablecfoutputonly="false" />