<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getFormtool(url.ref) />
</cfif>

<doc:subsection title="Properties" anchor="#stObj.name#_properties">
	<doc:details properties="4">
		<doc:item type="header" v1="Name" v2="Default" v3="Required" v4="Options" v5="Notes" />
		
		<cfloop from="1" to="#arraylen(stObj.aProperties)#" index="i">
			
			<!--- lifestory default value detected, wrap in span and display full default as tooltip --->
			<cfif len(stObj.aProperties[i].default) GT 20>
				<cfset stObj.aProperties[i].default = "<span title=""#stObj.aProperties[i].default#""> " & left(stObj.aProperties[i].default,17) & "...</span>" />
			</cfif>
			
			<doc:item type="simple" class="" v1="#stObj.aProperties[i].name#" v2="#stObj.aProperties[i].default#" v3="#stObj.aProperties[i].required#" v4="#stObj.aProperties[i].required#" v5="#stObj.aProperties[i].hint#" />
			
		</cfloop>
	
	</doc:details>
</doc:subsection>

<cfsetting enablecfoutputonly="false" />