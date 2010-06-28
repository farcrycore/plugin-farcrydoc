<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Tag documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif not isdefined("application.config.docs.css") or application.config.docs.css>
	<skin:htmlHead id="farcrydocs"><cfoutput><style type="text/css"><cfinclude template="../../www/css/docs.css" /></style></cfoutput></skin:htmlHead>
</cfif>

<cfif (stObj.typename neq "docTag" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getTag(url.ref) />
</cfif>

<doc:section title="&lt;#stObj.prefix#:#stObj.name#&gt;">
	<cfif len(stObj.description)>
		<cfoutput><p>#stObj.description#</p></cfoutput>
	<cfelseif len(stObj.hint)>
		<cfoutput><p>#stObj.hint#"</p></cfoutput>
	</cfif>
	
	<doc:details properties="2" class="DocAttributes">
		<doc:item type="simple" v1="Library" v2="#stObj.library#" />
		<doc:item type="simple" v1="Prefix" v2="#stObj.prefix#" />
		<doc:item type="simple" v1="Library path" v2="#stObj.taglib#" />
		<doc:item type="simple" v1="CFImport" v2="&lt;cfimport taglib=&quot;#stObj.taglib#&quot; prefix=&quot;#stObj.prefix#&quot; /&gt;" />
		<doc:item type="simple" v1="Single tag" v2="#stObj.single#" />
		<doc:item type="simple" v1="XML style" v2="#stObj.xmlstyle#" />
	</doc:details>
	
	<doc:subsection title="Attributes">
		<doc:details properties="2" class="DocAttributes">
			<doc:item type="header" v1="Name" v2="Type" v3="Required" v4="Default" v5="Options" v6="Description" />
			
			<cfif arraylen(stObj.attributes)>
				<cfloop from="1" to="#arraylen(stObj.attributes)#" index="i">
					<doc:item type="simple" v1="#stObj.attributes[i].name#" v2="#stObj.attributes[i].type#" v3="#yesnoformat(stObj.attributes[i].required)#" v4="#stObj.attributes[i].default#" v5="#stObj.attributes[i].options#" v6="#stObj.attributes[i].hint#" />
				</cfloop>
			<cfelse>
				<doc:item type="simple" v1="None" v2="" v3="" v4="" v5="" v6="" />
			</cfif>
		</doc:details>
	</doc:subsection>
	
	<cfif len(stObj.examples)>
		<doc:subsection title="Examples">
			<cfoutput>#stObj.examples#</cfoutput>
		</doc:subsection>
	</cfif>
	
</doc:section>

<cfsetting enablecfoutputonly="false" />