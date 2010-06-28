<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Joins --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfoutput>
	<joins>
		<to><cfloop from="1" to="#arraylen(stObj.aJoinTo)#" index="i">
			<join contenttype="#stObj.aJoinTo[i].contenttype#" property="#stObj.aJoinTo[i].property#" type="#stObj.aJoinTo[i].type#" /></cfloop>
		</to>
		<from><cfloop from="1" to="#arraylen(stObj.aJoinFrom)#" index="i">
			<join contenttype="#stObj.aJoinFrom[i].contenttype#" property="#stObj.aJoinFrom[i].property#" type="#stObj.aJoinFrom[i].type#" /></cfloop>
		</from>
	</joins></cfoutput>

<cfsetting enablecfoutputonly="false" />