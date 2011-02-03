<cfcomponent displayname="FarCry Rule" hint="Formalised content type information structure" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="name" type="string" />
	<cfproperty name="displayname" type="string" />
	<cfproperty name="filepath" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="description" type="string" />
	<cfproperty name="aExtends" type="array" />
	<cfproperty name="bSystem" type="boolean" />
	<cfproperty name="bObjectBroker" type="boolean" />
	<cfproperty name="objectbrokermaxobjects" type="numeric" />
	<cfproperty name="aProperties" type="array" />
	<cfproperty name="aJoinTo" type="array" />
	<cfproperty name="aWebskins" type="array" />
	<cfproperty name="aWarnings" type="array" />
	
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
	
	<cffunction name="getJoinTo" returntype="array" access="public" output="false" hint="Returns the array of properties the type joins to">
		<cfargument name="stProps" type="struct" required="true" hint="The metadata of they type properties" />
		
		<cfset var aResult = arraynew(1) />
		<cfset var thisprop = "" />
		<cfset var otherprop = "" />
		<cfset var stJoin = structnew() />
		
		<cfloop collection="#arguments.stProps#" item="thisprop">
			<cfif listcontains("array,uuid",arguments.stProps[thisprop].metadata.type) and structkeyexists(arguments.stProps[thisprop].metadata,"ftJoin")>
				<cfloop list="#arguments.stProps[thisprop].metadata.ftJoin#" index="othertype">
					<cfset stJoin = structnew() />
					<cfset stJoin.property = thisprop />
					<cfset stJoin.contenttype = othertype />
					<cfset stJoin.type = stProps[thisprop].metadata.type />
					<cfset arrayappend(aResult,stJoin) />
				</cfloop>
			</cfif>
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
				<cfparam name="stThis.ftType" default="" />
				<cfparam name="stThis.ftSeq" default="" />
				<cfparam name="stThis.ftWizardStep" default="" />
				<cfparam name="stThis.ftFieldSet" default="" />
				<cfparam name="stThis.bDeprecated" default="false" />
				
				<!--- Deprecated message --->
				<cfif structkeyexists(stThis,"deprecated")>
					<cfset stThis.bDeprecated = true />
				<cfelseif stThis.bDeprecated>
					<cfset stThis.deprecated = "This property has been deprecated" />
				</cfif>
				
				<cfset arrayappend(aResults,stThis) />
			</cfif>
		</cfloop>
		
		<misc:sort values="#aResults#" result="aResults">
			<cfif len(value1.ftSeq) and len(value2.ftSeq)>
				<cfset sendback = value1.ftSeq - value2.ftSeq />
			<cfelse>
				<cfset sendback = len(value2.ftSeq) - len(value1.ftSeq) />
			</cfif>
		</misc:sort>
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="getWebskinDetails" returntype="array" access="public" output="false" hint="Returns webskin information">
		<cfargument name="typename" type="string" required="true" hint="The typename" />
		
		<cfset var qWebskins = application.stCOAPI[arguments.typename].qWebskins />
		<cfset var stWebskins = application.stCOAPI[arguments.typename].stWebskins />
		<cfset var thisrole = "" />
		<cfset var oRole = createobject("component",application.stCOAPI.farRole.packagepath) />
		<cfset var aResult = arraynew(1) />
		<cfset var includethiswebskin = true />
		
		<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />
		
		<cfquery dbtype="query" name="qWebskins">
			select		*, lower(displayname) as lowername
			from		qWebskins
			order by	lowername
		</cfquery>
		
		<misc:map values="#qWebskins#" resulttype="array" result="aResult">
			<!--- Webskin location --->
			<cfif refindnocase("[\\/]core[\\/]webskin",value.path)>
				<cfset value.location = "Core" />
			<cfelseif refindnocase("[\\/]projects[\\/]#lcase(application.projectdirectoryname)#",value.path)>
				<cfset value.location = "Project" />
			<cfelse><!--- Plugin --->
				<cfloop list="#application.plugins#" index="thisplugin">
					<cfif refind("plugins[\\/]#thisplugin#[\\/]",value.path)>
						<cfset value.location = thisplugin />
					</cfif>
				</cfloop>
			</cfif>
						
			<cfif not isdefined("application.config.docs.webskinlocations") or not len(application.config.docs.webskinlocations) or listcontainsnocase(application.config.docs.webskinlocations,value.location)>
				<cfset includethiswebskin = true />
				
				<!--- Filter webskin by the configured regex's --->
				<cfloop list="#application.config.docs.rulewebskins#" index="thisregex" delimiters="#chr(10)##chr(13)#">
					<cfset includethiswebskin = includethiswebskin and ((left(thisregex,1) eq "!" and not refindnocase(mid(thisregex,2,len(thisregex)),value.name)) or (left(thisregex,1) neq "!" and refindnocase(thisregex,value.name)))>
				</cfloop>
				
				<!--- If it passed the filter, add it --->
				<cfif includethiswebskin>
					<!--- Webskin permissions --->
					<cfset value.roles = "" />
					<cfloop list="#oRole.getAllRoles()#" index="thisrole">
						<cfif oRole.checkWebskin(role=thisrole,type=arguments.typename,webskin=value.name)>
							<cfset value.roles = listappend(value.roles,oRole.getLabel(thisrole)) />
						</cfif>
					</cfloop>
					
					<!--- Cache status --->
					<cfset value.cachestatus = stWebskins[listfirst(value.name,'.')].cachestatus />
					
					<!--- Generic webskin? --->
					<cfif findnocase("/webskin/types/",value.path)>
						<cfset value.bGeneric = 1 />
					<cfelse>
						<cfset value.bGeneric = 0 />
					</cfif>
					
					<cfset sendback[1] = duplicate(value) />
				</cfif>
			</cfif>
		</misc:map>
		
		<cfreturn aResult />
	</cffunction>
	
	<cffunction name="getWarnings" returntype="array" access="public" output="false" hint="Returns automatically generated alerts for missing information">
		<cfargument name="stType" type="struct" required="true" hint="Type information" />
		
		<cfset aResults = arraynew(1) />
		
		
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="generateRuleMetadata" returntype="struct" access="public" output="false" hint="Generates and returns information for the specified type">
		<cfargument name="typename" type="string" required="true" hint="The type to generate" />
		
		<cfset var stType = structnew() />
		<cfset var stMD = application.stCOAPI[arguments.typename] />
		
		<cfset stType.objectid = createuuid() />
		<cfset stType.typename = "docRule" />
		
		<cfset stType.name = arguments.typename />
		<cfset stType.bDocument = iif(structkeyexists(stMD,"bDocument"),"stMD.bDocument","1") />
		<cfset stType.bDeprecated = iif(structkeyexists(stMD,"bDeprecated"),"stMD.bDeprecated","0") />
		<cfset stType.displayname = iif(structkeyexists(stMD,"displayname"),"stMD.displayname","thistype") />
		<cfset stType.hint = iif(structkeyexists(stMD,"hint"),"stMD.hint",de("")) />
		<cfset stType.filepath = stMD.path />
		<cfset stType.packagepath = stMD.packagepath />
		<cfset stType.description = iif(structkeyexists(stMD,"description"),"stMD.description",de("")) />
		<cfset stType.bSystem =  iif(structkeyexists(stMD,"bSystem"),"stMD.bSystem",de("false")) />
		<cfset stType.bObjectBroker = stMD.bObjectBroker />
		<cfset stType.objectbrokermaxobjects = stMD.objectbrokermaxobjects />
		
		<!--- Deprecated message --->
		<cfif structkeyexists(stThis,"deprecated")>
			<cfset stThis.bDeprecated = true />
		<cfelseif stThis.bDeprecated>
			<cfset stThis.deprecated = "This rule has been deprecated" />
		</cfif>
		
		<!--- Extends --->
		<cfset stType.aExtends = getExtends(getMetadata(createobject("component",stMD.packagepath))) />
		
		<!--- Properties --->
		<cfset stType.aProperties = getPropertyDetails(stMD.stProps) />
		
		<!--- Joins --->
		<cfset stType.aJoinTo = getJoinTo(stMD.stProps) />
		
		<!--- Webskins --->
		<cfset stType.aWebskins = getWebskinDetails(arguments.typename) />
		
		<!--- Warnings --->
		<cfset stType.aWarnings = getWarnings(stType) />
		
		<cfreturn stType />
	</cffunction>
	
	<cffunction name="generateRuleQuery" returntype="query" access="public" output="false" hint="Generates and returns rule information">
		<cfset var locationfilter = "" />
		<cfset var q = querynew("typename,displayname,bDocument","varchar,varchar,bit") />
		
		<!--- Location filter --->
		<cfif isdefined("application.config.docs.locations")>
			<cfset locationfilter = "" />
			<cfloop list="#application.config.docs.locations#" index="thislocation">
				<cfswitch expression="#thislocation#">
					<cfcase value="core">
						<cfset locationfilter = listappend(locationfilter,"core\.packages\.rules\.(?!rules)|core\.packages\.rules\.(?!versions)","|") />
					</cfcase>
					<cfcase value="project">
						<cfset locationfilter = listappend(locationfilter,"projects\.[^\.]+\.packages\.rules","|") />
					</cfcase>
					<cfdefaultcase><!--- Plugin --->
						<cfset locationfilter = listappend(locationfilter,"plugins\.#thislocation#\.packages\.rules","|") />
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
			<cfset locationfilter = "(#locationfilter#)" />
		<cfelse>
			<cfset locationfilter = "\.rules" />
		</cfif>
		
		<cfloop collection="#application.stCOAPI#" item="thistype">
			<cfif not thistype eq "container" and refindnocase(locationfilter,"#arraytolist(application.stCOAPI[thistype].aExtends)#,#application.stCOAPI[thistype].packagepath#")>
				<cfset queryaddrow(q) />
				<cfset querysetcell(q,"typename",thistype) />
				<cfif structkeyexists(application.stCOAPI[thistype],"displayname")>
					<cfset querysetcell(q,"displayname",application.stCOAPI[thistype].displayname) />
				<cfelse>
					<cfset querysetcell(q,"displayname",thistype) />
				</cfif>
				<cfif structkeyexists(application.stCOAPI[thistype],"bDocument")>
					<cfset querysetcell(q,"bDocument",application.stCOAPI[thistype].bDocument) />
				<cfelse>
					<cfset querysetcell(q,"bDocument",0) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn q />
	</cffunction>
	
	<cffunction name="getRuleQuery" returntype="query" output="false" access="public" hint="Returns a query containing the name of every rule">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented rules" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		<cfset var qResult = querynew("empty") />
		
		<cfif not isdefined("application.fc.autodoc.rules.q") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.rules = structnew() />
			<cfset application.fc.autodoc.rules.q = generateRuleQuery() />
		</cfif>
		
		<cfset qResult = application.fc.autodoc.rules.q />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getRule" returntype="struct" access="public" output="false" hint="Returns metadata for the specified rule">
		<cfargument name="typename" type="string" required="true" hint="The rule to retrieve" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfif not isdefined("application.fc.autodoc.rules.st.#arguments.typename#") or arguments.refresh>
			<cfparam name="application.fc.autodoc.rules.st" default="#structnew()#" />
			<cfset application.fc.autodoc.rules.st[arguments.typename] = generateRuleMetadata(arguments.typename) />
		</cfif>
		
		<cfreturn duplicate(application.fc.autodoc.rules.st[arguments.typename]) />
	</cffunction>
	
</cfcomponent>