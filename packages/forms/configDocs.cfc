<cfcomponent displayname="FarCry Docs" hint="Configure how the docs are actually displayed. Mainly for when the documentation is exposed for public consumption." extends="farcry.core.packages.forms.forms" output="false" key="docs">
	<cfproperty ftSeq="1" ftFieldSet="General" ftWizardStep="FarCry Docs"
				name="locations" type="string" ftDefault="" ftLabel="Locations"
				ftType="list" ftListData="getLocations" ftSelectMultiple="true"
				hint="The locations that should be included in the documentation" />
	<cfproperty ftSeq="2" ftFieldSet="General" ftWizardStep="FarCry Docs"
				name="webskinlocations" type="string" ftDefault="" ftLabel="Webskin locations"
				ftType="list" ftListData="getLocations" ftSelectMultiple="true"
				hint="The locations that webskins should be drawn from" />
	
	<cfproperty ftSeq="11" ftFieldSet="Types" ftWizardStep="FarCry Docs"
				name="typewebskins" type="longchar" ftDefault="!displayDoc.*#chr(13)##chr(10)#!displayTypeDoc.*" ftLabel="Webskin filter"
				ftType="longchar"
				ftHint="One regular expression per line" hint="The webskins that should be included in the documentation" />
	
	<cfproperty ftSeq="21" ftFieldSet="Rules" ftWizardStep="FarCry Docs"
				name="rulewebskins" type="longchar" ftDefault="execute.*" ftLabel="Webskin filter"
				ftType="longchar"
				ftHint="One regular expression per line" hint="The webskins that should be included in the documentation" />
	
	<cfproperty ftSeq="31" ftFieldSet="Generated Static Documentation" ftWizardStep="FarCry Docs" ftLabel="Title"
				name="title" type="string" 
				ftHint="Title for this set of documentation" />
	<cfproperty ftSeq="32" ftFieldSet="Generated Static Documentation" ftWizardStep="FarCry Docs" ftLabel="Blurb"
				name="blurb" type="longchar" 
				ftHint="Blurb for documentation home" />
	<cfproperty ftSeq="33" ftFieldSet="Generated Static Documentation" ftWizardStep="FarCry Docs" ftLabel="S3 Bucket"
				name="s3Bucket" type="string" 
				ftHint="The target bucket for pushing the static docs to S3<br>NOTE: existing files at that location are removed" />
	<cfproperty ftSeq="34" ftFieldSet="Generated Static Documentation" ftWizardStep="FarCry Docs" ftLabel="S3 Sub Directory"
				name="s3Directory" type="string"
				ftHint="The target directory for pushing the static docs to S3" />
	<cfproperty ftSeq="35" ftFieldset="Generated Static Documentation" ftLabel="S3 Key ID"
				name="s3KeyID" type="string" />
	<cfproperty ftSeq="36" ftFieldset="Generated Static Documentation" ftLabel="S3 Key Secret"
				name="s3KeySecret" type="string" />
	
	
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
	
	
	<cffunction name="saveURLHTML" returntype="void" output="false" access="public" hint="Gets a URL and saves the returns content to the specified file">
		<cfargument name="type" type="string" required="false" />
		<cfargument name="view" type="string" required="false" />
		<!--- OR --->
		<cfargument name="url" type="string" required="false" />
		
		<cfargument name="destination" type="string" required="true" />
		
		<cfset var html = "" />
		
		<cfif not directoryexists(getdirectoryfrompath(arguments.destination))>
			<cfdirectory action="create" directory="#getdirectoryfrompath(arguments.destination)#" mode="777" />
		</cfif>
		
		<cfif structkeyexists(arguments,"url") and len(arguments.url)>
			<cfif not refind("^http",arguments.url)>
				<cfset arguments.url = "http://" & cgi.http_host & arguments.url />
			</cfif>
			
			<cfhttp url="#arguments.url#" result="html" resolveurl="false" />
			
			<cffile action="write" file="#arguments.destination#" output="#html.filecontent#" mode="777" />
		<cfelse>
			<cfset arguments.typename = arguments.type />
			<cfset structdelete(arguments,"type") />
			<cfset arguments.webskin = arguments.view />
			<cfset structdelete(arguments,"view") />
			<skin:view attributeCollection="#arguments#" r_html="html" />
			
			<cffile action="write" file="#arguments.destination#" output="#html#" mode="777" />
		</cfif>
	</cffunction>
	
	<cffunction name="generateStaticDocumentation" returntype="void" output="false" access="public">
		<cfargument name="destination" type="string" required="false" default="#application.path.defaultfilepath#/staticdocs" />
		
		<cfset var cfhttp = structnew() />
		<cfset var filename = "" />
		<cfset var oSection = application.fapi.getContentType(typename="docTag") />
		<cfset var thissection = "" />
		<cfset var qLibraries = "" />
		<cfset var qItems = "" />
		<cfset var thisloc = "" />
		<cfset var cfhttp = structnew() />
		<cfset var oZip = createObject("component", "farcry.core.packages.farcry.zip") />
		
		<cfsetting requesttimeout="10000" />
		
		<!--- Clean up destination --->
		<cfif directoryexists(arguments.destination)>
			<cfdirectory action="delete" directory="#arguments.destination#" recurse="true" />
		</cfif>
		<cfdirectory action="create" directory="#arguments.destination#" mode="777" />
		
		<!--- Copy static files into destination directory --->
		<cfset filename = "#getTempDirectory()##createuuid()#.zip" />
		<cfzip action="zip" source="#expandpath('/farcry/plugins/farcrydoc/www/static')#" file="#filename#" recurse="true" storePath="true" />
		<cfzip action="unzip" file="#filename#" destination="#arguments.destination#" overwrite="true" />
		<cffile action="delete" file="#filename#" />
		
		<!--- Home page --->
		<cfset saveURLHTML(url=oSection.getURL(section='home',version="dynamic"),destination="#arguments.destination#/#oSection.getURL('home')#") />
		
		<!--- Sections --->
		<cfloop list="tag,component,type,formtool" index="thissection">
			<cfset oSection = application.fapi.getContentType(typename="doc#thissection#") />
			<cfloop list="#application.config.docs.locations#" index="thisloc">
				<cfset saveURLHTML(url=oSection.getURL(section=thissection,version='dynamic',location=thisloc),destination="#arguments.destination#/#oSection.getURL(thissection)#") />
				
				<!--- Libraries --->
				<cfset qLibraries = oSection.getLibraries() />
				<cfloop query="qLibraries">
					<cfset saveURLHTML(url=oSection.getURL(section=thissection,library=qLibraries.library,version='dynamic',location=thisloc),destination="#arguments.destination#/#oSection.getURL(thissection,qLibraries.library)#") />
					
					<!--- Items --->
					<cfset qItems = oSection.getItems(thisloc,qLibraries.library) />
					<cfloop query="qItems">
						<cfset saveURLHTML(url=oSection.getURL(section=thissection,library=qLibraries.library,item=qItems.name,version='dynamic',location=thisloc),destination="#arguments.destination#/#oSection.getURL(thissection,qLibraries.library,qItems.name)#") />
					</cfloop>
				</cfloop>
				
				<cfhttp url="http://#cgi.http_host#/?#session.URLToken#" />
			</cfloop>
		</cfloop>
		
		<!--- Eclipse dictionary --->
		<cfset saveURLHTML(url=oSection.getURL(section='cfeclipse',version='dynamic'),destination="#arguments.destination#/#oSection.getURL('cfeclipse')#") />
		
		<!--- Zip package --->
		<cfset oZip.AddFiles(zipFilePath="#application.path.defaultfilepath#/tmp.zip", directory=arguments.destination, recurse="true", compression=0, savePaths="false") />
		<cffile action="move" source="#application.path.defaultfilepath#/tmp.zip" destination="#arguments.destination#/#oSection.getURL(section='zip')#" mode="777" />
	</cffunction>
	
	<cffunction name="uploadToS3" access="public" output="false" returntype="void" hint="Uploads specified directory to the S3 location defined in the config">
		<cfargument name="destination" type="string" required="false" default="#application.path.defaultfilepath#/staticdocs" />
		
		<cfset var qFiles = "" />
		<cfset var acl = arraynew(1) />
		<cfset var destinationpath = "" />
		<cfset var oFile = createobject("component","farcry.core.packages.farcry.file") />
		<cfset var stMeta = structnew() />
		
		<cfsetting requesttimeout="10000" />
		
		<cfset arguments.destination = replace(arguments.destination,"\","/","ALL") />
		<cfif right(arguments.destination,1) neq "/">
			<cfset arguments.destination = arguments.destination & "/" />
		</cfif>
		
		<!--- First - delete everything that is already at that location --->
		<cfdirectory action="list" directory="s3://#application.config.docs.s3KeyID#:#application.config.docs.s3KeySecret#@#application.config.docs.s3Bucket##application.config.docs.s3Directory#" name="qFiles" />
		<cfloop query="qFiles">
			<cffile action="delete" file="#qFiles.directory##qFiles.name#" />
		</cfloop>
		
		<!--- S3 ACL --->
		<cfset acl[1] = structnew() />
		<cfset acl[1].group = "all" />
		<cfset acl[1].permission = "READ" />
		
		<!--- Upload files --->
		<cfdirectory action="list" directory="#arguments.destination#" type="file" recurse="true" name="qFiles" />
		<cfloop query="qFiles">
			<cfset destinationpath = "s3://#application.config.docs.s3KeyID#:#application.config.docs.s3KeySecret#@#application.config.docs.s3Bucket##application.config.docs.s3Directory##replacenocase(replace(qFiles.directory,'\','/','ALL') & '/',arguments.destination,'/')##qFiles.name#" />
			<cffile action="copy" source="#qFiles.directory#/#qFiles.name#" destination="#destinationpath#" />
			<cfset stMeta = structnew() />
			<cfset stMeta["content_type"] = oFile.getMimeType(qFiles.name) />
			<cfset StoreAddACL(destinationpath,acl) />
			<cfset StoreSetMetadata(destinationpath,stMeta) />
		</cfloop>
	</cffunction>
	
</cfcomponent>