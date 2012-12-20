<cfcomponent displayname="FarCry Formtool" hint="Formalised content type information structure" extends="docBase" output="false">
	<cfproperty name="name" type="string" />
	<cfproperty name="displayname" type="string" />
	<cfproperty name="filepath" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="description" type="string" />
	<cfproperty name="examples" type="string" />
	<cfproperty name="aExtends" type="array" />
	<cfproperty name="aProperties" type="array" />
	
	<cffunction name="getExtends" returntype="array" access="public" output="false" hint="Returns the array of extended components">
		<cfargument name="stMD" type="struct" required="true" hint="The metadata of the component" />
		
		<cfset var aResult = arraynew(1) />
		
		<cfloop condition="structkeyexists(arguments.stMD,'extends')">
			<cfif find(".fourq",arguments.stMD.extends.fullname)><cfbreak /></cfif>
			<cfset arrayappend(aResult,arguments.stMD.extends.fullname) />
			<cfset arguments.stMD = arguments.stMD.extends />
		</cfloop>
		
		<cfreturn aResult />
	</cffunction>
	
	<cffunction name="getPropertyDetails" returntype="array" access="public" output="false" hint="Returns property information">
		<cfargument name="stProps" type="struct" required="true" hint="The metadata of they type properties" />
		
		<cfset var propertyname = "" />
		<cfset var aResults = arraynew(1) />
		<cfset var stThis = structnew() />
		<cfset var value1 = structnew() />
		<cfset var value2 = structnew() />
		<cfset var sendback = 0 />
		
		<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />
		
		<cfloop list="#listsort(structkeylist(arguments.stProps),'textnocase')#" index="propertyname">
			<cfif not listcontainsnocase("objectid,label,datetimecreated,createdby,ownedby,datetimelastupdated,lastupdatedby,lockedBy,locked,status,versionID",propertyname)>
				<cfset stThis = duplicate(arguments.stProps[propertyname].metadata) />
				
				<cfparam name="stThis.hint" default="" />
				<cfparam name="stThis.required" default="false" />
				<cfparam name="stThis.default" default="" />
				<cfparam name="stThis.options" default="" />
				
				<cfset arrayappend(aResults,stThis) />
			</cfif>
		</cfloop>
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="getWarnings" returntype="array" access="public" output="false" hint="Returns automatically generated alerts for missing information">
		<cfargument name="stType" type="struct" required="true" hint="Type information" />
		
		<cfset aResults = arraynew(1) />
		
		
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="generateFormtoolMetadata" returntype="struct" access="public" output="false" hint="Generates and returns type information">
		<cfset var locationfilter = "" />
		<cfset var stResult = structnew() />
		<cfset var stType = structnew() />
		<cfset var stProps = structnew() />
		<cfset var thistool = "" />
		<cfset var oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
		<cfset var stMetadata = structnew() />
		<cfset var source = "" />
		<cfset var stInfo = structnew() />
		
		<cfset stResult.q = querynew("typename,location,displayname,bDocument","varchar,varchar,varchar,bit") />
		<cfset stResult.st = structnew() />
		
		<!--- Location filter --->
		<cfif isdefined("application.config.docs.locations")>
			<cfset locationfilter = "" />
			<cfloop list="#application.config.docs.locations#" index="thislocation">
				<cfswitch expression="#thislocation#">
					<cfcase value="core">
						<cfset locationfilter = listappend(locationfilter,"core\.packages\.formtools\.(?!field)","|") />
					</cfcase>
					<cfcase value="project">
						<cfset locationfilter = listappend(locationfilter,"projects\.[^\.]+\.packages\.formtools","|") />
					</cfcase>
					<cfdefaultcase><!--- Plugin --->
						<cfset locationfilter = listappend(locationfilter,"plugins\.#thislocation#\.packages\.formtools","|") />
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
			<cfset locationfilter = "(#locationfilter#)" />
		<cfelse>
			<cfset locationfilter = "\.formtools" />
		</cfif>
		
		<cfloop collection="#application.formtools#" item="thistool">
			<cfif refindnocase(locationfilter,"#arraytolist(application.formtools[thistool].aExtends)#,#application.formtools[thistool].packagepath#") and structkeyexists(application.formtools[thistool],"stProps")>
				<cfset stProps = application.formtools[thistool].stProps />
				
				<cfset stType = structnew() />
				<cfset stType.objectid = createuuid() />
				<cfset stType.typename = "docFormtool" />
				
				<cfset stType.name = thistool />
				<cfset stType.bDocument = iif(structkeyexists(application.formtools[thistool],"bDocument"),"application.formtools[thistool].bDocument","1") />
				<cfset stType.bDeprecated = iif(structkeyexists(application.formtools[thistool],"bDeprecated"),"application.formtools[thistool].bDeprecated","0") />
				<cfset stType.displayname = iif(structkeyexists(application.formtools[thistool],"displayname"),"application.formtools[thistool].displayname","thistype") />
				<cfset stType.hint = iif(structkeyexists(application.formtools[thistool],"hint"),"application.formtools[thistool].hint",de("")) />
				<cfset stType.filepath = application.formtools[thistool].path />
				<cfset stType.packagepath = application.formtools[thistool].packagepath />
				<cfset stType.description = iif(structkeyexists(application.formtools[thistool],"description"),"application.formtools[thistool].description",de("")) />
				
				<!--- Location --->
				<cfif refind("^farcry\.plugins\.",application.formtools[thistool].packagepath)>
					<cfset stType.location = rereplace(application.formtools[thistool].packagepath,".*\.plugins\.([^\.]+)\.packages\.[^\.]+\.[^\.]+","\1") />
				<cfelseif refind("farcry\.projects\.",application.formtools[thistool].packagepath)>
					<cfset stType.location = "project" />
				<cfelse>
					<cfset stType.location = "core" />
				</cfif>
				
				<!--- Deprecated message --->
				<cfif structkeyexists(stType,"deprecated")>
					<cfset stType.bDeprecated = true />
				<cfelseif stType.bDeprecated>
					<cfset stType.deprecated = "This formtool has been deprecated" />
				</cfif>
				
				<!--- Extends --->
				<cfset stMetadata = getMetadata(createobject("component",application.formtools[thistool].packagepath)) />
				<cfset stType.aExtends = getExtends(stMetadata) />
				
				<!--- Properties --->
				<cfset stType.aProperties = getPropertyDetails(stProps) />
				
				<!--- Warnings --->
				<cfset stType.aWarnings = getWarnings(stType) />
				
				<!--- Scrape comment variables --->
				<cffile action="read" file="#expandpath('/' & replace(application.formtools[thistool].packagepath,'.','/','ALL') & '.cfc')#" variable="source" />
				<cfset structappend(stType,oScrape.scrapeCommentVariables(source=source,escapeCode=true,debug=stType.name eq "array"),true) />
				
				<!--- Clean up examples --->
				<cfparam name="stType.examples" default="" />
				
				<cfparam name="stResult.st.#stType.location#" default="#structnew()#" />
				<cfset stResult.st[stType.location][thistool] = stType />
				
				<cfset queryaddrow(stResult.q) />
				<cfset querysetcell(stResult.q,"typename",thistool) />
				<cfset querysetcell(stResult.q,"location",stType.location) />
				<cfset querysetcell(stResult.q,"displayname",stType.displayname) />
				<cfset querysetcell(stResult.q,"bDocument",stType.bDocument) />
				
			</cfif>
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getFormtoolData" returntype="struct" output="false" access="public" hint="Returns type information">
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		
		<cfif not isdefined("application.fc.autodoc.formtools") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.formtools = generateFormtoolMetadata() />
		</cfif>
		
		<cfreturn application.fc.autodoc.formtools.st />
	</cffunction>
	
	<cffunction name="getFormtoolQuery" returntype="query" output="false" access="public" hint="Returns a query containing the name of every type">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented types" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		<cfset var qResult = querynew("empty") />
		
		<cfif not isdefined("application.fc.autodoc.formtools") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.formtools = generateFormtoolMetadata() />
		</cfif>
		
		<cfset qResult = application.fc.autodoc.formtools.q />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getFormtool" returntype="struct" access="public" output="false" hint="Returns metadata for the specified type">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="formtool" type="string" required="true" hint="The type to retrieve" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfset var qFormtools = "" />
		<cfset var stFormtools = structnew() />
		<cfset var stFormtool = structnew() />
		
		<cfset qFormtools = getFormtoolQuery(refresh=arguments.refresh) />
		<cfset stFormtools = getFormtoolData() />
		
		<cfquery dbtype="query" name="qFormtools">
			select	*
			from	qFormtools
			where	location='#arguments.location#' and package='#arguments.formtool#'
		</cfquery>
		
		<cfset stFormtool = stFormtools[arguments.location][arguments.formtool] />
		
		<cfset stFormtool.objectid = createuuid() />
		<cfset stFormtool.typename = "docFormtool" />
		<cfset stFormtool.library = arguments.formtool />
		<cfset stFormtool.name = arguments.formtool />
		<cfset stFormtool.label = stFormtool.displayname />
		
		<cfreturn stFormtool />
	</cffunction>
	
	
	
	<cffunction name="getLibraries" returntype="query" output="false" access="public" hint="Returns a query containing the location, library, tagname, and prefix of every tag">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented tags" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force tag metadata cache regeneration" />
		
		<cfset var qResult = getFormtoolQuery(argumentCollection=arguments) />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfquery dbtype="query" name="qResult">
			select distinct location, typename as library, displayname as label from qResult order by displayname
		</cfquery>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getLibrary" returntype="struct" output="false" access="public" hint="Get's a 'library' for this type">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="library" type="string" required="true" />
		
		<cfset var stResult = structnew() />
		<cfset var st = getFormtoolData() />
		
		<cfif structkeyexists(st[arguments.location],arguments.library)>
			<cfset stResult = st[arguments.location][arguments.library] />
			
			<cfset stResult.name = arguments.library />
			<cfset stResult.label = stResult.displayname />
			<cfset stResult.readme = "" />
			<cfset stResult.children = querynew("empty") />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getItems" returntype="query" output="false" access="public" hint="Get the items for a library">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		
		<cfset var qResult = querynew("emtpy") />
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getItem" returntype="struct" output="false" access="public" hint="Alias for getTag">
		
		<cfreturn structnew() />
	</cffunction>
	
	<cffunction name="getLabel">
		<cfargument name="type" type="string" required="true" />
		
		<cfswitch expression="#arguments.type#">
			<cfcase value="itemsingle">
				<cfreturn "Formtool" />
			</cfcase>
			<cfcase value="itemplural">
				<cfreturn "Formtools" />
			</cfcase>
			<cfcase value="librarysingle">
				<cfreturn "Formtool" />
			</cfcase>
			<cfcase value="libraryplural">
				<cfreturn "Formtools" />
			</cfcase>
			<cfcase value="childsingle">
				<cfreturn "Formtool" />
			</cfcase>
			<cfcase value="childplural">
				<cfreturn "Formtools" />
			</cfcase>
		</cfswitch>
	</cffunction>
	
</cfcomponent>