<cfcomponent displayname="Scrape" hint="Provides functions for scraping tag, function and scope data from code" output="false">
	
	<cfset variables.newline = "
" />

	<cffunction name="scrapeScopes" access="public" returntype="array" description="Returns an array of scopes" output="false">
		<cfargument name="scopefile" type="String" required="true" hint="The name of the file that contains the scope definitions" />
		
		<cfset var content = "" /><!--- File content --->
		<cfset var aScopes = arraynew(1) /><!--- Array of scope definition strings --->
		<cfset var aResult = arraynew(1) /><!--- Array of scope structs to return --->
		<cfset var i = 0 /><!--- Iterator --->
		
		<cfset arguments.scopefile = expandpath(arguments.scopefile) />
		
		<cffile action="read" file="#arguments.scopefile#" variable="content" />
		<cfset aScopes = scrapeAll(source=content,regex="<cfset (server|application|client|session|request)\.[^>]*>(<!---[^>]*>)?",regexref=1) />
		
		<cfloop from="1" to="#arraylen(aScopes)#" index="i">
			<cfset aResult[i] = structnew() />
			
			<!--- Variable name --->
			<cfset aResult[i].variable = trim(scrape(source=aScopes[i],regex="<cfset ([^=\s]*)",regexref=2)) />
			
			<!--- Default value --->
			<cfset aResult[i].default = trim(scrape(source=aScopes[i],regex="<cfset [^=\s]*=([^>]*)",regexref=2)) />
			<cfif listcontains(""",'",left(aResult[i].default,1))>
				<cfset aResult[i].default = mid(aResult[i].default,2,len(aResult[i].default)-2) />
			</cfif>
			
			<!--- Type --->
			<cfset aResult[i].type = trim(scrape(source=aScopes[i],regex="@@type: (.*?) (?:@@|--->)",regexref=2,default="")) />
			
			<!--- Hint --->
			<cfif not find("@@",aScopes[i])>
				<cfset aResult[i].hint = trim(scrape(source=aScopes[i],regex="<!--- (.*?) --->",regexref=2,default="")) />
			<cfelse>
				<cfset aResult[i].hint = trim(scrape(source=aScopes[i],regex="@@hint: (.*?) (?:@@|--->)",regexref=2,default="")) />
			</cfif>
		</cfloop>
		
		<cfreturn aResult />
	</cffunction>

	<cffunction name="scrapePackages" access="public" returntype="struct" description="Returns a struct containing metadata for each library">
		<cfargument name="folderpath" type="String" required="true" hint="The folders to scrape" />
		<cfargument name="packagepath" type="String" required="true" hint="The package path equivilent to the folderpath" />
		
		<cfset var stResult = structnew() />
		<cfset var qResult = querynew("empty") />
		<cfset var o = "" />
		<cfset var content = "" />
		<cfset var stMetadata = structnew() />
		<cfset var package = "" />
		<cfset var stPackage = structnew() />
		<cfset var key = "" />
		
		<cfset arguments.folderpath = expandpath(arguments.folderpath) />		
		<cfdirectory action="list" directory="#arguments.folderpath#" recurse="true" filter="*.cfc" name="qResult" />
		
		<cfloop query="qResult">
			<cfif listlen(replace(qResult.directory[currentrow],"#arguments.folderpath#",''),"/\") eq 1>
				<cfset package = listfirst(replace(qResult.directory[currentrow],"#arguments.folderpath#",''),"/\") />
				<cfset key = package />
			<cfelse>
				<cfset package = rereplace(replacelist(replace(qResult.directory[currentrow],"#arguments.folderpath#",''),'/,\','.,.'),'^\.','') />
				<cfset key = replace(package,'.','','ALL') />
			</cfif>
		
			<cfparam name="stResult.#key#" default="#structnew()#" />
			<cfset stResult[key].packagepath = "#arguments.packagepath#.#package#" />
			<cfset stResult[key].package = package />
			<cfparam name="stResult.#key#.components" default="#structnew()#" />
			
			<cftry>
				<cfset o = createobject("component","#stResult[key].packagepath#.#listfirst(qResult.name[qResult.currentrow],'.')#") />
				<cffile action="read" file="#qResult.directory[currentrow]#/#qResult.name[currentrow]#" variable="content" />
				
				<cfcatch>
					<cfabort showerror="#stResult[key].packagepath#.#listfirst(qResult.name[currentrow],'.')# - #cfcatch.toString()#">
				</cfcatch>
			</cftry>
			<cfset stMetadata = getMetadata(o) />
			
			<cfset stResult[key].components[listfirst(qResult.name,".")] = scrapeComponent(stMetadata=stMetadata,source=content) />
			
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="scrapeComponent" access="public" returntype="struct" description="Returns a struct containing metadata for a component">
		<cfargument name="stMetadata" type="struct" required="true" hint="Component metadata" />
		<cfargument name="source" type="string" required="false" default="" hint="Component source" />
		
		<cfset var stResult = structnew() />
		<cfset var i = 0 />
		<cfset var functionsource = "" />
		
		<!--- Component package path --->
		<cfset stResult.packagepath = arguments.stMetadata.fullname />
		
		<!--- Component name --->
		<cfif structkeyexists(arguments.stMetadata,"displayname")>
			<cfset stResult.name = arguments.stMetadata.displayname />
		<cfelse>
			<cfset stResult.name = listlast(stResult.packagepath,".") />
		</cfif>
		
		<!--- Component hint? --->
		<cfif structkeyexists(arguments.stMetadata,"hint")>
			<cfset stResult.hint = arguments.stMetadata.hint />
		<cfelse>
			<cfset stResult.hint = "" />
		</cfif>
		
		<!--- Component preloaded location --->
		<cfif structkeyexists(arguments.stMetadata,"scopelocation")>
			<cfset stResult.scopelocation = arguments.stMetadata.scopelocation />
		<cfelse>
			<cfset stResult.scopelocation = "" />
		</cfif>
		
		<!--- Documented? --->
		<cfif structkeyexists(arguments.stMetadata,"bDocument")>
			<cfset stResult.bDocument = arguments.stMetadata.bDocument />
		<cfelse>
			<cfset stResult.bDocument = false />
		</cfif>
		
		<!--- Deprecated? --->
		<cfif structkeyexists(arguments.stMetadata,"bDeprecated")>
			<cfset stResult.bDeprecated = arguments.stMetadata.bDeprecated />
		<cfelse>
			<cfset stResult.bDeprecated = false />
		</cfif>
		
		<!--- Functions --->
		<cfset stResult.functions = structnew() />
		<cfif structkeyexists(arguments.stMetadata,"functions")>
			<cfloop from="1" to="#arraylen(arguments.stMetadata.functions)#" index="i">
				<cfset functionsource = scrape(source=arguments.source,regex="(<!---.*?--->\s*)?<cffunction[^>]*name=[""|']#arguments.stMetadata.functions[i].name#.*?</cffunction>",regexref=1,default="") />
				<cfset stResult.functions[arguments.stMetadata.functions[i].name] = scrapeFunction(stMetadata=arguments.stMetadata.functions[i],scopelocation=stResult.scopelocation,source=functionsource) />
			</cfloop>
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="scrapeFunction" access="public" returntype="struct" description="Returns a struct containing metadata for a function" output="false">
		<cfargument name="stMetadata" type="struct" required="true" hint="Function metadata" />
		<cfargument name="scopelocation" type="String" required="false" hint="The preloaded location of this component" default="" />
		<cfargument name="source" type="string" required="false" default="" hint="The function source code" />
		
		<cfset var stResult = structnew() />
		<cfset var aCommentClose = arraynew(1) /><!--- Possible closing strings for comment variables --->
		<cfset var thisattribute = "" />
		<cfset var aCommentMatches = arraynew(1) /><!--- Comment matches --->
		<cfset var aVarMatches = arraynew(1) /><!--- Variable matches --->
		<cfset var i = 0 /><!--- Loop index --->
		<cfset var j = 0 /><!--- Loop index --->
		<cfset var key = "" /><!--- Comment variable name --->
		<cfset var aCode = arraynew(1) /><!--- Code snippets in value --->
		<cfset var k = 0 /><!--- Loop index ---
		
		<cfset aCommentClose[1] = "@@" />
		<cfset aCommentClose[2] = "--->" />
		
		<!--- Attributes --->
		<cfloop collection="#arguments.stMetadata#" item="thisattribute">
			<cfif issimplevalue(arguments.stMetadata[thisattribute])>
				<cfset stResult[thisattribute] = arguments.stMetadata[thisattribute] />
			</cfif>
		</cfloop>
		
		<cfparam name="stResult.returntype" default="void" />
		<cfparam name="stResult.hint" default="" />
		<cfparam name="stResult.description" default="" />
		<cfparam name="stResult.examples" default="" />
		<cfparam name="stResult.bDocument" default="true" />
		<cfparam name="stResult.bDeprecated" default="false" />
		
		<!--- Find all comments that don't immediately follow a tag element (as the attribute comments do) --->
		<cfset structappend(stResult,scrapeCommentVariables(source=arguments.source,escapeCode=true),true) />
		
		<!--- Clean up examples --->
		<cfset stResult.examples = replacelist(stResult.examples,"<code>,</code>","<pre class='brush: coldfusion'>,</pre>") />
		
		<!--- Arguments --->
		<cfset stResult.arguments = arraynew(1) />
		<cfloop from="1" to="#arraylen(arguments.stMetadata.parameters)#" index="i">
			<cfset arrayappend(stResult.arguments,scrapeArgument(stMetadata=arguments.stMetadata.parameters[i])) />
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeArgument" access="public" returntype="struct" description="Returns a struct containing metadata for an argument" output="false">
		<cfargument name="stMetadata" type="struct" required="true" hint="Component metadata" />
		
		<cfset var stResult = duplicate(arguments.stMetadata) />
		<cfset var thisattribute = "" />
		
		<cfparam name="stResult.type" default="String" />
		<cfparam name="stResult.required" default="false" />
		<cfparam name="stResult.hint" default="" />
		<cfparam name="stResult.options" default="" />
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeLibraries" access="public" returntype="struct" description="Returns a struct containing data for each library, each containing an array of tag structs">
		<cfargument name="folderpath" type="String" required="true" hint="The folders to scrape" />
		<cfargument name="packagepath" type="String" required="true" hint="The mapped path equivilent to the folderpath" />
		<cfargument name="stPrefixes" type="struct" required="true" hint="Defines prefixes for non-default libraries" default="#structnew()#" />
		
		<cfset var stResult = structnew() /><!--- Returned data --->
		<cfset var qResult = querynew("empty") /><!--- cfm files to scrape --->
		<cfset var library = "" /><!--- The current tag library --->
		<cfset var tag = "" /><!--- The current tag --->
		<cfset var content = "" /><!--- Content of file --->
		<cfset var aAttributes = arraynew(1) /><!--- Array of cfparam strings found in file --->
		<cfset var i = 0 /><!--- Iterator --->
		
		<cfset arguments.folderpath = expandpath(arguments.folderpath) />		
		<cfdirectory action="list" directory="#arguments.folderpath#" recurse="true" filter="*.cfm" name="qResult" />
		
		<cfloop query="qResult">
			<cfif listlen(replace(qResult.directory[currentrow],"#arguments.folderpath#",''),"/\") eq 1>
				<cffile action="read" file="#qResult.directory[currentrow]#/#qResult.name[currentrow]#" variable="content" />
				
				<!--- Determine library and tag --->
				<cfset library = listfirst(replace(qResult.directory[currentrow],"#arguments.folderpath#",''),'/\') />
				<cfset tag = listfirst(qResult.name[currentrow],".") />
				
				<!--- Initialise library --->
				<cfparam name="stResult.#library#" default="#structnew()#" />
				<cfparam name="stResult.#library#.tags" default="#structnew()#" />
				<cfset stResult[library].library = library />
				<cfset stResult[library].taglib = "#arguments.packagepath#/#library#" />
				<cfset stResult[library].prefix = getPrefix(library=library,stPrefixes=arguments.stPrefixes) />
				
				<cfset stResult[library].tags[listfirst(qResult.name[currentrow],".")] = scrapeTag(name=listfirst(qResult.name[currentrow],"."),source=content) />
			<cfelseif listlast(qResult.directory[currentrow],"/\") eq "tags">
				<cffile action="read" file="#qResult.directory[currentrow]#/#qResult.name[currentrow]#" variable="content" />
				
				<!--- Determine library and tag --->
				<cfset library = "tags" />
				<cfset tag = listfirst(qResult.name[currentrow],".") />
				
				<!--- Initialise library --->
				<cfparam name="stResult.#library#" default="#structnew()#" />
				<cfparam name="stResult.#library#.tags" default="#structnew()#" />
				<cfset stResult[library].library = library />
				<cfset stResult[library].taglib = arguments.packagepath />
				<cfset stResult[library].prefix = getPrefix(library=library,stPrefixes=arguments.stPrefixes) />
				
				<cfset stResult[library].tags[listfirst(qResult.name[currentrow],".")] = scrapeTag(name=listfirst(qResult.name[currentrow],"."),source=content) />
			</cfif>
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeTag" access="public" returntype="struct" description="Scrapes the tag information from a tag string" output="false">
		<cfargument name="name" type="String" required="true" hint="The name of the tag" />
		<cfargument name="source" type="String" required="true" hint="The tag string" />
		
		<cfset var stResult = structnew() />
		<cfset var aCommentClose = arraynew(1) /><!--- Possible closing strings for comment variables --->
		<cfset var aCommentMatches = arraynew(1) /><!--- Comment matches --->
		<cfset var aVarMatches = arraynew(1) /><!--- Variable matches --->
		<cfset var i = 0 /><!--- Loop index --->
		<cfset var j = 0 /><!--- Loop index --->
		<cfset var key = "" /><!--- Comment variable name --->
		<cfset var aCode = arraynew(1) /><!--- Code snippets in value --->
		<cfset var k = 0 /><!--- Loop index --->
		
		<cfset aCommentClose[1] = "@@" />
		<cfset aCommentClose[2] = "--->" />
		
		<cfset stResult.attributes = arraynew(1) />
		<cfset stResult.name = arguments.name />
		<cfset stResult.description = "" />
		<cfset stResult.examples = "" />
		<cfset stResult.hint = "" />
		<cfset stResult.single = true />
		<cfset stResult.xmlstyle = true />
		<cfset stResult.bdocument = true />
		<cfset stResult.bdeprecated = false />
		
		<!--- Find all comments that don't immediately follow a tag element (as the attribute comments do) --->
		<cfset aCommentMatches = scrapeAll(source=arguments.source,regex="(^|\s)<\!---.*?--->") />
		<cfloop from="1" to="#arraylen(aCommentMatches)#" index="i">
			<cfif find("@@",aCommentMatches[i])>
				<cfset aVarMatches = scrapeAll(source=aCommentMatches[i],regex="@@[^:]+:(.*?)(@@|--->)") />
				<cfloop from="1" to="#arraylen(aVarMatches)#" index="j">
					<cfset key = scrape(source=aVarMatches[j],regex="@@([^:]+):",regexref=2) />
					<cfset stResult[key] = scrape(source=aVarMatches[j],regex="@@[^:]+:(.*?)(?:@@|--->)",regexref=2) />
					<cfset aCode = scrapeAll(source=stResult[key],regex="<code>(.*?)</code>",regexref=2) />
					<cfloop from="1" to="#arraylen(aCode)#" index="k">
						<cfset stResult[key] = replace(stResult[key],aCode[k],htmleditformat(aCode[k])) />
					</cfloop>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- Clean up examples --->
		<cfset stResult.examples = replacelist(stResult.examples,"<code>,</code>","<pre class='brush: coldfusion'>,</pre>") />
		
		<!--- Tag attributes --->
		<cfset aAttributes = scrapeAll(source=arguments.source,regex="(?:<!---)?<cfparam[^>]*name=(?:'|"")attributes\.[^>]*>(?:--->)?(?:<!---[^>]*>)?") />
		<cfloop from="1" to="#arraylen(aAttributes)#" index="i">
			<cfset stResult.attributes[i] = scrapeAttribute(source=aAttributes[i]) />
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeAttribute" access="public" returntype="struct" description="Scrapes attribute information from a cfparam string" output="false">
		<cfargument name="source" type="String" required="true" hint="The cfparam string" />
		
		<cfset var stResult = structnew() /><!--- Attribute metadata --->
		<cfset var aCommentClose = arraynew(1) /><!--- Possible closing strings for comment variables --->
		<cfset var aMatches = arraynew(1) /><!--- Scrape matches --->
		<cfset var i = 0 /><!--- Loop index --->
		
		<cfset aCommentClose[1] = "@@" />
		<cfset aCommentClose[2] = "--->" />
		
		<cfparam name="stResult.options" default="" />
		<cfparam name="stResult.hint" default="" />
		
		<!--- Attribute name --->
		<cfset stResult.name = scrape(source=arguments.source,regex="name=(?:'|"")attributes\.([^'""]*)",regexref=2) />
		
		<!--- Attribute type --->
		<cfset stResult.type = scrape(source=arguments.source,regex="type=(?:'|"")([^'""]*)",regexref=2,default="string") />
		
		<!--- Attribute default --->
		<cfset stResult.default = scrape(source=arguments.source,regex="default=('|"")(.*?)\1(?!\1)",regexref=3,default="") />
		
		<!--- Required? --->
		<cfset stResult.required = (len(scrape(source=arguments.source,regex="default=('|"").*?\1(?!\1)",regexref=1,default=false)) eq 0) />
		
		<!--- Comment variables --->
		<cfset structappend(stResult,scrapeCommentVariables(source=source,remap="attrhint:hint,_:hint"),true) />
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeTagUsage" access="public" returntype="struct" description="Adds usage information to the standard tag struct" output="true">
		<cfargument name="folderpath" type="String" required="true" hint="The folders to scrape" />
		<cfargument name="packagepath" type="String" required="true" hint="The mapped path equivilent to the folderpath" />
		<cfargument name="stTags" type="struct" required="true" hint="The tag struct" />
		
		<cfset var stResult = structnew() /><!--- The results of the tag scrape --->
		<cfset var library = "" /><!--- The tag library --->
		<cfset var qResult = querynew("empty") /><!--- Files to scrape --->
		<cfset var importtag = "" /><!--- Tag library import --->
		<cfset var prefix = "" /><!--- Current tag library prefix --->
		<cfset var content = "" /><!--- File content --->
		<cfset var stTagFile = structnew() /><!--- File information for tag --->
		<cfset var aUsage = arraynew(1) /><!--- Tags used in file --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var tag = "" /><!--- Tag --->
		
		<cfset arguments.folderpath = expandpath(arguments.folderpath) />
		<cfdirectory action="list" directory="#arguments.folderpath#" recurse="true" filter="*.cf?" name="qResult" />
		
		<cfloop query="qResult">
			<cffile action="read" file="#qResult.directory[currentrow]#/#qResult.name[currentrow]#" variable="content" />
		
			<cfloop collection="#arguments.stTags#" item="library">
		
				<cfparam name="stResult.#library#" default="#structnew()#" />
				<cfparam name="stResult.#library#.tags" default="#structnew()#" />
				<cfparam name="stResult.#library#.incorrectprefix" default="#arraynew(1)#" />
				<cfparam name="stResult.#library#.notused" default="#arraynew(1)#" />
				<cfparam name="stResult.#library#.nonexistenttags" default="#arraynew(1)#" />
		
				<cfset importtag = scrape(source=content,regex="<cfimport[^>]*taglib=.#arguments.stTags[library].taglib#[^>]*>",regexref=1) />
				<cfif len(importtag)>
					<cfset prefix = scrape(source=importtag,regex="prefix=['""]([^'""]*)",regexref=2) />
				</cfif>
				
				<cfif len(importtag) and len(prefix)>
					<cfset aUsage = scrapeAll(source=content,regex="<#prefix#:([^\s>]*)>",regexref=2) />
					
					<cfif prefix neq arguments.stTags[library].prefix>
						<cfset arrayappend(stResult[library].incorrectprefix,replace("#qResult.directory[currentrow]#/#qResult.name[currentrow]#",arguments.folderpath,"")) />
					</cfif>
					
					<cfif not arraylen(aUsage)>
						<cfset arrayappend(stResult[library].notused,replace("#qResult.directory[currentrow]#/#qResult.name[currentrow]#",arguments.folderpath,"")) />
					</cfif>
					
					<cfloop from="1" to="#arraylen(aUsage)#" index="i">
						<cfset tag = aUsage[i] />
						
						<cfif structkeyexists(arguments.stTags[library].tags,tag) and compare(arguments.stTags[library].tags[tag].name,tag) neq 0>
							<cfparam name="stResult.#library#.tags.#tag#" default="#structnew()#" />
							<cfparam name="stResult.#library#.tags.#tag#.incorrectcase" default="#arraynew(1)#" />

							<cfset arrayappend(stResult[library].tags[tag].incorrectcase,replace("#qResult.directory[currentrow]#/#qResult.name[currentrow]#",arguments.folderpath,"")) />
						<cfelseif not structkeyexists(arguments.stTags[library].tags,tag)>
							<cfset stTagFile = structnew() />
							<cfset stTagFile.file = replace("#qResult.directory[currentrow]#/#qResult.name[currentrow]#",arguments.folderpath,"") />
							<cfset stTagFile.tag = tag />
							<cfset arrayappend(stResult[library].nonexistenttags,stTagFile) />
						</cfif>
					</cfloop>
				</cfif>
				
			</cfloop>
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="scrapeCommentVariables" access="public" returntype="struct" description="Scrapes all comment variables from the provided string" output="false">
		<cfargument name="source" type="String" required="true" hint="The cfparam string" />
		<cfargument name="remap" type="string" required="false" default="" hint="Remaps variables to new names. Use '_' to indicate the contents of a comment without variable names - converted to array if more than one." />
		<cfargument name="escapeCode" type="boolean" required="false" default="false" hint="Find and escape <code> sections" />
		
		<cfset var stResult = structnew() />
		<cfset var stRemap = structnew() />
		<cfset var thismap = "" />
		<cfset var varName = "" />
		<cfset var varVal = "" />
		<cfset var aCode = arraynew(1) />
		<cfset var k = 0 />
		
		<cfloop list="#arguments.remap#" index="thismap">
			<cfset stRemap[listfirst(thismap,":")] = listlast(thismap,":") />
		</cfloop>
		
		<!--- Comment variables --->
		<cfif find("@@",arguments.source)>
			<cfset aMatches = scrapeAll(source=arguments.source,regex="@@[\w\d]+:(.*?)(?:@@|--->)") />
			<cfloop from="1" to="#arraylen(aMatches)#" index="i">
				<!--- Get variable name and value --->
				<cfset varName = scrape(source=aMatches[i],regex="@@([\w\d]+):",regexref=2) />
				<cfset varVal = scrape(source=aMatches[i],regex="@@[\w\d]+:(.*?)(?:@@|--->)",regexref=2) />
				
				<!--- Find and escape <code> sections --->
				<cfif arguments.escapeCode>
					<cfset aCode = scrapeAll(source=varVal,regex="<code>(.*?)</code>",regexref=2,trim=false) />
					<cfloop from="1" to="#arraylen(aCode)#" index="k">
						<cfset varVal = replace(varVal,aCode[k],cleanCode(code=aCode[k])) />
					</cfloop>
				</cfif>
				
				<cfif structkeyexists(stRemap,varName)>
					<cfset stResult[stRemap[varName]] = varVal />
				<cfelse>
					<cfset stResult[varName] = varVal />
				</cfif>
			</cfloop>
		<cfelseif structkeyexists(stRemap,"_")>
			<cfset stResult[stRemap["_"]] = scrape(source=arguments.source,regex="<!--- (.*) --->",regexref=2,default="") />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="cleanCode" access="public" returntype="string" description="Cleans up code snippets">
		<cfargument name="code" type="string" required="true" hint="The code to clean (without any <code> tags)" />
		
		<cfset var newVal = "" />
		<cfset var bestWhitespace = 100 />
		<cfset var thisWhitespace = 0 />
		<cfset var thisline = "" />
		<cfset var thischar = 0 />
		
		<cfset arguments.code = replace(htmleditformat(arguments.code),chr(9),"    ","ALL") />
		
		<cfloop list="#arguments.code#" index="thisline" delimiters="#chr(10)##chr(13)#">
			<cfif len(trim(thisline))>
				<cfset thisWhitespace = len(scrape(source=thisline,regex="^\s+",trim=false)) />
				<cfset bestWhitespace = min(thisWhitespace,bestWhitespace) />
			</cfif>
		</cfloop>
		
		<cfloop list="#arguments.code#" index="thisline" delimiters="#chr(10)##chr(13)#">
			<cfif len(trim(thisline))>
				<cfset newVal = newVal & rereplace(thisline,"^#repeatstring(" ",bestWhitespace)#","") & variables.newline />
			<cfelse>
				<cfset newVal = newVal & variables.newline />
			</cfif>
		</cfloop>
		
		<cfreturn newVal />
	</cffunction>
	
	<cffunction name="getPrefix" access="public" returntype="String" description="Returns the standard prefix for a library">
		<cfargument name="library" type="String" required="true" hint="The library to convert" />
		<cfargument name="stPrefixes" type="struct" required="true" hint="Folder name to prefix mappings" default="#structnew()#" />
		
		<cfparam name="arguments.stPrefixes.container" default="con" />
		<cfparam name="arguments.stPrefixes.admin" default="admin" />
		<cfparam name="arguments.stPrefixes.formtools" default="ft" />
		<cfparam name="arguments.stPrefixes.security" default="sec" />
		<cfparam name="arguments.stPrefixes.wizard" default="wiz" />
		<cfparam name="arguments.stPrefixes.farcry" default="farcry" />
		<cfparam name="arguments.stPrefixes.webskin" default="skin" />
		<cfparam name="arguments.stPrefixes.navajo" default="nj" />
		
		<cfif structkeyexists(arguments.stPrefixes,arguments.library)>
			<cfreturn arguments.stPrefixes[arguments.library] />
		<cfelse>
			<cfreturn arguments.library />
		</cfif>
	</cffunction>

	<cffunction name="scrape" access="public" returntype="any" description="Returns the first specifed value or the default">
		<cfargument name="source" type="String" required="true" hint="The string to scrape" />
		<cfargument name="regex" type="String" required="false" hint="The regular expression that identifies the string to find" />
		<cfargument name="regexref" type="string" required="false" default="1" hint="The regular expression that identifies the string/s to find. If this value is a list of values, an array is returned." />
		<cfargument name="open" type="String" required="false" hint="The opening string" />
		<cfargument name="close" type="any" required="false" hint="The closing string, or array of strings" />
		<cfargument name="default" type="String" required="false" default="" hint="The default value" />
		<cfargument name="trim" type="boolean" required="false" default="true" hint="Should the result be trimmed" />
		
		<cfset var start = 0 /><!--- Position of start of matched string --->
		<cfset var end = 0 /><!--- Position of end of matched string --->
		<cfset var temppos = 0 /><!--- Temporary position variable --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var stResult = structnew() /><!--- Regex match result --->
		<cfset var thisregexref = "" /><!--- Loop variable for arguments.regexref --->
		<cfset var aReturn = arraynew(1) /><!--- Returnable result --->
		<cfset var pattern = "" /><!--- Java regex pattern --->
		<cfset var matcher = "" /><!--- Java regex matcher --->
		
		<cfif structkeyexists(arguments,"open") and len(arguments.open) and structkeyexists(arguments,"close")><!--- Open and closing strings --->
			
			<cfset start = findnocase(arguments.open,arguments.source) />
			<cfif start>
				<cfif isarray(arguments.close)>
				
					<cfloop from="1" to="#arraylen(arguments.close)#" index="i">
						<cfset temppos = find(arguments.close[i],arguments.source,start+len(arguments.open)) - 1 />
						
						<cfif temppos lt end or end lte 0>
							<cfset end = temppos />
						</cfif>
					</cfloop>
					
				<cfelse>
					
					<cfset end = find(arguments.close,arguments.source,start+len(arguments.open)) - 1 />
					
				</cfif>
				
				<cfif end lte 0>
					<cfset end = len(arguments.source) />
				</cfif>
				
				<cfif arguments.trim>
					<cfreturn trim(mid(arguments.source,start+len(arguments.open),end-start-len(arguments.open))) />
				<cfelse>
					<cfreturn mid(arguments.source,start+len(arguments.open),end-start-len(arguments.open)) />
				</cfif>
			</cfif>
		
		<cfelseif structkeyexists(arguments,"regex") and len(arguments.regex)><!--- Regex --->
			
			<cfset stResult = refindnocase(arguments.regex,arguments.source,1,true) />
			<cfloop list="#arguments.regexref#" index="thisregexref">
				<cfif arraylen(stResult.pos) gte thisregexref and stResult.pos[1]>
					<cfif arguments.trim>
						<cfset arrayappend(aReturn,trim(mid(arguments.source,stResult.pos[thisregexref],stResult.len[thisregexref]))) />
					<cfelse>
						<cfset arrayappend(aReturn,mid(arguments.source,stResult.pos[thisregexref],stResult.len[thisregexref])) />
					</cfif>
				</cfif>
			</cfloop>
			
			<cfif listlen(arguments.regexref) eq 1 and arraylen(aReturn)>
				<cfreturn aReturn[1] />
			<cfelseif arraylen(aReturn)>
				<cfreturn aReturn />
			</cfif>
			
		</cfif>
		
		<cfreturn arguments.default />
	</cffunction>

	<cffunction name="scrapeAll" access="public" returntype="array" description="Returns all matching values">
		<cfargument name="source" type="String" required="true" hint="The string to scrape" />
		<cfargument name="regex" type="String" required="false" hint="The regular expression that identifies the string to find" />
		<cfargument name="regexref" type="numeric" required="false" default="1" hint="The regular expression that identifies the string to find" />
		<cfargument name="open" type="String" required="false" hint="The opening string" />
		<cfargument name="close" type="any" required="false" hint="The closing string, or array of strings" />
		<cfargument name="trim" type="boolean" required="false" default="true" hint="Should the result be trimmed" />
		
		<cfset var start = -1 /><!--- Position of start of matched string --->
		<cfset var end = 0 /><!--- Position of end of matched string --->
		<cfset var temppos = 0 /><!--- Temporary position variable --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var stResult = structnew() /><!--- Regex match result --->
		<cfset var aResult = arraynew(1) /><!--- The resulting array of matching strings --->
		
		<cfif structkeyexists(arguments,"open") and len(arguments.open) and structkeyexists(arguments,"close")><!--- Open and closing strings --->
			
			<cfloop condition="start eq -1 or start gt 0">
			
				<cfif start gt 0>
					<cfset start = findnocase(arguments.open,arguments.source,start) />
				<cfelse>
					<cfset start = findnocase(arguments.open,arguments.source) />
				</cfif>
				
				<cfif start gt 0>
					<cfif isarray(arguments.close)>
					
						<cfloop from="1" to="#arraylen(arguments.close)#" index="i">
							<cfset temppos = find(arguments.close[i],arguments.source,start+len(arguments.open)) - 1 />
							
							<cfif temppos lt end or end lte 0>
								<cfset end = temppos />
							</cfif>
						</cfloop>
						
					<cfelse>
						
						<cfset end = find(arguments.close,arguments.source,start+len(arguments.open)) - 1 />
						
					</cfif>
					
					<cfif end lte 0>
						<cfset end = len(arguments.source) />
					</cfif>
					
					<cfset start = end />
					
					<cfif arguments.trim>
						<cfset arrayappend(aResult,trim(mid(arguments.source,start+len(arguments.open),end-start-len(arguments.open)))) />
					<cfelse>
						<cfset arrayappend(aResult,mid(arguments.source,start+len(arguments.open),end-start-len(arguments.open))) />
					</cfif>
				<cfelse>
				
					<cfbreak />
					
				</cfif>
			</cfloop>
		
		<cfelseif structkeyexists(arguments,"regex") and len(arguments.regex)><!--- Regex --->
		
			<cfloop condition="structisempty(stResult) or stResult.pos[1]">
				
				<cfif structisempty(stResult)>
					<cfset stResult = refindnocase(arguments.regex,arguments.source,1,true) />
				<cfelse>
					<cfset stResult = refindnocase(arguments.regex,arguments.source,stResult.pos[arguments.regexref]+1,true) />
				</cfif>
				
				<cfif arraylen(stResult.pos) gte arguments.regexref and stResult.pos[1]>
					<cfif arguments.trim>
						<cfset arrayappend(aResult,trim(mid(arguments.source,stResult.pos[arguments.regexref],stResult.len[arguments.regexref]))) />
					<cfelse>
						<cfset arrayappend(aResult,mid(arguments.source,stResult.pos[arguments.regexref],stResult.len[arguments.regexref])) />
					</cfif>
				</cfif>
				
			</cfloop>
		
		</cfif>
		
		<cfreturn aResult />
	</cffunction>
	
</cfcomponent>