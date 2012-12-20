<cfcomponent hint="Provides functions for generating a CFEclipse dictionary from scraped data" output="false">

	<cffunction name="generate" access="public" returntype="string" description="Generates the required output" output="true">
		<cfargument name="metadata" type="struct" required="true" hint="Struct containing scraped metadata" />
		<cfargument name="return" type="boolean" required="false" default="false" />
		
		<cfset var result = createObject("java","java.lang.StringBuffer").init() />
		<cfset var tmp = "" />
		
		<cfset result.append('<?xml version="1.0" ?><dictionary xmlns="http://www.cfeclipse.org/version1/dictionary" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cfeclipse.org/version1/dictionary.xsd http://cfeclipse.tigris.org/version1/dictionary/dictionary.xsd">') />
		
		<cfif structkeyexists(arguments.metadata,"libraries")>
			<cfset generateTags(arguments.metadata.libraries,result) />
		</cfif>
		
		<cfif structkeyexists(arguments.metadata,"packages")>
			<cfset generateFunctions(arguments.metadata.packages,result) />
		</cfif>
		
		<cfset result.append("<scopes>") />
		
		<cfsavecontent variable="tmp"><cfinclude template="scopes.cfm" /></cfsavecontent>
		<cfset result.append(tmp) />
		
		<cfif structkeyexists(arguments.metadata,"packages")>
			<cfset generateFunctionScopes(arguments.metadata.packages,result) />
		</cfif>
		
		<cfset result.append("</scopes>") />
		<cfset result.append("</dictionary>") />
		
		<cfif arguments.return>
			<cfreturn result.toString() />
		<cfelse>
			<cfcontent type="text/xml" reset="true" />
			<cfoutput>#result.toString()#</cfoutput>
		</cfif>
	</cffunction>
	
	<cffunction name="generateFunctionScopes" access="public" returntype="string" description="Generates the functions element for the dictionary" output="false">
		<cfargument name="stFunctions" type="struct" required="true" hint="The struct containing the scraped function information" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var package = "" /><!--- Library key --->
		<cfset var comp = "" /><!--- Component key --->
		<cfset var func = "" /><!--- Tag key --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfloop collection="#arguments.stFunctions#" item="package">
			<cfloop collection="#arguments.stFunctions[package]#" item="comp">
				<cfif isstruct(arguments.stFunctions[package][comp])>
					<cfloop collection="#arguments.stFunctions[package][comp].functions#" item="func">
						<cfif len(arguments.stFunctions[package][comp].scopelocation)>
							<cfset arguments.result.append("<scope value=""#arguments.stFunctions[package][comp].scopelocation#.#arguments.stFunctions[package][comp].functions[func].name#""></scope>") />
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn arguments.result />
	</cffunction>

	<cffunction name="generateFunctions" access="public" returntype="string" description="Generates the functions element for the dictionary" output="false">
		<cfargument name="stFunctions" type="struct" required="true" hint="The struct containing the scraped function information" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var package = "" /><!--- Library key --->
		<cfset var comp = "" /><!--- Component key --->
		<cfset var func = "" /><!--- Tag key --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append("<functions>") />
		
		<cfloop collection="#arguments.stFunctions#" item="package">
			<cfloop collection="#arguments.stFunctions[package]#" item="comp">
				<cfif isstruct(arguments.stFunctions[package][comp])>
					<cfloop collection="#arguments.stFunctions[package][comp].functions#" item="func">
						<cfif len(arguments.stFunctions[package][comp].scopelocation)>
							<cfset generateFunction(componentpath="#arguments.stFunctions[package][comp].scopelocation#",stFunction=arguments.stFunctions[package][comp].functions[func],result=arguments.result) />
						<cfelse>
							<cfset generateFunction(componentpath="#arguments.stFunctions[package][comp].packagepath#",stFunction=arguments.stFunctions[package][comp].functions[func],result=arguments.result) />
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfset arguments.result.append("</functions>") />

		<cfreturn arguments.result />
	</cffunction>

	<cffunction name="generateFunction" access="public" returntype="string" description="Generates a function element for the dictionary" output="false">
		<cfargument name="componentpath" type="string" required="true" hint="The function's package" />
		<cfargument name="stFunction" type="struct" required="true" hint="The function metadata" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append('<function creator="8" name="#arguments.stFunction.name#" returns="#arguments.stFunction.returntype#">') />
		<cfset arguments.result.append('<help><![CDATA[#arguments.stFunction.hint#]]></help>') />
				
		<cfloop from="1" to="#arraylen(arguments.stFunction.arguments)#" index="i">
			<cfset generateArgument(stArg=arguments.stFunction.arguments[i],result=arguments.result) />
		</cfloop>
				
		<cfset arguments.result.append("</function>") />
		
		<cfreturn arguments.result />
	</cffunction>

	<cffunction name="generateArgument" access="public" returntype="string" description="Generates an argument element for the dictionary" output="false">
		<cfargument name="stArg" type="struct" required="true" hint="The argument metadata" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append('<parameter name="#arguments.stArg.name#" type="#arguments.stArg.type#" required="') />
		
		<cfif arguments.stArg.required>
			<cfset arguments.result.append('true') />
		<cfelse>
			<cfset arguments.result.append('false') />
		</cfif>
		
		<cfset arguments.result.append('">') />
		
		<cfset arguments.result.append('<help><![CDATA[#arguments.stArg.hint#]]></help>') />
		
		<cfif listlen(arguments.stArg.options)>
			<cfset arguments.result.append('<values') />
			
			<cfif structkeyexists(arguments.stArg,'default')>
				<cfset arguments.result.append(' default="#xmlformat(arguments.stArg.default)#"') />
			</cfif>
			
			<cfloop list="#arguments.stArg.options#" index="i">
				<cfset arguments.result.append('<value option="#xmlformat(i)#" />') />
			</cfloop>
			
			<cfset arguments.result.append('</values>') />
		<cfelse>
			<cfset arguments.result.append('<values') />
			
			<cfif structkeyexists(arguments.stArg,'default')>
				<cfset arguments.result.append(' default="#xmlformat(arguments.stArg.default)#"') />
			</cfif>
			
			<cfset arguments.result.append(' />') />
		</cfif>
			
		<cfset arguments.result.append('</parameter>') />
		
		<cfreturn arguments.result />
	</cffunction>
	
	<cffunction name="generateTags" access="public" returntype="string" description="Generates the tags element for the dictionary" output="false">
		<cfargument name="stTags" type="struct" required="true" hint="The struct containing the scraped tag information" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var library = "" /><!--- Library key --->
		<cfset var tag = "" /><!--- Tag key --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append('<tags>') />
		
		<cfloop collection="#arguments.stTags#" item="library">
			<cfloop collection="#arguments.stTags[library].tags#" item="tag">
				<cfset generateTag(prefix=arguments.stTags[library].prefix,stTag=arguments.stTags[library].tags[tag],result=arguments.result) />
			</cfloop>
		</cfloop>
			
		<cfset arguments.result.append('</tags>') />
		
		<cfreturn arguments.result />
	</cffunction>

	<cffunction name="generateTag" access="public" returntype="string" description="Generates a tag element for the dictionary" output="false">
		<cfargument name="prefix" type="string" required="true" hint="The tag's library prefix" />
		<cfargument name="stTag" type="struct" required="true" hint="The tag metadata" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append('<tag creator="8" name="#arguments.prefix#:#arguments.stTag.name#" single="') />
		
		<cfif arguments.stTag.single>
			<cfset arguments.result.append('true') />
		<cfelse>
			<cfset arguments.result.append('false') />
		</cfif>
		
		<cfset arguments.result.append('" xmlstyle="') />
		
		<cfif arguments.stTag.xmlstyle>
			<cfset arguments.result.append('true') />
		<cfelse>
			<cfset arguments.result.append('false') />
		</cfif>
		
		<cfset arguments.result.append('"><help><![CDATA[#arguments.stTag.hint#]]></help>') />
		
		<cfloop from="1" to="#arraylen(arguments.stTag.attributes)#" index="i">
			<cfset generateAttribute(stAttr=arguments.stTag.attributes[i],result=arguments.result) />
		</cfloop>
			
		<cfset arguments.result.append('</tag>') />
		
		<cfreturn arguments.result />
	</cffunction>

	<cffunction name="generateAttribute" access="public" returntype="string" description="Generates an attribute element for the dictionary" output="false">
		<cfargument name="stAttr" type="struct" required="true" hint="The attribute metadata" />
		<cfargument name="result" type="any" required="false" />
		
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfif not structkeyexists(arguments,"result")>
			<cfset arguments.result = createObject("java","java.lang.StringBuffer").init() />
		</cfif>
		
		<cfset arguments.result.append('<parameter name="#arguments.stAttr.name#" type="#arguments.stAttr.type#" required="') />
		
		<cfif arguments.stAttr.required>
			<cfset arguments.result.append('true') />
		<cfelse>
			<cfset arguments.result.append('false') />
		</cfif>
		
		
		<cfset arguments.result.append('"><help><![CDATA[#arguments.stAttr.hint#]]></help>') />
		
		<cfif listlen(arguments.stAttr.options)>
			<cfset arguments.result.append('<values') />
			
			<cfif structkeyexists(arguments.stAttr,'default')>
				<cfset arguments.result.append(' default="#xmlformat(arguments.stAttr.default)#"') />
			</cfif>
			
			<cfset arguments.result.append(">")>
			
			<cfloop list="#arguments.stAttr.options#" index="i">
				<cfset arguments.result.append('<value option="#xmlformat(i)#" />') />
			</cfloop>
			
			<cfset arguments.result.append('</values>') />
		<cfelse>
			<cfset arguments.result.append('<values') />
			
			<cfif structkeyexists(arguments.stAttr,'default')>
				<cfset arguments.result.append(' default="#xmlformat(arguments.stAttr.default)#"') />
			</cfif>
			
			<cfset arguments.result.append(' />') />
		</cfif>
				
		<cfset arguments.result.append('</parameter>') />
		
		<cfreturn arguments.result />
	</cffunction>

</cfcomponent>