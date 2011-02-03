<cfcomponent displayname="FarCry Tag" hint="Formalised tag information structure" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="location" type="string" />
	<cfproperty name="library" type="string" />
	<cfproperty name="prefix" type="string" />
	<cfproperty name="taglib" type="string" />
	<cfproperty name="name" type="string" />
	<cfproperty name="bdocument" type="boolean" />
	<cfproperty name="single" type="boolean" />
	<cfproperty name="xmlstyle" type="boolean" />
	<cfproperty name="attributes" type="array" />
	<cfproperty name="description" type="string" />
	<cfproperty name="examples" type="string" />
	<cfproperty name="hint" type="string" />
	
	<cffunction name="generateTagMetadata" returntype="struct" output="false" access="public" hint="Generates and returns all tag information">
		<cfset var oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
		<cfset var stResult = structnew() />
		<cfset var thisplugin = "" />
		<cfset var thislibrary = "" />
		<cfset var thistag = "" />
		<cfset var oManifest = structnew() />
		
		<cfset stResult.q = querynew("tagname,location,library,prefix,bDocument","varchar,varchar,varchar,varchar,bit") />
		<cfset stResult.st = structnew() />
		
		<!--- Core libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)core($|,)",application.config.docs.locations)>
			<cfset stResult.st.core = oScrape.scrapeLibraries(folderpath='/farcry/core/tags',packagepath='/farcry/core/tags') />
			<cfloop collection="#stResult.st.core#" item="thislibrary">
				<cfloop collection="#stResult.st.core[thislibrary].tags#" item="thistag">
					<cfset queryaddrow(stResult.q) />
					<cfset querysetcell(stResult.q,"tagname",thistag) />
					<cfset querysetcell(stResult.q,"location","core") />
					<cfset querysetcell(stResult.q,"library",thislibrary) />
					<cfset querysetcell(stResult.q,"prefix",stResult.st.core[thislibrary].prefix) />
					<cfset querysetcell(stResult.q,"bDocument",stResult.st.core[thislibrary].tags[thistag].bdocument) />
				</cfloop>
			</cfloop>
		</cfif>
		
		<!--- Plugin libraries --->
		<cfloop list="#application.plugins#" index="thisplugin">
			<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)#thisplugin#($,)",application.config.docs.locations)>
				<cfset stResult.st[thisplugin] = oScrape.scrapeLibraries(folderpath='/farcry/plugins/#thisplugin#/tags',packagepath='/farcry/plugins/#thisplugin#/tags') />
				<cfloop collection="#stResult.st[thisplugin]#" item="thislibrary">
					<cfloop collection="#stResult.st[thisplugin][thislibrary].tags#" item="thistag">
						<cfset queryaddrow(stResult.q) />
						<cfset querysetcell(stResult.q,"tagname",thistag) />
						<cfset querysetcell(stResult.q,"location",thisplugin) />
						<cfset querysetcell(stResult.q,"library",thislibrary) />
						<cfset querysetcell(stResult.q,"bDocument",stResult.st[thisplugin][thislibrary].tags[thistag].bdocument) />
						
						<cfif thislibrary eq "tags">
							<cfif fileexists("#application.path.plugins#/#thisplugin#/install/manifest.cfc")>
								<cfset oManifest = createobject("component","farcry.plugins.#thisplugin#.install.manifest") />
							<cfelse>
								<cfset oManifest = structnew() />
							</cfif>
							<cfif structkeyexists(oManifest,"taglibraryprefix")>
								<cfset stResult.st[thisplugin][thislibrary].prefix = oManifest.taglibraryprefix />
							<cfelse>
								<cfset stResult.st[thisplugin][thislibrary].prefix = thisplugin />
							</cfif>
						<cfelse>
							<cfset stResult.st[thisplugin][thislibrary].prefix = thislibrary />
						</cfif>
						<cfset querysetcell(stResult.q,"prefix",stResult.st[thisplugin][thislibrary].prefix) />
					</cfloop>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- Project libraries --->
		<cfif not isdefined("application.config.docs.locations") or refindnocase("(^|,)project($,)",application.config.docs.locations)>
			<cfset stResult.st.project = oScrape.scrapeLibraries(folderpath="#application.path.project#/tags",packagepath="#application.path.project#/tags") />
			<cfloop collection="#stResult.st.project#" item="thislibrary">
				<cfloop collection="#stResult.st.project[thislibrary].tags#" item="thistag">
					<cfset queryaddrow(stResult.q) />
					<cfset querysetcell(stResult.q,"tagname",thistag) />
					<cfset querysetcell(stResult.q,"location","project") />
					<cfset querysetcell(stResult.q,"library",thislibrary) />
					<cfset querysetcell(stResult.q,"prefix",stResult.st.project[thislibrary].prefix) />
					<cfset querysetcell(stResult.q,"bDocument",stResult.st.project[thislibrary].tags[thistag].bdocument) />
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfquery dbtype="query" name="stResult.q">
			select		*
			from		stResult.q
			order by 	location asc, library asc, tagname asc
		</cfquery>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getTagData" returntype="struct" output="false" access="public" hint="Returns tag information">
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		
		<cfif not isdefined("application.fc.autodoc.tags") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.tags = generateTagMetadata() />
		</cfif>
		
		<cfreturn application.fc.autodoc.tags.st />
	</cffunction>
	
	<cffunction name="getTagQuery" returntype="query" output="false" access="public" hint="Returns a query containing the location, library, tagname, and prefix of every tag">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented tags" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		<cfset var qResult = querynew("empty") />
		
		<cfif not isdefined("application.fc.autodoc.tags") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.tags = generateTagMetadata() />
		</cfif>
		
		<cfset qResult = application.fc.autodoc.tags.q />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getTag" returntype="struct" output="false" access="public" hint="Returns an stObj for the specified location.library.tagname string">
		<cfargument name="tagname" type="string" required="true" hint="The tag to retrieve" />
		
		<cfset var stTags = getTagData() />
		<cfset var qTags = getTagQuery() />
		<cfset var stTag = duplicate(stTags[listgetat(arguments.tagname,1,'.')][listgetat(arguments.tagname,2,'.')].tags[listgetat(arguments.tagname,3,'.')]) />
		
		<cfset stTag.objectid = createuuid() />
		<cfset stTag.typename = "docTag" />
		
		<cfset stTag.location = listgetat(arguments.tagname,1,'.') />
		<cfset stTag.library = listgetat(arguments.tagname,2,'.') />
		<cfset stTag.name = listgetat(arguments.tagname,3,'.') />
		<cfset stTag.taglib = stTags[stTag.location][stTag.library].taglib />
		<cfset stTag.prefix = stTags[stTag.location][stTag.library].prefix />
		
		<cfreturn stTag />
	</cffunction>
	
</cfcomponent>