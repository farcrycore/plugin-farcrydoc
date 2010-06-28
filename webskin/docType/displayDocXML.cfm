<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif not structkeyexists(arguments.stParam,"parts") and isdefined("application.config.docs.typesections") and len(application.config.docs.typesections)>
	<cfset arguments.stParam.parts = application.fapi.listIntersection('displayDocFileLocations,displayDocJoins,displayDocWebskins,displayDocSecurity,displayDocPropertyDetails',application.config.docs.typesections) />
<cfelseif not structkeyexists(arguments.stParam,"parts")>
	<cfset arguments.stParam.parts = 'displayDocFileLocations,displayDocJoins,displayDocWebskins,displayDocSecurity,displayDocPropertyDetails' />
</cfif>

<doc:xml />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfparam name="url.refreshvars" default="0" />
	<cfset stObj = getType(url.ref,url.refreshvars) />
</cfif>

<cfoutput>
	<type name="#stObj.name#" bDocument="#stObj.bDocument#" bDeprecated="#stObj.bDeprecated#" packagepath="#stObj.packagepath#" bSystem="#stObj.bSystem#" bUseInTree="#stObj.bUseInTree#" bFriendly="#stObj.bFriendly#" bObjectBroker="#stObj.bObjectBroker#" objectbrokermaxobjects="#stObj.objectbrokermaxobjects#">
		<description><![CDATA[ #stObj.description# ]]></description>
		<extends><cfloop from="1" to="#arraylen(stObj.aExtends)#" index="i">
			<packagepath>#stObj.aExtends[i]#</packagepath></cfloop>
		</extends></cfoutput>

<cfloop list="#arguments.stParam.parts#" index="thispart">
	<skin:view typename="docType" stObject="#stObj#" webskin="#thispart#XML" />
</cfloop>

<cfoutput>
	</type>
</cfoutput>

<cfsetting enablecfoutputonly="false" />