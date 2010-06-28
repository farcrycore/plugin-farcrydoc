<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfif not structkeyexists(arguments.stParam,"parts") and isdefined("application.config.docs.typesections") and len(application.config.docs.typesections)>
	<cfset arguments.stParam.parts = application.fapi.listIntersection('displayDocSummary,displayDocPropertySummary,displayDocJoins,displayDocWebskins,displayDocPropertyDetails',application.config.docs.typesections) />
<cfelseif not structkeyexists(arguments.stParam,"parts")>
	<cfset arguments.stParam.parts = 'displayDocSummary,displayDocPropertySummary,displayDocJoins,displayDocWebskins,displayDocPropertyDetails' />
</cfif>

<doc:css />

<cfif not stObj.typename eq "docRule" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfparam name="url.refreshdocs" default="0" />
	<cfset stObj = getRule(url.ref,url.refreshdocs) />
</cfif>

<doc:section title="#stObj.displayname#">

<cfloop list="#arguments.stParam.parts#" index="thispart">
	<cfset thisconfig = structnew() />
	<cfif listlen(thispart,':')>
		<cfset thiswebskin = listfirst(thispart,':') />
		<cfloop list="#listlast(thispart,':')#" delimiters=";" index="thiskey">
			<cfset thisconfig[listfirst(thiskey,"=")] = listlast(thiskey,"=") />
		</cfloop>
	<cfelse>
		<cfset thiswebskin = thispart />
	</cfif>
	<skin:view typename="docRule" stObject="#stObj#" webskin="#thiswebskin#" config="#thisconfig#" />
</cfloop>

</doc:section>

<cfsetting enablecfoutputonly="false" />