<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Component documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif not isdefined("application.config.docs.css") or application.config.docs.css>
	<skin:htmlHead id="farcrydocs"><cfoutput><style type="text/css"><cfinclude template="../../www/css/docs.css" /></style></cfoutput></skin:htmlHead>
</cfif>

<cfif (stObj.typename neq "docComponent" or not len(stObj.name)) and isdefined("url.ref") and len(url.ref)>
	<cfparam name="url.refreshdocs" default="0" />
	<cfset stObj = getComponent(url.ref,url.refreshdocs) />
</cfif>
<cfdump var="#stObj#">
<doc:section title="#stObj.location#: #stObj.package#.#stObj.name#">
	<!--- Deprecation --->
	<cfif stObj.bDeprecated>
		<cfoutput><p class="Deprecated">This component is deprecated</p></cfoutput>
	</cfif>
	
	<cfif len(stObj.hint)><p>#stObj.hint#</p></cfif>
	
	<doc:details properties="2" class="DocAttributes">
		<doc:item type="simple" v1="Name" v2="#stObj.name#" />
		<doc:item type="simple" v1="Package path" v2="#stObj.packagepath#" />
		<cfif len(stObj.scopelocation)><doc:item type="simple" v1="Scope location" v2="#stObj.scopelocation#" /></cfif>
	</doc:details>
	
	<cfloop list="#listsort(structkeylist(stObj.functions),'textnocase')#" index="thisfunction">
		<doc:subsection title="#stObj.functions[thisfunction].name#">
			<!--- Deprecation --->
			<cfif stObj.functions[thisfunction].bDeprecated>
				<cfoutput><p class="Deprecated">This component is deprecated</p></cfoutput>
			</cfif>
			
			<cfif len(stObj.functions[thisfunction].description)>
				<cfoutput><p>#stObj.functions[thisfunction].description#</p></cfoutput>
			<cfelseif len(stObj.functions[thisfunction].hint)>
				<cfoutput><p>#stObj.functions[thisfunction].hint#</p></cfoutput>
			</cfif>
			
			<doc:details properties="2" class="DocAttributes">
				<doc:item type="header" v1="Argument" v2="Type" v3="Required" v4="Default" v5="Options" v6="Hint" />
				
				<cfif arraylen(stObj.functions[thisfunction].arguments)>
					<cfloop from="1" to="#arraylen(stObj.functions[thisfunction].arguments)#" index="i">
						<cfif structkeyexists(stObj.functions[thisfunction].arguments[i],"default")>
							<cfset thisdefault = stObj.functions[thisfunction].arguments[i].default />
						<cfelse>
							<cfset thisdefault = "" />
						</cfif>
						<doc:item type="simple" v1="#stObj.functions[thisfunction].arguments[i].name#" v2="#stObj.functions[thisfunction].arguments[i].type#" v3="#yesnoformat(stObj.functions[thisfunction].arguments[i].required)#" v4="#thisdefault#" v5="#stObj.functions[thisfunction].arguments[i].options#" v6="#stObj.functions[thisfunction].arguments[i].hint#" />
					</cfloop>
				<cfelse>
					<doc:item type="simple" v1="None" v2="" v3="" v4="" v5="" v6="" />
				</cfif>
			</doc:details>
			
			<cfif len(stObj.functions[thisfunction].examples)>
				<cfoutput>
					<h4>Examples</h4>
					#stObj.functions[thisfunction].examples#
				</cfoutput>
			</cfif>
		</doc:subsection>
		
	</cfloop>
	
</doc:section>

<cfsetting enablecfoutputonly="false" />