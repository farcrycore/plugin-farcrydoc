<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif not structkeyexists(arguments.stParam,"parts") and isdefined("application.config.docs.typesections") and len(application.config.docs.typesections)>
	<cfset arguments.stParam.parts = application.fapi.listIntersection('displayDocJoins,displayDocWebskins,displayDocPropertyDetails',application.config.docs.typesections) />
<cfelseif not structkeyexists(arguments.stParam,"parts")>
	<cfset arguments.stParam.parts = 'displayDocJoins,displayDocWebskins,displayDocPropertyDetails' />
</cfif>

<doc:xml />

<cfif not stObj.typename eq "docRule" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfparam name="url.refreshdocs" default="0" />
	<cfset stObj = getRule(url.ref,url.refreshdocs) />
</cfif>

<cfoutput>
	<rule name="#stObj.name#" bDocument="#stObj.bDocument#" bDeprecated="#stObj.bDeprecated#"<cfif stObj.bDeprecated> deprecated="#stObj.deprecated#"</cfif> packagepath="#stObj.packagepath#" bSystem="#stObj.bSystem#" bObjectBroker="#stObj.bObjectBroker#" objectbrokermaxobjects="#stObj.objectbrokermaxobjects#">
		<description><![CDATA[ #stObj.description# ]]></description>
		<extends><cfloop from="1" to="#arraylen(stObj.aExtends)#" index="i">
			<packagepath>#stObj.aExtends[i]#</packagepath></cfloop>
		</extends></cfoutput>

<cfloop list="#arguments.stParam.parts#" index="thispart">
	<skin:view typename="docRule" stObject="#stObj#" webskin="#thispart#XML" />
</cfloop>

<cfoutput>
	</rule>
</cfoutput>

<cfsetting enablecfoutputonly="false" />