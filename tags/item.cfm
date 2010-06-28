<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Summary item --->
<!--- @@description: Should only be used nested within the a summary or subsection tag --->

<cfif not thistag.HasEndTag>
	<cfthrow message="doc:item must have an end tag" />
</cfif>

<cfparam name="attributes.type" default="simple" /><!--- @@attrhint: Type of item in details section @@options: title,header,standout,simple --->
<cfparam name="attributes.class" default="" />
<cfparam name="attributes.v1" default="" /><!--- Attributes named vN are the details to be included. If none are defined then the generated content is used. --->

<cfif thistag.ExecutionMode eq "end">
	<cfif not len(attributes.v1)>
		<cfexit method="exittag" />
	</cfif>
	<cfset thistag.GeneratedContent = "" />
	
	<cfswitch expression="#attributes.type#">
		<cfcase value="title">
			<cfset variables.class = "DetailTitle" />
		</cfcase>
		<cfcase value="header">
			<cfset variables.class = "DetailHeader" />
		</cfcase>
		<cfcase value="standout">
			<cfset variables.class = "DetailStandout" />
		</cfcase>
		<cfcase value="simple">
			<cfif request.detailalt>
				<cfset variables.class = "DetailSimpleAlt" />
			<cfelse>
				<cfset variables.class = "DetailSimple" />
			</cfif>
			<cfset request.detailalt = not request.detailalt />
		</cfcase>
	</cfswitch>
	
	<cfoutput><tr class="#variables.class# #attributes.class#"></cfoutput>
		
	<cfif attributes.type eq "title">
	
		<cfoutput><td colspan="#request.detailproperties#">#attributes.v1#</td></cfoutput>
		
	<cfelse>
	
		<cfset i = 1 />
		<cfloop condition="structkeyexists(attributes,'v#i#')">
			<cfoutput><td<cfif i eq 1> class="first"</cfif>>#attributes["v#i#"]#</td></cfoutput>
			<cfset i = i + 1 />
		</cfloop>
		
	</cfif>
	
	<cfoutput></tr></cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />