<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property details --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfoutput>
	<properties><cfloop from="1" to="#arraylen(stObj.aProperties)#" index="i">
		<property<cfloop collection="#stObj.aProperties[i]#" item="thisattr"><cfif (left(thisattr,2) eq "ft" or listcontainsnocase("name,type,default,required,blabel,bdeprecated",thisattr)) and len(stObj.aProperties[i][thisattr])> #lcase(thisattr)#="#xmlformat(stObj.aProperties[i][thisattr])#"</cfif></cfloop> /></cfloop>
	</properties></cfoutput>

<cfsetting enablecfoutputonly="false" />