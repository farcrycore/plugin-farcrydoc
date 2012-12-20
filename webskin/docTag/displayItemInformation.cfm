<cfsetting enablecfoutputonly="true" />

<cfset stItem = arguments.stParam.item />

<cfif len(arguments.stParam.item.description)>
	<cfoutput><p>#replaceURLs(stItem.description)#</p></cfoutput>
<cfelseif len(stItem.hint)>
	<cfoutput><p>#replaceURLs(stItem.hint)#</p></cfoutput>
</cfif>

<cfoutput>
	<h2>Metadata</h2>
	<table class="table table-bordered table-metadata table-striped">
        <tr>
            <th>Single Tag</th>
            <td>#arguments.stParam.item.single#</td>
        </tr>
		<cfif structkeyexists(arguments.stParam.item,"xmlstyle")>
	        <tr>
	            <th>XML Style</th>
	            <td>#arguments.stParam.item.xmlstyle#</td>
	        </tr>
	    </cfif>
    </table><!-- /.table .table-bordered .table-metadata .table-stripped -->
</cfoutput>

<cfif len(stItem.examples)>
	<cfoutput>
		<h2>Examples</h2>
		#cleanExamples(stItem.examples)#
	</cfoutput>
</cfif>

<cfoutput>
	<h2>Attributes</h2>
	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<th>Name</th>
				<th>Type</th>
				<th>Required</th>
				<th>Default</th>
				<th>Options</th>
				<th>Description</th>
			</tr>
		</thead>
		<tbody>
			<cfif arraylen(stItem.attributes)>
				<cfloop from="1" to="#arraylen(arguments.stParam.item.attributes)#" index="i">
					<tr>
						<td>#arguments.stParam.item.attributes[i].name#</td>
						<td>#arguments.stParam.item.attributes[i].type#</td>
						<td>#yesnoformat(arguments.stParam.item.attributes[i].required)#</td>
						<td>#arguments.stParam.item.attributes[i].default#</td>
						<td>#arguments.stParam.item.attributes[i].options#</td>
						<td>#arguments.stParam.item.attributes[i].hint#</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr><td>None</td><td></td><td></td><td></td><td></td><td></td></tr>
			</cfif>
		</tbody>
	</table>
</cfoutput>

<cfsetting enablecfoutputonly="false" />