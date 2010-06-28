<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Formtool documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<cfset arguments.stParam.parts = 'displayDocSummary,displayDocProperties' />

<doc:css />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfparam name="url.refreshdocs" default="0" />
	<cfset stObj = getFormtool(url.ref,url.refreshdocs) />
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
	<skin:view typename="docFormtool" stObject="#stObj#" webskin="#thiswebskin#" config="#thisconfig#" />
</cfloop>

</doc:section>

<cfsetting enablecfoutputonly="false" />