<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type webskin security --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<doc:subsection title="Object Permissions">
	<doc:details properties="2">
		
		<doc:item type="header" v1="Name" v2="Permission" />
		
		<cfif arraylen(stObj.aObjectPermissions)>
			
			<cfloop from="1" to="#arraylen(stObj.aObjectPermissions)#" index="i">
				<doc:item type="simple" v1="#stObj.aObjectPermissions[i].name#" v2="#stObj.aObjectPermissions[i].shortcut#" />
			</cfloop>
		
		<cfelse>
			
			<doc:item type="simple" v1="None" v2="" />
			
		</cfif>
	
	</doc:details>
</doc:subsection>
			
<doc:subsection title="Type Permissions">
	<doc:details properties="3">
		
		<doc:item type="header" v1="Name" v2="Permission" v3="Roles" />
		
		<cfloop from="1" to="#arraylen(stObj.aTypePermissions)#" index="i">
			<doc:item type="simple" v1="#stObj.aTypePermissions[i].name#" v2="#stObj.aTypePermissions[i].shortcut#" v3="#stObj.aTypePermissions[i].roles#" />
		</cfloop>
	
	</doc:details>
</doc:subsection>

<cfsetting enablecfoutputonly="false" />