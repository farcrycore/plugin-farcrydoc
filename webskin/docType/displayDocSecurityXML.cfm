<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type webskin security --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfoutput>
	<security>
		<objectpermissions><cfloop from="1" to="#arraylen(stObj.aObjectPermissions)#" index="i">
			<permission name="#stObj.aObjectPermissions[i].name#" shortcut="#stObj.aObjectPermissions[i].shortcut#" /></cfloop>
		</objectpermissions>
		<typepermissions><cfloop from="1" to="#arraylen(stObj.aTypePermissions)#" index="i">
			<permission name="#stObj.aTypePermissions[i].name#" shortcut="#stObj.aTypePermissions[i].shortcut#" /></cfloop>
		</typepermissions>
	</security></cfoutput>

<cfsetting enablecfoutputonly="false" />