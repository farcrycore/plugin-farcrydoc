<cfcomponent displayname="FarCry Component" hint="A FarCry component as defined in /packages" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="location" type="string" />
	<cfproperty name="package" type="string" />
	<cfproperty name="name" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="scopelocation" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="functions" type="string" />
	
	
	<cffunction name="generateComponentMetadata" returntype="struct" output="false" access="public" hint="Generates and returns all component information">
		<cfargument name="path" type="string" required="true" hint="The component to generate" />
		
		<cfset var oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
		<cfset var stMetadata = getMetadata(createobject("component",arguments.path)) />
		<cfset var source = "" />
		
		<cffile action="read" file="#expandpath('/' & replace(arguments.path,'.','/','ALL') & '.cfc')#" variable="source" />
		
		<cfreturn oScrape.scrapeComponent(stMetadata=stMetadata,source=source) />
	</cffunction>
	
	<cffunction name="generateComponentQuery" returntype="query" output="false" access="public" hint="Generates and returns component information">
		<cfset var q = querynew("path,location,locationorder,package,packageref,component,bDocument","varchar,varchar,integer,varchar,varchar,varchar,bit") />
		<cfset var qPackages = "" />
		<cfset var qComponents = "" />
		
		<!--- Core libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)core($|,)",application.config.docs.locations)>
			<cfdirectory action="list" directory="#application.path.core#/packages" recurse="false" name="qPackages" />
			<cfloop query="qPackages">
				<cfif qPackages.type eq "Dir">
					<cfdirectory action="list" directory="#application.path.core#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
					<cfloop query="qComponents">
						<cfset st = getMetadata(createobject("component","farcry.core.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
						<cfparam name="st.bDocument" default="true" />
						<cfset queryaddrow(q) />
						<cfset querysetcell(q,"path","farcry.core.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
						<cfset querysetcell(q,"location","core") />
						<cfset querysetcell(q,"locationorder",q.recordcount) />
						<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
						<cfset querysetcell(q,"packageref","core.#qPackages.name[qPackages.currentrow]#") />
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
					<cfif qPackages.type eq "Dir">
						<cfdirectory action="list" directory="#application.path.plugins#/#thisplugin#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
						<cfloop query="qComponents">
							<cfset st = getMetadata(createobject("component","farcry.plugins.#thisplugin#.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
							<cfparam name="st.bDocument" default="true" />
							<cfset queryaddrow(q) />
							<cfset querysetcell(q,"path","farcry.plugins.#thisplugin#.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
							<cfset querysetcell(q,"location",thisplugin) />
							<cfset querysetcell(q,"locationorder",q.recordcount) />
							<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
							<cfset querysetcell(q,"packageref","#thisplugin#.#qPackages.name[qPackages.currentrow]#") />
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
				<cfif qPackages.type eq "Dir">
					<cfdirectory action="list" directory="#application.path.project#/packages/#qPackages.name#" recurse="false" filter="*.cfc" name="qComponents" />
					<cfloop query="qComponents">
						<cfset st = getMetadata(createobject("component","farcry.project.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#")) />
						<cfparam name="st.bDocument" default="true" />
						<cfset queryaddrow(q) />
						<cfset querysetcell(q,"path","farcry.project.packages.#qPackages.name[qPackages.currentrow]#.#listfirst(qComponents.name[qComponents.currentrow],".")#") />
						<cfset querysetcell(q,"location","project") />
						<cfset querysetcell(q,"locationorder",q.recordcount) />
						<cfset querysetcell(q,"package",qPackages.name[qPackages.currentrow]) />
						<cfset querysetcell(q,"packageref","project.#qPackages.name[qPackages.currentrow]#") />
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
			<cfset application.fc.autodoc.components = structnew() />
			<cfset application.fc.autodoc.components.q = generateComponentQuery() />
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
		<cfargument name="path" type="string" required="true" hint="The component" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfset var qComponents = "" />
		<cfset var stComponent = structnew() />
		
		<cfif not (isdefined("application.fc.autodoc.components.st") and structkeyexists(application.fc.autodoc.components.st,arguments.path)) or arguments.refresh>
			<cfset qComponents = getComponentQuery(1,arguments.refresh) />
			<cfquery dbtype="query" name="qComponents">
				select	*
				from	qComponents
				where	path=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#" />
			</cfquery>
			
			<cfset stComponent = generateComponentMetadata(arguments.path) />
			
			<cfset stComponent.objectid = createuuid() />
			<cfset stComponent.typename = "docComponent" />
			<cfset stComponent.packagepath = qComponents.path[1] />
			<cfset stComponent.location = qComponents.location[1] />
			<cfset stComponent.package = qComponents.package[1] />
			<cfset stComponent.name = qComponents.component[1] />
			<cfparam name="stComponent.bDocument" default="false" />
			<cfparam name="stComponent.bDeprecated" default="false" />
			
			<cfparam name="application.fc.autodoc.components.st" default="#structnew()#" />
			<cfset application.fc.autodoc.components.st[arguments.path] = stComponent />
		</cfif>
		
		<cfreturn duplicate(application.fc.autodoc.components.st[arguments.path]) />
	</cffunction>
	
</cfcomponent>