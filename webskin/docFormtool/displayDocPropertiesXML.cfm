<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getFormtool(url.ref) />
</cfif>

<cfoutput>
	<attributes><cfloop from="1" to="#arraylen(stObj.aProperties)#" index="i">
		<property<cfloop list="name,default,required,hint,options" index="thisattr"> #lcase(thisattr)#="#xmlformat(stObj.aProperties[i][thisattr])#"</cfloop> /></cfloop>
	</attributes></cfoutput>

<cfsetting enablecfoutputonly="false" />