<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Joins --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfif arraylen(stObj.aJoinTo) or arraylen(stObj.aJoinFrom)>
	<doc:subsection title="Joins">
		<doc:details properties="3">
			<doc:item type="title" v1="This type joins to:" />
			<doc:item type="header" v1="Content Type" v2="Via Property" v3="Property Type" />
			
			<cfif arraylen(stObj.aJoinTo)>
				<cfloop from="1" to="#arraylen(stObj.aJoinTo)#" index="i">
					<doc:item type="simple" v1="#stObj.aJoinTo[i].contenttype#" v2="#stObj.aJoinTo[i].property#" v3="#stObj.aJoinTo[i].type#" />
				</cfloop>
			<cfelse>
				<doc:item type="simple" v1="None" v2="" v3="" />
			</cfif>
			
			<doc:item type="title" v1="This type is joined from:" />
			<doc:item type="header" v1="Content Type" v2="Via Property" v3="Property Type" />
			
			<cfif arraylen(stObj.aJoinFrom)>
				<cfloop from="1" to="#arraylen(stObj.aJoinFrom)#" index="i">
					<doc:item type="simple" v1="#stObj.aJoinFrom[i].contenttype#" v2="#stObj.aJoinFrom[i].property#" v3="#stObj.aJoinFrom[i].type#" />
				</cfloop>
			<cfelse>
				<doc:item type="simple" v1="None" v2="" v3="" />
			</cfif>
			
		</doc:details>
	</doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />