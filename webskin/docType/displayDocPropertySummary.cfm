<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<doc:subsection title="Property Summary" anchor="#stObj.name#_properties">
	<doc:details properties="7">
		<doc:item type="header" v1="Name" v2="Base Type" v3="Form Tool Type" v4="Sequence" v5="Wizard Step" v6="Field Set" v7="Label" />
		
		<cfloop from="1" to="#arraylen(stObj.aProperties)#" index="i">
			
			<!--- Property name --->
			<cfif structkeyexists(url,"bodyview") and url.bodyview neq "displayDocPropertySummary" and url.view neq "displayDocPropertySummary">
				<cfset thisname = "<a href='###stObj.name#_#stObj.aProperties[i].name#'>#stObj.aProperties[i].name#</a>" />
			<cfelse>
				<cfset thisname = stObj.aProperties[i].name />
			</cfif>
			
			<!--- Derecation --->
			<cfif stObj.aProperties[i].bDeprecated>
				<cfset stLocal.class = "deprecated" />
			<cfelse>
				<cfset stLocal.class = "" />
			</cfif>
			
			<doc:item type="simple" class="#stLocal.class#" v1="#thisname#" v2="#stObj.aProperties[i].type#" v3="#stObj.aProperties[i].fttype#" v4="#stObj.aProperties[i].ftSeq#" v5="#stObj.aProperties[i].ftWizardStep#" v6="#stObj.aProperties[i].ftFieldSet#" v7="#stObj.aProperties[i].ftLabel#" />
			
		</cfloop>
	
	</doc:details>
</doc:subsection>

<cfsetting enablecfoutputonly="false" />