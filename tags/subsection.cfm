<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Subsection --->
<!--- @@description:  --->

<cfif not thistag.HasEndTag>
	<cfthrow message="section must have an end tag" />
</cfif>

<cfparam name="attributes.title" /><!--- Title for subsection --->
<cfparam name="attributes.anchor" default="#rereplace(attributes.title,'[^\w]','','ALL')#" /><!--- The anchor for this subsection. Defaults to the title with all non alphanumeric stripped out. --->
<cfparam name="attributes.linkbackurl" default="" /><!--- Adds a link to the end of the subsection with this link --->
<cfparam name="attributes.linkbacktext" default="Return" /><!--- Adds a link to the end of the subsection with this text --->

<cfif thistag.ExecutionMode eq "start">
	<cfoutput>
		<div class="DocSubsection">
			<h2 class="DocSubSectionTitle" id="#attributes.anchor#">#attributes.title#</h2>
	</cfoutput>
<cfelse>
	
	<cfif len(attributes.linkbackurl)>
		<cfoutput><div class="DocLinkback"><a href="#attributes.linkbackurl#">#attributes.linkbacktext#</a></div></cfoutput>
	</cfif>
	
	<cfoutput>
		</div>
	</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />