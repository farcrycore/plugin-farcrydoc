<cfsetting enablecfoutputonly="true" />

<cfset stLibrary = arguments.stParam.library />

<cfoutput><h2>#stLibrary.label#</h2></cfoutput>

<cfif isdefined("stLibrary.description") and len(stLibrary.description)>
	<cfoutput><p>#replaceURLs(stLibrary.description)#</p></cfoutput>
<cfelseif isdefined("stLibrary.hint") and len(stLibrary.hint)>
	<cfoutput><p>#replaceURLs(stLibrary.hint)#</p></cfoutput>
</cfif>

<cfif len(stLibrary.examples)>
	<cfoutput>
		<h2>Examples</h2>
		#cleanExamples(stLibrary.examples)#
	</cfoutput>
</cfif>

<cfoutput>
	<h2>Formtool Metadata</h2>
	<table class="table table-bordered table-metadata table-striped">
		<tr>
			<th>Name</th>
			<td>#stLibrary.name#</td>
		</tr>
		<tr>
			<th>Package Path</th>
			<td>#stLibrary.packagepath#</td>
		</tr>
	</table>
</cfoutput>

<cfoutput>
	<h2>Attributes</h2>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th>Name</th>
					<th>Default</th>
					<th>Options</th>
					<th>Required</th>
					<th>Hint</th>
				</tr>
			</thead>
			<tbody>
</cfoutput>

<cfloop from="1" to="#arraylen(stLibrary.aProperties)#" index="i">
	
	<!--- lifestory default value detected, wrap in span and display full default as tooltip --->
	<cfif len(stLibrary.aProperties[i].default) GT 20 and not left(stLibrary.aProperties[i].default,6) eq "<span ">
		<cfset stLibrary.aProperties[i].default = "<span title='#stLibrary.aProperties[i].default#'>#left(stLibrary.aProperties[i].default,17)#...</span>" />
	</cfif>
	
	<cfoutput>
		<tr>
			<td>#stLibrary.aProperties[i].name#</td>
			<td>#stLibrary.aProperties[i].default#</td>
			<td>#replace(stLibrary.aProperties[i].options,",",", ","ALL")#</td>
			<td>#yesnoformat(stLibrary.aProperties[i].required)#</td>
			<td>#stLibrary.aProperties[i].hint#</td>
		</tr>
	</cfoutput>
	
</cfloop>

<cfoutput>
		</tbody>
	</table>
</cfoutput>

<cfsetting enablecfoutputonly="false" />