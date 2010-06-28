<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Section summary --->
<!--- @@description:  --->

<cfif not thistag.HasEndTag>
	<cfthrow message="section must have an end tag" />
</cfif>

<cfparam name="attributes.properties" default="2" />
<cfparam name="attributes.class" default="" />

<cfif thistag.ExecutionMode eq "start">
	<cfoutput>
		<table class="DocDetails #attributes.class#" cellspacing="0" cellpadding="0" border="0">
			<tbody>
	</cfoutput>
	
	<cfset request.detailproperties = attributes.properties />
	<cfset request.detailalt = false />
<cfelse>
	<cfoutput>
			</tbody>
		</table>
	</cfoutput>
	
	<cfset structdelete(request,"detailproperties") />
	<cfset structdelete(request,"detailalt") />
</cfif>

<cfsetting enablecfoutputonly="false" />