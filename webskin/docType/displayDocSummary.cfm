<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<!--- Extends --->
<cfset thisextends = "" />
<cfloop from="1" to="#arraylen(stObj.aExtends)#" index="i">
	<cfset thisextends = "#thisextends#<br />&nbsp;#repeatstring('&nbsp;',i*3)#L&nbsp;#stObj.aExtends[i]#" />
</cfloop>

<!--- Deprecation --->
<cfif stObj.bDeprecated>
	<cfoutput><p class="Deprecated">This type is deprecated</p></cfoutput>
</cfif>

<!--- Description --->
<cfif len(stObj.description)>
	<cfoutput><p class="DocDescription">#stObj.description#</p></cfoutput>
<cfelseif len(stObj.hint)>
	<cfoutput><p class="DocDescription">#stObj.hint#</p></cfoutput>
</cfif>

<doc:details properties="2">
	
	<doc:item type="simple" v1="Package path" v2="#stObj.packagepath##thisextends#" />
	<doc:item type="simple" v1="File path" v2="#stObj.filepath#" />
	
</doc:details>

<doc:details properties="2" class="DocAttributes">
	<doc:item type="title" v1="Attributes" />
	
	<!--- System type --->
	<doc:item type="simple" v1="System Type" v2="#yesnoformat(stObj.bSystem)#" />
	
	<!--- Use in tree --->
	<doc:item type="simple" v1="Use in tree" v2="#yesnoformat(stObj.bUseInTree)#" />
	
	<!--- Use friendly urls --->
	<doc:item type="simple" v1="Friendly URLs" v2="#yesnoformat(stObj.bFriendly)#" />
	
	<doc:item type="simple" v1="" v2="" v3="" />
	
	
	<doc:item type="title" v1="Caching" />
	
	<!--- Object broker --->
	<doc:item type="simple" v1="Object broker" v2="#yesnoformat(stObj.bObjectBroker)#" />
	
	<!--- Objct broker limit --->
	<cfif stObj.bObjectBroker>
		<doc:item type="simple" v1="Object broker limit" v2="#stObj.objectbrokermaxobjects#" />
	</cfif>
	
</doc:details>

<cfsetting enablecfoutputonly="false" />