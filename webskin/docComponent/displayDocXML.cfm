<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Component documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif (stObj.typename neq "docComponent" or not len(stObj.name)) and isdefined("url.ref") and len(url.ref)>
	<cfparam name="url.refreshdocs" default="0" />
	<cfset stObj = getComponent(url.ref,url.refreshdocs) />
</cfif>

<doc:xml />

<cfoutput>
	<component name="#stObj.name#" hint="#xmlformat(stObj.hint)#" packagepath="#stObj.packagepath#" scopelocation="#stObj.scopelocation#" bDocument="#stObj.bDocument#" bDeprecated="#stObj.bDeprecated#">
		<functions><cfloop list="#listsort(structkeylist(stObj.functions),'textnocase')#" index="thisfunction">
			<function<cfloop collection="#stObj.functions[thisfunction]#" item="thiskey"><cfif issimplevalue(stObj.functions[thisfunction][thiskey]) and not listcontains("description,arguments,examples",thiskey)> #lcase(thiskey)#="#xmlformat(stObj.functions[thisfunction][thiskey])#"</cfif></cfloop>>
				<description><![CDATA[ #stObj.functions[thisfunction].description# ]]></description>
				<examples><![CDATA[ #stObj.functions[thisfunction].examples# ]]></examples>
				<arguments><cfloop from="1" to="#arraylen(stObj.functions[thisfunction].arguments)#" index="thisargument">
					<argument<cfloop collection="#stObj.functions[thisfunction].arguments[thisargument]#" item="thiskey"> #lcase(thiskey)#="#xmlformat(stObj.functions[thisfunction].arguments[thisargument][thiskey])#"</cfloop> /></cfloop>
				</arguments>
			</function></cfloop>
		</functions>
	</component>
</cfoutput>

<cfsetting enablecfoutputonly="false" />