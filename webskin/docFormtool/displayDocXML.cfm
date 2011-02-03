<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Formtool documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfparam name="url.refreshvars" default="0" />
	<cfset stObj = getFormtool(url.ref,url.refreshvars) />
</cfif>

<cfoutput>
	<type name="#stObj.name#" bDocument="#stObj.bDocument#" bDeprecated="#stObj.bDeprecated#"<cfif stObj.bDeprecated> deprecated="#stObj.deprecated#"</cfif> packagepath="#stObj.packagepath#">
		<description><![CDATA[ #stObj.description# ]]></description>
		<examples><![CDATA[ #stObj.examples# ]]></examples>
		<extends><cfloop from="1" to="#arraylen(stObj.aExtends)#" index="i">
			<packagepath>#stObj.aExtends[i]#</packagepath></cfloop>
		</extends></cfoutput>
		
		<skin:view typename="docFormtool" stObject="#stObj#" webskin="displayDocPropertiesXML" />

<cfoutput>
	</type>
</cfoutput>

<cfsetting enablecfoutputonly="false" />