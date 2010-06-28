<cfcomponent displayname="FarCry Component" hint="A FarCry component as defined in /packages" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="location" type="string" />
	<cfproperty name="package" type="string" />
	<cfproperty name="name" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="scopelocation" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="functions" type="string" />
	
	
	<cffunction name="generateComponentMetadata" returntype="struct" output="false" access="public" hint="Generates and returns all component information">
		<cfset var oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
		<cfset var stResult = structnew() />
		<cfset var thisplugin = "" />
		<cfset var thispackage = "" />
		<cfset var thiscomponent = "" />
		
		<cfset stResult.q = querynew("location,package,component","varchar,varchar,varchar") />
		<cfset stResult.st = structnew() />
		
		<!--- Core libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)core($|,)",application.config.docs.locations)>
			<cfset stResult.st.core = oScrape.scrapePackages(folderpath='/farcry/core/packages',packagepath='farcry.core.packages') />
			<cfloop collection="#stResult.st.core#" item="thispackage">
				<cfloop collection="#stResult.st.core[thispackage].components#" item="thiscomponent">
					<cfset queryaddrow(stResult.q) />
					<cfset querysetcell(stResult.q,"location","core") />
					<cfset querysetcell(stResult.q,"package",thispackage) />
					<cfset querysetcell(stResult.q,"component",thiscomponent) />
				</cfloop>
			</cfloop>
		</cfif>
		
		<!--- Plugin libraries --->
		<cfloop list="#application.plugins#" index="thisplugin">
			<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)#thisplugin#($,)",application.config.docs.locations)>
				<cfset stResult.st[thisplugin] = oScrape.scrapePackages(folderpath='/farcry/plugins/#thisplugin#/packages',packagepath='farcry.plugins.#thisplugin#.packages') />
				<cfloop collection="#stResult.st[thisplugin]#" item="thispackage">
					<cfloop collection="#stResult.st[thisplugin][thispackage].components#" item="thiscomponent">
						<cfset queryaddrow(stResult.q) />
						<cfset querysetcell(stResult.q,"location",thisplugin) />
						<cfset querysetcell(stResult.q,"package",thispackage) />
						<cfset querysetcell(stResult.q,"component",thiscomponent) />
					</cfloop>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- Project libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)project($,)",application.config.docs.locations)>
			<cfset stResult.st.project = oScrape.scrapePackages(folderpath="#application.path.project#/packages",packagepath="farcry.projects.#application.projectdirectoryname#.packages") />
			<cfloop collection="#stResult.st.project#" item="thispackage">
				<cfloop collection="#stResult.st.project[thispackage].components#" item="thiscomponent">
					<cfset queryaddrow(stResult.q) />
					<cfset querysetcell(stResult.q,"location","project") />
					<cfset querysetcell(stResult.q,"package",thispackage) />
					<cfset querysetcell(stResult.q,"component",thiscomponent) />
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfquery dbtype="query" name="stResult.q">
			select		*
			from		stResult.q
			order by 	location asc, package asc, component asc
		</cfquery>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getComponentData" returntype="struct" output="false" access="public" hint="Returns component information">
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force component metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		
		<cfif not isdefined("application.fc.autodoc.components") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.components = generateComponentMetadata() />
		</cfif>
		
		<cfreturn application.fc.autodoc.components.st />
	</cffunction>
	
	<cffunction name="getComponentQuery" returntype="query" output="false" access="public" hint="Returns a query containing the location, package, and component of every component">
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		
		<cfif not isdefined("application.fc.autodoc.components") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.components = generateComponentMetadata() />
		</cfif>
		
		<cfreturn application.fc.autodoc.components.q />
	</cffunction>
	
	<cffunction name="getComponent" returntype="struct" output="false" access="public" hint="Returns the data for a specified component of the form location.package.component">
		<cfargument name="componentname" type="string" required="true" hint="The component" />
		
		<cfset var qComponents = getComponentQuery() />
		<cfset var stComponents = getComponentData() />
		<cfset var stComponent = structnew() />
		
		<cfset stComponent.objectid = createuuid() />
		<cfset stComponent.typename = "docComponent" />
		<cfset stComponent.location = "#listgetat(arguments.componentname,1,'.')#" />
		<cfset stComponent.package = "#listgetat(arguments.componentname,2,'.')#" />
		<cfset stComponent.name = "#listgetat(arguments.componentname,3,'.')#" />
		<cfset stComponent.packagepath = stComponents[stComponent.location][stComponent.package].components[stComponent.name].packagepath />
		<cfset stComponent.scopelocation = stComponents[stComponent.location][stComponent.package].components[stComponent.name].scopelocation />
		<cfset stComponent.hint = stComponents[stComponent.location][stComponent.package].components[stComponent.name].hint />
		<cfset stComponent.functions = stComponents[stComponent.location][stComponent.package].components[stComponent.name].functions />
		
		<cfreturn stComponent />
	</cffunction>
	
</cfcomponent>