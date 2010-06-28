<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type webskin summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfoutput>
	<webskins><cfloop from="1" to="#arraylen(stObj.aWebskins)#" index="i"><cfset stObj.aWebskins[i].file = stObj.aWebskins[i].name />
		<webskin<cfloop collection="#stObj.aWebskins[i]#" item="thisattr"><cfif listcontainsnocase("author,bGeneric,cachebyform,cachebyroles,cachebyurl,cachevars,cachestatus,cachetimeout,description,displayname,location,roles,file",thisattr)> #lcase(thisattr)#="#xmlformat(stObj.aWebskins[i][thisattr])#"</cfif></cfloop> /></cfloop>
	</webskins></cfoutput>

<cfsetting enablecfoutputonly="false" />