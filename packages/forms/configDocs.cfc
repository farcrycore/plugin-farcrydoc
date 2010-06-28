<cfcomponent displayname="FarCry Docs" hint="Configure how the docs are actually displayed. Mainly for when the documentation is exposed for public consumption." extends="farcry.core.packages.forms.forms" output="false" key="docs">
	<cfproperty ftSeq="1" ftFieldSet="General" ftWizardStep="FarCry Docs"
				name="locations" type="string" ftDefault="" ftLabel="Locations"
				ftType="list" ftListData="getLocations" ftSelectMultiple="true"
				hint="The locations that should be included in the documentation" />
	<cfproperty ftSeq="2" ftFieldSet="General" ftWizardStep="FarCry Docs"
				name="webskinlocations" type="string" ftDefault="" ftLabel="Webskin locations"
				ftType="list" ftListData="getLocations" ftSelectMultiple="true"
				hint="The locations that webskins should be drawn from" />
	<cfproperty ftSeq="3" ftFieldSet="General" ftWizardStep="FarCry Docs"
				name="css" type="boolean" ftDefault="1" ftLabel="Default CSS"
				ftType="boolean"
				hint="Should the plugin CSS be included in documentation pages" />
	
	<cfproperty ftSeq="11" ftFieldSet="Types" ftWizardStep="FarCry Docs"
				name="typesections" type="longchar" ftDefault="displayDocSummary,displayDocPropertySummary,displayDocFileLocations,displayDocJoins,displayDocWebskins,displayDocSecurity,displayDocPropertyDetails" ftLabel="Sections"
				ftType="list" ftSelectMultiple="true" ftList="displayDocSummary,displayDocPropertySummary,displayDocFileLocations,displayDocJoins,displayDocWebskins,displayDocSecurity,displayDocPropertyDetails"
				hint="The documentation sections that are displayed in type documentation" />
	<cfproperty ftSeq="12" ftFieldSet="Types" ftWizardStep="FarCry Docs"
				name="typewebskins" type="longchar" ftDefault="!displayDoc.*#chr(13)##chr(10)#!displayTypeDoc.*" ftLabel="Webskin filter"
				ftType="longchar"
				ftHint="One regular expression per line" hint="The webskins that should be included in the documentation" />
	
	<cfproperty ftSeq="21" ftFieldSet="Rules" ftWizardStep="FarCry Docs"
				name="rulesections" type="longchar" ftDefault="displayDocSummary,displayDocPropertySummary,displayDocJoins,displayDocWebskins,displayDocPropertyDetails" ftLabel="Sctions"
				ftType="list" ftSelectMultiple="true" ftList="displayDocSummary,displayDocPropertySummary,displayDocJoins,displayDocWebskins,displayDocPropertyDetails"
				hint="The documentation sections that are displayed in rule documentation" />
	<cfproperty ftSeq="22" ftFieldSet="Rules" ftWizardStep="FarCry Docs"
				name="rulewebskins" type="longchar" ftDefault="execute.*" ftLabel="Webskin filter"
				ftType="longchar"
				ftHint="One regular expression per line" hint="The webskins that should be included in the documentation" />
	
	<cffunction name="getLocations" returntype="string" output="false" access="public" hint="Returns a list of the locations and their names">
		<cfset var locations = "core:Core" />
		<cfset var oManifest = structnew() />
		<cfset var thislocation = "" />
		
		<cfloop list="#application.plugins#" index="thislocation">
			<cfif fileexists("#application.path.plugins#/#thislocation#/install/manifest.cfc")>
				<cfset oManifest = createobject("component","farcry.plugins.#thislocation#.install.manifest") />
			<cfelse>
				<cfset oManifest = structnew() />
			</cfif>
			
			<cfif structkeyexists(oManifest,"name")>
				<cfset locations = listappend(locations,"#thislocation#:#oManifest.name#") />
			<cfelse>
				<cfset locations = listappend(locations,"#thislocation#:#thislocation#") />
			</cfif>
		</cfloop>
		
		<cfset locations = listappend(locations,"project:Project") />
		
		<cfreturn locations />
	</cffunction>
	
</cfcomponent>