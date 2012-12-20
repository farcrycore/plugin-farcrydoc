<cfsetting enablecfoutputonly="true" />

<cfset stItem = arguments.stParam.item />

<cfif len(stItem.description)>
	<cfoutput><p>#replaceURLs(stItem.description)#</p></cfoutput>
<cfelseif len(stItem.hint)>
	<cfoutput><p>#replaceURLs(stItem.hint)#</p></cfoutput>
</cfif>

<cfoutput>
	<table class="table table-bordered table-metadata table-striped">
      <tr>
        <th>Extends</th>
        <td>
			<cfloop from="1" to="#arraylen(stItem.aExtends)#" index="i">
	            <ul class="unstyled">
	            	<li>
		              <i class="icon-hand-right"></i>#stItem.aExtends[i]#
			</cfloop>
			<cfloop from="1" to="#arraylen(stItem.aExtends)#" index="i">
	              </li><!-- /.unstyled -->
	            </ul>
        	</cfloop>
        </td>
      </tr>
      <tr>
        <th>Package Path</th>
        <td>#stItem.packagepath#</td>
      </tr>
      <tr>
        <th>Instantiating</th>
        <td><pre class="linenums prettyprint">&lt;cfset o = application.fapi.getContentType("#stItem.name#") /&gt;</td>
      </tr>
    </table>
	
    <h2>Property Summary</h2>
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>Name</th>
          <th>Label</th>
          <th>Base Type</th>
          <th>Form Tool Type</th>
          <th>Sequence</th>
          <th>Required</th>
        </tr>
      </thead>
      <tbody>
</cfoutput>

<cfloop from="1" to="#arraylen(stItem.aProperties)#" index="i">
	
	<cfoutput>
		<tr>
			<td>
				#stItem.aProperties[i].name#
				<cfif stItem.aProperties[i].bDeprecated><span class="label label-warning">Deprecated</span></cfif>
			</td>
			<td>#stItem.aProperties[i].ftLabel#</td>
			<td>#stItem.aProperties[i].type#</td>
			<td>#stItem.aProperties[i].fttype#</td>
			<td>#stItem.aProperties[i].ftSeq#</td>
			<td>#yesnoformat(listfindnocase(stItem.aProperties[i].ftValidation,"required"))#</td>
		</tr>
	</cfoutput>
	
</cfloop>

<cfoutput>
      </tbody>
    </table>
	
    <h2>Webskin Summary</h2>
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
		  <th>Webskin</th>
          <th>Name &amp; Description</th>
          <th>Location</th>
        </tr>
      </thead>
      <tbody>
</cfoutput>

<cfloop from="1" to="#arraylen(stItem.aWebskins)#" index="i">
	
	<cfoutput>
		<tr>
			<td>#listfirst(stItem.aWebskins[i].name,".")#</td>
			<td>
				#stItem.aWebskins[i].displayname#
				<cfif len(stItem.aWebskins[i].description)><span class="label label-info">#stItem.aWebskins[i].description#</span></cfif>
			</td>
			<td>#stItem.aWebskins[i].path#</td>
		</tr>
	</cfoutput>
	
</cfloop>

<cfoutput>
      </tbody>
    </table>
</cfoutput>

<cfsetting enablecfoutputonly="false" />