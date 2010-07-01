<cfcomponent displayname="FarCry Type" hint="Formalised content type information structure" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="name" type="string" />
	<cfproperty name="displayname" type="string" />
	<cfproperty name="filepath" type="string" />
	<cfproperty name="packagepath" type="string" />
	<cfproperty name="hint" type="string" />
	<cfproperty name="description" type="string" />
	<cfproperty name="aExtends" type="array" />
	<cfproperty name="bSystem" type="boolean" />
	<cfproperty name="bUseInTree" type="boolean" />
	<cfproperty name="bFriendly" type="boolean" />
	<cfproperty name="bObjectBroker" type="boolean" />
	<cfproperty name="objectbrokermaxobjects" type="numeric" />
	<cfproperty name="aProperties" type="array" />
	<cfproperty name="aJoinTo" type="array" />
	<cfproperty name="aJoinFrom" type="array" />
	<cfproperty name="aObjectPermissions" type="array" />
	<cfproperty name="aTypePermissions" type="array" />
	<cfproperty name="aFileLocations" type="array" />
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
	
	<cffunction name="getJoinFrom" returntype="array" access="public" output="false" hint="Returns the array of properties that join to this type">
		<cfargument name="typename" type="string" required="true" hint="The typename" />
		
		<cfset var aResult = arraynew(1) />
		<cfset var stProps = structnew() />
		<cfset var thisprop = "" />
		<cfset var otherprop = "" />
		<cfset var stJoin = structnew() />
		
		<cfloop collection="#application.stCOAPI#" item="othertype">
			<cfset stProps = application.stCOAPI[othertype].stProps />
			<cfloop collection="#stProps#" item="thisprop">
				<cfif listcontains("array,uuid",stProps[thisprop].metadata.type) and structkeyexists(stProps[thisprop].metadata,"ftJoin") and listcontains(stProps[thisprop].metadata.ftJoin,arguments.typename)>
					<cfset stJoin = structnew() />
					<cfset stJoin.property = thisprop />
					<cfset stJoin.contenttype = othertype />
					<cfset stJoin.type = stProps[thisprop].metadata.type />
					<cfset arrayappend(aResult,stJoin) />
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfreturn aResult />
	</cffunction>
	
	<cffunction name="getObjectPermissions" returntype="array" access="public" output="false" hint="Returns the object permissions set up for this type">
		<cfargument name="typename" type="string" required="true" hint="The typename" />
		
		<cfset var oPerm = createobject("component",application.stCOAPI.farPermission.packagepath) />
		<cfset var objectperms = oPerm.getAllPermissions(relatedtype=arguments.typename) />
		<cfset var thisperm = "" />
		<cfset var stP = structnew() />
		<cfset var aResult = arraynew(1) />
		
		<cfloop list="#objectperms#" index="thisperm">
			<cfset stPerm = oPerm.getData(objectid=thisperm) />
			<cfset stP = structnew() />
			<cfset stP.name = stPerm.title />
			<cfset stP.shortcut = stPerm.shortcut />
			<cfset arrayappend(aResult,stP) />
		</cfloop>
		
		<cfreturn aResult />
	</cffunction>
	
	<cffunction name="getTypePermissions" returntype="array" access="public" output="false" hint="Returns the type permissions set up for this type, and the roles that have them">
		<cfargument name="typename" type="string" required="true" hint="The typename" />
		
		<cfset var thisperm = "" />
		<cfset var typepart = "" />
		<cfset var permuuid = "" />
		<cfset var oPerm = createobject("component",application.stCOAPI.farPermission.packagepath) />
		<cfset var oRole = createobject("component",application.stCOAPI.farRole.packagepath) />
		<cfset var aResult = arraynew(1) />
		<cfset var stP = structnew() />
		<cfset var thisrole = "" />
		<cfset var stPerm = structnew() />
		<cfset var aResults = arraynew(1) />
		
		<cfloop list="Approve,CanApproveOwnContent,Create,Delete,Edit,RequestApproval" index="thisperm">
			<cfset stP = structnew() />
			
			<cfset typepart = replacelist(arguments.typename,"dmNews,dmFacts,dmEvent,dmLink","news,fact,event,link") />
			
			<cfif oPerm.permissionExists("#typepart##thisperm#")>
				<cfset permuuid = oPerm.getID(name="#typepart##thisperm#") />
			<cfelseif oPerm.permissionExists("generic#thisperm#")>
				<cfset permuuid = oPerm.getID(name="generic#thisperm#") />
			<cfelse>
				<cfset permuuid = "" />
			</cfif>
			
			<cfset stP.roles = "" />
			<cfif len(permuuid)>
				<cfset stPerm = oPerm.getData(objectid=permuuid) />
				<cfloop list="#oRole.getAllRoles()#" index="thisrole">
					<cfif oRole.getRight(role=thisrole, permission=permuuid)>
						<cfset stP.roles = listappend(stP.roles, oRole.getLabel(objectid=thisrole)) />
					</cfif>
				</cfloop>
			<cfelse>
				<cfset stP.roles = "All" />
			</cfif>
			
			<!--- Permission name --->
			<cfif len(permuuid)>
				<cfset stP.name = stPerm.title />
			<cfelse>
				<cfset stP.name = "N/A" />
			</cfif>
			
			<!--- Permission shortcut --->
			<cfif len(permuuid)>
				<cfset stP.shortcut = stPerm.shortcut />
			<cfelse>
				<cfset stP.shortcut = "N/A" />
			</cfif>
			
			<cfset arrayappend(aResults,stP) />
		</cfloop>
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="getFileLocations" returntype="array" access="public" output="false" hint="Returns the directories that file or images are stored in">
		<cfargument name="stProps" type="struct" required="true" hint="The metadata of they type properties" />
		
		<cfset var thisprop = "" />
		<cfset var aResults = arraynew(1) />
		<cfset var stProp = structnew() />
		<cfset var thisroot = "" />
		
		<cfloop collection="#arguments.stProps#" item="thisprop">
			
			<cfif len(arguments.stProps[thisprop].metadata.ftType) and listcontainsnocase("file,image,video",arguments.stProps[thisprop].metadata.ftType)>
				<cfset stProp = structnew() />
				<cfset stProp.type = arguments.stProps[thisprop].metadata.ftType />
				<cfset stProp.property = thisprop />
				
				<!--- File root --->
				<cfswitch expression="#arguments.stProps[thisprop].metadata.ftType#">
					<cfcase value="file">
						
						<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftSecure") and arguments.stProps[thisprop].metadata.ftSecure>
							<cfset thisroot = application.path.securefilepath />
						<cfelse>
							<cfset thisroot = application.path.defaultfilepath />
						</cfif>
						
						<cfset stProp.secure = iif(structkeyexists(arguments.stProps[thisprop].metadata,"ftSecure"),"arguments.stProps[thisprop].metadata.ftSecure",de("false")) />
						
					</cfcase>
					
					<cfcase value="image">
						
						<cfset thisroot = application.path.defaultimagepath />
						
						<!--- Autogeneration --->
						<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftSourceField") and len(arguments.stProps[thisprop].metadata.ftSourceField)>
							<cfset stProp.autogeneratesource = arguments.stProps[thisprop].metadata.ftSourceField />
							
							<!--- Generation type --->
							<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftAutoGenerateType") and len(arguments.stProps[thisprop].metadata.ftAutoGenerateType)>
								<cfset stProp.autogeneratetype = arguments.stProps[thisprop].metadata.ftAutoGenerateType />
							<cfelse>
								<cfset stProp.autogeneratetype = "FitInside" />
							</cfif>
							
							<!--- Generation width --->
							<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftImageWidth") and len(arguments.stProps[thisprop].metadata.ftImageWidth)>
								<cfset stProp.autogeneratewidth = arguments.stProps[thisprop].metadata.ftImageWidth />
							<cfelse>
								<cfset stProp.autogeneratewidth = application.config.image.standardImageWidth />
							</cfif>
							
							<!--- Generation height --->
							<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftImageHeight") and len(arguments.stProps[thisprop].metadata.ftImageHeight)>
								<cfset stProp.autogenerateheight = arguments.stProps[thisprop].metadata.ftImageHeight />
							<cfelse>
								<cfset stProp.autogenerateheight = application.config.image.standardImageHeight />
							</cfif>
						</cfif>
						
					</cfcase>
				</cfswitch>
				
				<!--- Location relative to root --->
				<cfif structkeyexists(arguments.stProps[thisprop].metadata,"ftDestination") and len(arguments.stProps[thisprop].metadata.ftDestination)>
					<cfset stProp.relativepath = arguments.stProps[thisprop].metadata.ftDestination />
				<cfelse>
					<cfset stProp.relativepath = "" />
				</cfif>
				<cfset stProp.fullpath = "#thisroot##stProp.relativepath#" />
				
				<cfset arrayappend(aResults,stProp)>
			</cfif>
			
		</cfloop>
		
		<cfreturn aResults />
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
				<cfloop list="#application.config.docs.typewebskins#" index="thisregex" delimiters="#chr(10)##chr(13)#">
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
	
	<cffunction name="generateTypeMetadata" returntype="struct" access="public" output="false" hint="Generates and returns information for the specified type">
		<cfargument name="typename" type="string" required="true" hint="The type to generate" />
	
		<cfset var stType = structnew() />
		<cfset var stMD = application.stCOAPI[arguments.typename] />
		
		<cfset stType = structnew() />
		<cfset stType.objectid = createuuid() />
		<cfset stType.typename = "docType" />
		
		<cfset stType.name = arguments.typename />
		<cfset stType.bDocument = iif(structkeyexists(stMD,"bDocument"),"stMD.bDocument","0") />
		<cfset stType.bDeprecated = iif(structkeyexists(stMD,"bDeprecated"),"stMD.bDeprecated","0") />
		<cfset stType.displayname = iif(structkeyexists(stMD,"displayname"),"stMD.displayname","thistype") />
		<cfset stType.hint = iif(structkeyexists(stMD,"hint"),"stMD.hint",de("")) />
		<cfset stType.filepath = stMD.path />
		<cfset stType.packagepath = stMD.packagepath />
		<cfset stType.description = iif(structkeyexists(stMD,"description"),"stMD.description",de("")) />
		<cfset stType.bSystem =  iif(structkeyexists(stMD,"bSystem"),"stMD.bSystem",de("false")) />
		<cfset stType.bUseInTree =  iif(structkeyexists(stMD,"bUseInTree"),"stMD.bUseInTree",de("false")) />
		<cfset stType.bFriendly =  iif(structkeyexists(stMD,"bFriendly"),"stMD.bFriendly",de("false")) />
		<cfset stType.bObjectBroker = stMD.bObjectBroker />
		<cfset stType.objectbrokermaxobjects = stMD.objectbrokermaxobjects />
		
		<!--- Extends --->
		<cfset stType.aExtends = getExtends(getMetadata(createobject("component",stMD.packagepath))) />
		
		<!--- Properties --->
		<cfset stType.aProperties = getPropertyDetails(stMD.stProps) />
		
		<!--- Joins --->
		<cfset stType.aJoinTo = getJoinTo(stMD.stProps) />
		<cfset stType.aJoinFrom = getJoinFrom(arguments.typename) />
		
		<!--- Permisssions --->
		<cfset stType.aObjectPermissions = getObjectPermissions(arguments.typename) />
		<cfset stType.aTypePermissions = getTypePermissions(arguments.typename) />
		
		<!--- File paths --->
		<cfset stType.aFileLocations = getFileLocations(stMD.stProps)>
		
		<!--- Webskins --->
		<cfset stType.aWebskins = getWebskinDetails(arguments.typename) />
		
		<!--- Warnings --->
		<cfset stType.aWarnings = getWarnings(stType) />
		
		<cfreturn stType />
	</cffunction>
	
	<cffunction name="generateTypeQuery" returntype="query" access="public" output="false" hint="Generates and returns type information">
		<cfset var locationfilter = "" />
		<cfset var q = querynew("typename,displayname,bDocument","varchar,varchar,bit") />
		
		<!--- Location filter --->
		<cfif isdefined("application.config.docs.locations")>
			<cfset locationfilter = "" />
			<cfloop list="#application.config.docs.locations#" index="thislocation">
				<cfswitch expression="#thislocation#">
					<cfcase value="core">
						<cfset locationfilter = listappend(locationfilter,"core\.packages\.types\.(?!types)|core\.packages\.types\.(?!versions)","|") />
					</cfcase>
					<cfcase value="project">
						<cfset locationfilter = listappend(locationfilter,"projects\.[^\.]+\.packages\.types","|") />
					</cfcase>
					<cfdefaultcase><!--- Plugin --->
						<cfset locationfilter = listappend(locationfilter,"plugins\.#thislocation#\.packages\.types","|") />
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
			<cfset locationfilter = "(#locationfilter#)" />
		<cfelse>
			<cfset locationfilter = "\.types" />
		</cfif>
		
		<cfloop collection="#application.stCOAPI#" item="thistype">
			<cfif refindnocase(locationfilter,"#arraytolist(application.stCOAPI[thistype].aExtends)#,#application.stCOAPI[thistype].packagepath#")>
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
	
	<cffunction name="getTypeQuery" returntype="query" output="false" access="public" hint="Returns a query containing the name of every type">
		<cfargument name="showundocumented" type="boolean" required="false" default="false" hint="Set to true to include undocumented types" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to force metadata cache regeneration" />
		
		<cfset var stAll = structnew() />
		<cfset var qResult = querynew("empty") />
		
		<cfif not isdefined("application.fc.autodoc.types.q") or arguments.refresh>
			<cfparam name="application.fc.autodoc" default="#structnew()#" />
			<cfset application.fc.autodoc.types = structnew() />
			<cfset application.fc.autodoc.types.q = generateTypeQuery() />
		</cfif>
		
		<cfset qResult = application.fc.autodoc.types.q />
		
		<cfif not arguments.showundocumented>
			<cfquery dbtype="query" name="qResult">
				select	*
				from	qResult
				where	bDocument=1
			</cfquery>
		</cfif>
		
		<cfreturn qResult />
	</cffunction>
	
	<cffunction name="getType" returntype="struct" access="public" output="false" hint="Returns metadata for the specified type">
		<cfargument name="typename" type="string" required="true" hint="The type to retrieve" />
		<cfargument name="refresh" type="boolean" required="false" default="false" hint="Set to true to refresh information" />
		
		<cfif not isdefined("application.fc.autodoc.types.st.#arguments.typename#") or arguments.refresh>
			<cfparam name="application.fc.autodoc.types.st" default="#structnew()#" />
			<cfset application.fc.autodoc.types.st[arguments.typename] = generateTypeMetadata(arguments.typename) />
		</cfif>
		
		<cfreturn duplicate(application.fc.autodoc.types.st[arguments.typename]) />
	</cffunction>
	
	
	<cffunction name="getMissingFiles" returntype="query" access="public" output="false" hint="Returns missing files for the specified property">
		<cfargument name="typename" type="string" required="true" hint="The type to retrieve" />
		<cfargument name="property" type="string" required="true" hint="The property to check" />
		
		<cfset var stType = getType(arguments.typename) />
		<cfset var qFiles = querynew("filename","varchar") />
		<cfset var o = createobject("component",stType.packagepath) />
		<cfset var stLocation = structnew() />
		<cfset var qCheck = "" />
		<cfset var stArgs = structnew() />
		<cfset var stObj = structnew() />
		<cfset var thiscol = "" />
		
		<cfset stArgs.typename = arguments.typename />
		<cfset stArgs.lProperties = structkeylist(application.stCOAPI[arguments.typename].stProps) />
		<cfset stArgs["#arguments.property#_neq"] = "" />
		<cfset stArgs.status = "draft,pending,approved" />
		<cfset qCheck = application.fapi.getContentObjects(argumentCollection=stArgs) />
		
		<cfif application.stCOAPI[arguments.typename].stProps[arguments.property].metadata.ftType eq "file">
			<cfloop query="qCheck">
				<cfset stObj = structnew() />
				<cfloop list="#qCheck.columnlist#" index="thiscol">
					<cfset stObj[thiscol] = qCheck[thiscol][qCheck.currentrow] />
				</cfloop>
				<cfset stLocation = o.getFileLocation(stObject=stObj,fieldname=arguments.property) />
				<cfif structkeyexists(stLocation,"message") and stLocation.message eq "File is missing">
					<cfset queryaddrow(qFiles) />
					<cfset querysetcell(qFiles,"filename",stObj[arguments.property]) />
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop query="qCheck">
				<cfif not fileexists("#application.path.imageroot##qCheck[arguments.property][qCheck.currentrow]#")>
					<cfset queryaddrow(qFiles) />
					<cfset querysetcell(qFiles,"filename",stObj[arguments.property]) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn qFiles />
	</cffunction>
	
</cfcomponent>