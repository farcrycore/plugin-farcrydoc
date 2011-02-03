<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property details --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfset priorityattr = "ftSeq,ftWizardStep,ftFieldSet,ftType,ftDefault,ftLabel,ftHint,ftHelpTitle,ftHelpSection" />

<cfloop from="1" to="#arraylen(stObj.aProperties)#" index="i">
	<cfif structkeyexists(url,"bodyview") and url.bodyview neq "displayDocPropertyDetails" and url.view neq "displayDocPropertyDetails">
		<cfset linkbackurl = "###stObj.name#_properties" />
		<cfset linkbacktext = "Back to Property Summary" />
	<cfelse>
		<cfset linkbackurl = "" />
		<cfset linkbacktext = "" />
	</cfif>
	
	<doc:subsection title="Property details: #stObj.aProperties[i].name# (#stObj.aProperties[i].type#)" anchor="#stObj.name#_#stObj.aProperties[i].name#" linkbackurl="#linkbackurl#" linkbacktext="#linkbacktext#">
		
		<!--- Deprecation --->
		<cfif stObj.aProperties[i].bDeprecated>
			<cfoutput><p class="Deprecated">#stObj.aProperties[i].deprecated#</p></cfoutput>
		</cfif>
		
		<cfif len(stObj.aProperties[i].hint)>
			<cfoutput><p class="DocDescription">#stObj.aProperties[i].hint#</p></cfoutput>
		</cfif>
		
		<doc:details properties="2" class="DocAttributes">
			
			<cfloop list="#priorityattr#" index="thisattr">
				<cfif structkeyexists(stObj.aProperties[i],thisattr) and len(stObj.aProperties[i][thisattr])>
					<doc:item type="simple" v1="#thisattr#" v2="#stObj.aProperties[i][thisattr]#" />
				</cfif>
			</cfloop>
				
			<cfloop collection="#stObj.aProperties[i]#" item="thisattr">
				<cfif not listcontainsnocase(priorityattr,thisattr) and (left(thisattr,2) eq "ft" or listcontainsnocase("default,required,blabel",thisattr)) and len(stObj.aProperties[i][thisattr])>
					<doc:item type="simple" v1="#lcase(thisattr)#" v2="#stObj.aProperties[i][thisattr]#" />
				</cfif>
			</cfloop>
				
			<cfif structisempty(stObj.aProperties[i])>
				<doc:item type="simple" v1="No attributes" v2="" />
			</cfif>
			
		</doc:details>
		
	</doc:subsection>
	
</cfloop>

<cfsetting enablecfoutputonly="false" />