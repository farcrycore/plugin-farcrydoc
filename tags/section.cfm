<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Main section --->
<!--- @@description:  --->

<cfif not thistag.HasEndTag>
	<cfthrow message="section must have an end tag" />
</cfif>

<cfparam name="attributes.title" /><!--- The section title --->
<cfparam name="attributes.description" default="" /><!--- The section description --->
<cfparam name="attributes.anchor" default="#rereplace(attributes.title,'[^\w]','','ALL')#" /><!--- The anchor for this section. Defaults to the title with all non alphanumeric stripped out. --->

<cfif thistag.ExecutionMode eq "start">
	<cfoutput>
		<div class="DocSection">
			<h1 id="#attributes.anchor#" class="SectionTitle">#attributes.title#</h1>
			<cfif len(attributes.description)>
				<p class="CParagraph">#attributes.description#</p>
			</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />