<cfcomponent displayname="FarCry Component" hint="A FarCry component as defined in /packages" extends="docBase" output="false">
	<cfproperty name="location" type="string" />
	<cfproperty name="package" type="string" />
	<cfproperty name="name" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="scopelocation" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="functions" type="string" />
	
	
	<cffunction name="generateComponentMetadata" returntype="struct" output="false" access="public" hint="Generates and returns all component information">
		<cfset var stResult = structnew() />
		<cfset var oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
		<cfset var stMetadata = structnew() />
		<cfset var source = "" />
		
		<cfset stResult.q = generateComponentQuery() />
		<cfset stResult.st = structnew() />
		
		<cfoutput query="stResult.q" group="location">
			<cfset stResult.st[stResult.q.location] = structnew() />
			
			<cfoutput group="package">
				<cfset stResult.st[stResult.q.location][stResult.q.package] = structnew() />
				
				<!--- Library blurb --->
				<cfif fileexists("#expandpath('/' & replace(stResult.q.packageref,'.','/','ALL'))#/readme.html")>
					<cffile action="read" file="#expandpath('/' & replace(stResult.q.packageref,'.','/','ALL'))#/readme.html" variable="stResult.st.#stResult.q.location#.#stResult.q.package#.readme" />
					<cfif find("deprecated",stResult.st[stResult.q.location][stResult.q.package].readme)>
						<cfset stResult.st[stResult.q.location][stResult.q.package].bDeprecated = true />
					<cfelse>
						<cfset stResult.st[stResult.q.location][stResult.q.package].bDeprecated = false />
					</cfif>
				<cfelse>
					<cfset stResult.st[stResult.q.location][stResult.q.package].readme = "" />
					<cfset stResult.st[stResult.q.location][stResult.q.package].bDeprecated = false />
				</cfif>
				
				<cfoutput>
					<cfset stMetadata = getMetadata(createobject("component",stResult.q.path)) />
					
					<cffile action="read" file="#expandpath('/' & replace(stResult.q.path,'.','/','ALL') & '.cfc')#" variable="source" />
					
					<cfset stResult.st[stResult.q.location][stResult.q.package][stResult.q.component] = oScrape.scrapeComponent(stMetadata=stMetadata,source=source) />
				</cfoutput>
			</cfoutput>
		</cfoutput>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="generateComponentQuery" returntype="query" output="false" access="public" hint="Generates and returns component information">
		<cfset var q = querynew("path,location,locationorder,package,packageref,component,bDocument","varchar,varchar,integer,varchar,varchar,varchar,bit") />
		<cfset var qPackages = "" />
		<cfset var qComponents = "" />
		
		<!--- Core libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)core($|,)",application.config.docs.locations)>
			<cfdirectory action="list" directory="#application.path.core#/packages" recurse="false" name="qPackages" />
			<cfloop query="qPackages">
				<cfif qPackages.type eq "Dir" and not listfindnocase("types,rules,formtools,forms",qPackages.name)>
					<cfdirectory action="list" directory="#application.path.core#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
					<cfloop query="qComponents">
						<cfset st = getMetadata(createobject("component","farcry.core.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
						<cfparam name="st.bDocument" default="true" />
						<cfset queryaddrow(q) />
						<cfset querysetcell(q,"path","farcry.core.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
						<cfset querysetcell(q,"location","core") />
						<cfset querysetcell(q,"locationorder",q.recordcount) />
						<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
						<cfset querysetcell(q,"packageref","farcry.core.packages.#qPackages.name[qPackages.currentrow]#") />
						<cfset querysetcell(q,"component",listfirst(qComponents.name[qComponents.currentrow],".")) />
						<cfset querysetcell(q,"bDocument",st.bDocument) />
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Plugin libraries --->
		<cfloop list="#application.plugins#" index="thisplugin">
			<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)#thisplugin#($,)",application.config.docs.locations)>
				<cfdirectory action="list" directory="#application.path.plugins#/#thisplugin#/packages" recurse="false" name="qPackages" />
				<cfloop query="qPackages">
					<cfif qPackages.type eq "Dir" and not listfindnocase("types,rules,formtools,forms",qPackages.name)>
						<cfdirectory action="list" directory="#application.path.plugins#/#thisplugin#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
						<cfloop query="qComponents">
							<cfset st = getMetadata(createobject("component","farcry.plugins.#thisplugin#.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
							<cfparam name="st.bDocument" default="true" />
							<cfset queryaddrow(q) />
							<cfset querysetcell(q,"path","farcry.plugins.#thisplugin#.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
							<cfset querysetcell(q,"location",thisplugin) />
							<cfset querysetcell(q,"locationorder",q.recordcount) />
							<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
							<cfset querysetcell(q,"packageref","farcry.plugins.#thisplugin#.packages.#qPackages.name[qPackages.currentrow]#") />
							<cfset querysetcell(q,"component",listfirst(qComponents.name[qComponents.currentrow],".")) />
							<cfset querysetcell(q,"bDocument",st.bDocument) />
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- Project libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)project($,)",application.config.docs.locations)>
			<cfdirectory action="list" directory="#application.path.project#/packages" recurse="false" name="qPackages" />
			<cfloop query="qPackages">
				<cfif qPackages.type eq "Dir" and not listfindnocase("types,rules,formtools,forms",qPackages.name)>
					<cfdirectory action="list" directory="#application.path.project#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
					<cfloop query="qComponents">
						<cfset st = getMetadata(createobject("component","farcry.project.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
						<cfparam name="st.bDocument" default="true" />
						<cfset queryaddrow(q) />
						<cfset querysetcell(q,"path","farcry.project.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
						<cfset querysetcell(q,"location","project") />
						<cfset querysetcell(q,"locationorder",q.recordcount) />
						<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
						<cfset querysetcell(q,"packageref","farcry.project.packages.#qPackages.name[qPackages.currentrow]#") />
						<cfset querysetcell(q,"component",listfirst(qComponents.name[qComponents.currentrow],".")) />
						<cfset querysetcell(q,"bDocument",st.bDocument) />
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfquery dbtype="query" name="stResult.q">
			select		*
			from		q
			order by 	locationorder asc, package asc, component asc
		</cfquery>
		
		<cfreturn q />
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
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented types" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		<cfset var qResult = querynew("empty") />
		
		<cfif not isdefined("application.fc.autodoc.components.q") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.components = generateComponentMetadata() />
		</cfif>
		
		<cfset qResult = application.fc.autodoc.components.q />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getComponent" returntype="struct" output="false" access="public" hint="Returns the data for a specified component of the form location.package.component">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="package" type="string" required="true" />
		<cfargument name="component" type="string" required="true" hint="The component" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfset var qComponents = "" />
		<cfset var stComponent = structnew() />
		
		<cfset qComponents = getComponentQuery(false,arguments.refresh) />
		<cfquery dbtype="query" name="qComponents">
			select	*
			from	qComponents
			where	location='#arguments.location#' and package='#arguments.package#' and component='#arguments.component#'
		</cfquery>
		
		<cfset stComponent = application.fc.autodoc.components.st[arguments.location][arguments.package][arguments.component] />
		
		<cfset stComponent.objectid = createuuid() />
		<cfset stComponent.typename = "docComponent" />
		<cfset stComponent.packagepath = qComponents.path[1] />
		<cfset stComponent.location = qComponents.location[1] />
		<cfset stComponent.library = qComponents.package[1] />
		<cfset stComponent.package = qComponents.package[1] />
		<cfset stComponent.name = qComponents.component[1] />
		<cfset stComponent.label = qComponents.component[1] />
		<cfparam name="stComponent.bDocument" default="false" />
		
		<cfreturn stComponent />
	</cffunction>
	
	
	<cffunction name="getLibraries" returntype="query" output="false" access="public" hint="Returns a query containing the location, library, tagname, and prefix of every tag">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented tags" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var qResult = getComponentQuery(argumentCollection=arguments) />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfquery dbtype="query" name="qResult">
			select distinct location, package as library, package as label from qResult order by package
		</cfquery>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getLibrary" returntype="struct" output="false" access="public" hint="Get's a 'library' for this type">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="library" type="string" required="true" />
		
		<cfset var stResult = structnew() />
		<cfset var st = getComponentData() />
		
		<cfif structkeyexists(st[arguments.location],arguments.library)>
			<cfset stResult.name = arguments.library />
			<cfset stResult.label = arguments.library />
			<cfset stResult.readme = st[arguments.location][arguments.library].readme />
			<cfset stResult.bDeprecated = st[arguments.location][arguments.library].bDeprecated />
			<cfset stResult.children = getItems(arguments.location,arguments.library) />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getItems" returntype="query" output="false" access="public" hint="Get the items for a library">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		
		<cfset var qResult = "" />
		<cfset var q = getComponentQuery() />
		
		<cfif structkeyexists(application.fc.autodoc.components.st[arguments.location],arguments.name)>
			<cfquery dbtype="query" name="qResult">
				select *, component as name, component as label from q where location='#arguments.location#' and package='#arguments.name#' and bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getItem" returntype="struct" output="false" access="public" hint="Alias for getTag">
		
		<cfreturn getComponent(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getLabel">
		<cfargument name="type" type="string" required="true" />
		
		<cfswitch expression="#arguments.type#">
			<cfcase value="itemsingle">
				<cfreturn "Function" />
			</cfcase>
			<cfcase value="itemplural">
				<cfreturn "Component Packages" />
			</cfcase>
			<cfcase value="librarysingle">
				<cfreturn "Package" />
			</cfcase>
			<cfcase value="libraryplural">
				<cfreturn "Component Packages" />
			</cfcase>
			<cfcase value="childsingle">
				<cfreturn "Component" />
			</cfcase>
			<cfcase value="childplural">
				<cfreturn "Components" />
			</cfcase>
		</cfswitch>
	</cffunction>
	
</cfcomponent>