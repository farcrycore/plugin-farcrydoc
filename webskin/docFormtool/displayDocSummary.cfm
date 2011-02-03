<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Formtool summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getFormtool(url.ref) />
</cfif>

<!--- Extends --->
<cfset thisextends = "" />
<cfloop from="1" to="#arraylen(stObj.aExtends)#" index="i">
	<cfset thisextends = "#thisextends#<br />&nbsp;#repeatstring('&nbsp;',i*3)#L&nbsp;#stObj.aExtends[i]#" />
</cfloop>

<!--- Deprecation --->
<cfif stObj.bDeprecated>
	<cfoutput><p class="Deprecated">#stObj.deprecated#</p></cfoutput>
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

<cfsetting enablecfoutputonly="false" />