<cfcomponent hint="Provides functions for generating a CFEclipse dictionary from scraped data" output="false">

	<cffunction name="generate" access="public" returntype="void" description="Generates the required output" output="true">
		<cfargument name="metadata" type="struct" required="true" hint="Struct containing scraped metadata" />
		
		<cfcontent type="text/xml" />
		<cfoutput><?xml version="1.0" ?>
<dictionary xmlns="http://www.cfeclipse.org/version1/dictionary"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.cfeclipse.org/version1/dictionary.xsd http://cfeclipse.tigris.org/version1/dictionary/dictionary.xsd"
></cfoutput>
		
		<cfif structkeyexists(arguments.metadata,"libraries")>
			<cfoutput>#generateTags(arguments.metadata.libraries)#</cfoutput>
		</cfif>
		
		<cfif structkeyexists(arguments.metadata,"packages")>
			<cfoutput>#generateFunctions(arguments.metadata.packages)#</cfoutput>
		</cfif>
		
		<cfoutput>
	<scopes></cfoutput>
	
		<cfinclude template="scopes.cfm" />
		<cfif structkeyexists(arguments.metadata,"packages")>
			<cfoutput>#generateFunctionScopes(arguments.metadata.packages)#</cfoutput>
		</cfif>
		
		<cfoutput>
	</scopes></cfoutput>
		
		<cfoutput>
</dictionary></cfoutput>
	</cffunction>
	
	<cffunction name="generateFunctionScopes" access="public" returntype="string" description="Generates the functions element for the dictionary" output="false">
		<cfargument name="stFunctions" type="struct" required="true" hint="The struct containing the scraped function information" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var package = "" /><!--- Library key --->
		<cfset var comp = "" /><!--- Component key --->
		<cfset var func = "" /><!--- Tag key --->
		
		<cfloop collection="#arguments.stFunctions#" item="package">
			<cfloop collection="#arguments.stFunctions[package].components#" item="comp">
				<cfloop collection="#arguments.stFunctions[package].components[comp].functions#" item="func">
					<cfif len(arguments.stFunctions[package].components[comp].scopelocation)>
						<cfset sResult = "#sResult#<scope value=""#arguments.stFunctions[package].components[comp].scopelocation#.#arguments.stFunctions[package].components[comp].functions[func].name#""></scope>" />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>

		<cfreturn sResult />
	</cffunction>

	<cffunction name="generateFunctions" access="public" returntype="string" description="Generates the functions element for the dictionary" output="false">
		<cfargument name="stFunctions" type="struct" required="true" hint="The struct containing the scraped function information" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var package = "" /><!--- Library key --->
		<cfset var comp = "" /><!--- Component key --->
		<cfset var func = "" /><!--- Tag key --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			
	<functions></cfoutput></cfsavecontent>
			
		<cfloop collection="#arguments.stFunctions#" item="package">
			<cfloop collection="#arguments.stFunctions[package].components#" item="comp">
				<cfloop collection="#arguments.stFunctions[package].components[comp].functions#" item="func">
					<cfif len(arguments.stFunctions[package].components[comp].scopelocation)>
						<cfset sResult = "#sResult##generateFunction(componentpath="#arguments.stFunctions[package].components[comp].scopelocation#",stFunction=arguments.stFunctions[package].components[comp].functions[func])#" />
					<cfelse>
						<cfset sResult = "#sResult##generateFunction(componentpath="#arguments.stFunctions[package].components[comp].packagepath#",stFunction=arguments.stFunctions[package].components[comp].functions[func])#" />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>

		<cfsavecontent variable="temp"><cfoutput>
	</functions></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">

		<cfreturn sResult />
	</cffunction>

	<cffunction name="generateFunction" access="public" returntype="string" description="Generates a function element for the dictionary" output="false">
		<cfargument name="componentpath" type="string" required="true" hint="The function's package" />
		<cfargument name="stFunction" type="struct" required="true" hint="The function metadata" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			
		<function creator="8" name="#arguments.stFunction.name#" returns="#arguments.stFunction.returntype#">
			<help><![CDATA[
				#arguments.stFunction.hint#
			]]></help></cfoutput></cfsavecontent>
				
		<cfloop from="1" to="#arraylen(arguments.stFunction.arguments)#" index="i">
			<cfset sResult = "#sResult##generateArgument(stArg=arguments.stFunction.arguments[i])#" />
		</cfloop>
				
		<cfsavecontent variable="temp"><cfoutput>
		</function></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">
		
		<cfreturn sResult />
	</cffunction>

	<cffunction name="generateArgument" access="public" returntype="string" description="Generates an argument element for the dictionary" output="false">
		<cfargument name="stArg" type="struct" required="true" hint="The argument metadata" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			<parameter name="#arguments.stArg.name#" type="#arguments.stArg.type#" required="<cfif arguments.stArg.required>true<cfelse>false</cfif>">
				<help><![CDATA[
					#arguments.stArg.hint#
				]]></help></cfoutput></cfsavecontent>
				
				
		<cfif listlen(arguments.stArg.options)>
			<cfsavecontent variable="temp"><cfoutput>
				<values<cfif structkeyexists(arguments.stArg,'default')> default="#xmlformat(arguments.stArg.default)#"</cfif>></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
			
			<cfloop list="#arguments.stArg.options#" index="i">
				<cfsavecontent variable="temp"><cfoutput>
					<value option="#xmlformat(i)#" /></cfoutput></cfsavecontent>
				<cfset sResult = "#sResult##temp#">
			</cfloop>
			
			<cfsavecontent variable="temp"><cfoutput>
				</values></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
		<cfelse>
			
			<cfsavecontent variable="temp"><cfoutput>
				<values<cfif structkeyexists(arguments.stArg,'default')> default="#xmlformat(arguments.stArg.default)#"</cfif> /></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
		</cfif>
			
		<cfsavecontent variable="temp"><cfoutput>
			</parameter></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">
		
		<cfreturn sResult />
	</cffunction>
	
	<cffunction name="generateTags" access="public" returntype="string" description="Generates the tags element for the dictionary" output="false">
		<cfargument name="stTags" type="struct" required="true" hint="The struct containing the scraped tag information" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var library = "" /><!--- Library key --->
		<cfset var tag = "" /><!--- Tag key --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			
	<tags></cfoutput></cfsavecontent>
			
		<cfloop collection="#arguments.stTags#" item="library">
			<cfloop collection="#arguments.stTags[library].tags#" item="tag">
				<cfset sResult = "#sResult##generateTag(prefix=arguments.stTags[library].prefix,stTag=arguments.stTags[library].tags[tag])#" />
			</cfloop>
		</cfloop>
			
		<cfsavecontent variable="temp"><cfoutput>
	</tags></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">

		<cfreturn sResult />
	</cffunction>

	<cffunction name="generateTag" access="public" returntype="string" description="Generates a tag element for the dictionary" output="false">
		<cfargument name="prefix" type="string" required="true" hint="The tag's library prefix" />
		<cfargument name="stTag" type="struct" required="true" hint="The tag metadata" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			
		<tag creator="8" name="#arguments.prefix#:#lcase(arguments.stTag.name)#" single="<cfif arguments.stTag.single>true<cfelse>false</cfif>" xmlstyle="<cfif arguments.stTag.xmlstyle>true<cfelse>false</cfif>">
			<help><![CDATA[
				#arguments.stTag.hint#
			]]></help></cfoutput></cfsavecontent>
			
		<cfloop from="1" to="#arraylen(arguments.stTag.attributes)#" index="i">
			<cfset sResult = "#sResult##generateAttribute(stAttr=arguments.stTag.attributes[i])#" />
		</cfloop>
			
		<cfsavecontent variable="temp"><cfoutput>
		</tag></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">
		
		<cfreturn sResult />
	</cffunction>

	<cffunction name="generateAttribute" access="public" returntype="string" description="Generates an attribute element for the dictionary" output="false">
		<cfargument name="stAttr" type="struct" required="true" hint="The attribute metadata" />
		
		<cfset var sResult = "" /><!--- Generated XML --->
		<cfset var i = 0 /><!--- Iterator --->
		<cfset var temp = "" /><!--- Temporary result of savecontent --->
		
		<cfsavecontent variable="sResult"><cfoutput>
			<parameter name="#arguments.stAttr.name#" type="#arguments.stAttr.type#" required="<cfif arguments.stAttr.required>true<cfelse>false</cfif>">
				<help><![CDATA[
					#arguments.stAttr.hint#
				]]></help></cfoutput></cfsavecontent>
				
			
		<cfif listlen(arguments.stAttr.options)>
			<cfsavecontent variable="temp"><cfoutput>
				<values<cfif structkeyexists(arguments.stAttr,'default')> default="#xmlformat(arguments.stAttr.default)#"</cfif>></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
			
			<cfloop list="#arguments.stAttr.options#" index="i">
				<cfsavecontent variable="temp"><cfoutput>
					<value option="#xmlformat(i)#" /></cfoutput></cfsavecontent>
				<cfset sResult = "#sResult##temp#">
			</cfloop>
		
			<cfsavecontent variable="temp"><cfoutput>
				</values></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
		<cfelse>
			<cfsavecontent variable="temp"><cfoutput>
				<values<cfif structkeyexists(arguments.stAttr,'default')> default="#xmlformat(arguments.stAttr.default)#"</cfif> /></cfoutput></cfsavecontent>
			<cfset sResult = "#sResult##temp#">
		</cfif>
				
		<cfsavecontent variable="temp"><cfoutput>
			</parameter></cfoutput></cfsavecontent>
		<cfset sResult = "#sResult##temp#">
		
		<cfreturn sResult />
	</cffunction>

</cfcomponent>