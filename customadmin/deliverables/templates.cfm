<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Template documentation --->
<!--- @@description: Reports on selectable templates --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset qTypes = querynew("typename,displayname","varchar,varchar") />
<cfloop collection="#application.stCOAPI#" item="thistype">
	<cfif findnocase(".types.",application.stCOAPI[thistype].packagepath)>
		<cfset queryaddrow(qTypes) />
		<cfset querysetcell(qTypes,"typename",thistype) />
		<cfif structkeyexists(application.stCOAPI[thistype],"displayname")>
			<cfset querysetcell(qTypes,"displayname",application.stCOAPI[thistype].displayname) />
		<cfelse>
			<cfset querysetcell(qTypes,"displayname",thistype) />
		</cfif>
	</cfif>
</cfloop>

<cfquery dbtype="query" name="qTypes">
	select		*
	from		qTypes
	order by 	displayname asc
</cfquery>

<cfparam name="url.ref" default="" />
<cfparam name="url.refreshvars" default="0" />
<cfset oType = createobject("component",application.stCOAPI.docType.packagepath) />

<admin:header />

<cfoutput><h1>Templates</h1></cfoutput>

<skin:view typename="docType" stObject="#oType.getType('farCOAPI',url.refreshvars)#" webskin="displayDocTemplates" bGeneric="true" />

<cfloop query="qTypes">
	<cfif not qTypes.typename eq "farCOAPI"><skin:view typename="docType" stObject="#oType.getType(qTypes.typename,url.refreshvars)#" webskin="displayDocTemplates" bGeneric="false" /></cfif>
</cfloop>

<admin:footer />

<cfsetting enablecfoutputonly="false" />