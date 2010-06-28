<cfcomponent displayname="FarCry Formtool" hint="Formalised content type information structure" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="name" type="string" />
	<cfproperty name="displayname" type="string" />
	<cfproperty name="filepath" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="description" type="string" />
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
		
		<cfset stResult.q = querynew("typename,displayname,bDocument","varchar,varchar,bit") />
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
				<cfset queryaddrow(stResult.q) />
				<cfset querysetcell(stResult.q,"typename",thistool) />
				<cfif structkeyexists(application.formtools[thistool],"displayname")>
					<cfset querysetcell(stResult.q,"displayname",application.formtools[thistool].displayname) />
				<cfelse>
					<cfset querysetcell(stResult.q,"displayname",thistool) />
				</cfif>
				<cfif structkeyexists(application.formtools[thistool],"bDocument")>
					<cfset querysetcell(stResult.q,"bDocument",application.formtools[thistool].bDocument) />
				<cfelse>
					<cfset querysetcell(stResult.q,"bDocument",0) />
				</cfif>
				
				<cfset stProps = application.formtools[thistool].stProps />
				
				<cfset stType = structnew() />
				<cfset stType.objectid = createuuid() />
				<cfset stType.typename = "docType" />
				
				<cfset stType.name = thistool />
				<cfset stType.bDocument = iif(structkeyexists(application.formtools[thistool],"bDocument"),"application.formtools[thistool].bDocument","0") />
				<cfset stType.bDeprecated = iif(structkeyexists(application.formtools[thistool],"bDeprecated"),"application.formtools[thistool].bDeprecated","0") />
				<cfset stType.displayname = iif(structkeyexists(application.formtools[thistool],"displayname"),"application.formtools[thistool].displayname","thistype") />
				<cfset stType.hint = iif(structkeyexists(application.formtools[thistool],"hint"),"application.formtools[thistool].hint",de("")) />
				<cfset stType.filepath = application.formtools[thistool].path />
				<cfset stType.packagepath = application.formtools[thistool].packagepath />
				<cfset stType.description = iif(structkeyexists(application.formtools[thistool],"description"),"application.formtools[thistool].description",de("")) />
				
				<!--- Extends --->
				<cfset stType.aExtends = getExtends(getMetadata(createobject("component",application.formtools[thistool].packagepath))) />
				
				<!--- Properties --->
				<cfset stType.aProperties = getPropertyDetails(stProps) />
				
				<!--- Warnings --->
				<cfset stType.aWarnings = getWarnings(stType) />
				
				<cfset stResult.st[thistool] = stType />
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
		<cfargument name="typename" type="string" required="true" hint="The type to retrieve" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfset var st = getFormtoolData(arguments.refresh) />
		
		<cfreturn duplicate(st[arguments.typename]) />
	</cffunction>
	
</cfcomponent>