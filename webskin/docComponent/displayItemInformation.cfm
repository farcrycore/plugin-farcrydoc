<cfsetting enablecfoutputonly="true" />

<cfset stItem = arguments.stParam.item />

<cfoutput><h2>#stItem.label#</h2></cfoutput>

<cfif len(stItem.hint)><cfoutput><p>#replaceURLs(stItem.hint)#</p></cfoutput></cfif>

<cfoutput>
	<h2>Metadata</h2>
	<table class="table table-bordered table-metadata table-striped">
		<cfif isdefined("stItem.scopelocation") and len(stItem.scopelocation)>
	        <tr>
	          <td>Location</td>
	          <td><pre class="linenums prettyprint">#stItem.scopelocation#</pre></td>
	        </tr>
	    <cfelse>
	        <tr>
	          <td>Instantiating</td>
	          <td><pre class="linenums prettyprint"><cfset #stItem.name# = createobject("component","#stItem.packagepath#") /></pre></td>
	        </tr>
	    </cfif>
	</table>
</cfoutput>

<cfoutput><ul class="components-list nav nav-pills"></cfoutput>
<cfloop list="#listsort(structkeylist(stItem.functions),'textnocase')#" index="thisfunction">
	<cfoutput><li><a href="###thisfunction#">#thisfunction#</a></li></cfoutput>
</cfloop>
<cfoutput></ul></cfoutput>

<cfloop list="#listsort(structkeylist(stItem.functions),'textnocase')#" index="thisfunction">
	
	<cfoutput><h2 id="#thisfunction#">#thisfunction#()</h2></cfoutput>
	
	<!--- Deprecation --->
	<cfif stItem.functions[thisfunction].bDeprecated>
		<cfoutput><p class="Deprecated">This #getLabel('librarysingle')# has been deprecated.</p></cfoutput>
	</cfif>
	
	<cfif len(stItem.functions[thisfunction].description)>
		<cfoutput><p>#stItem.functions[thisfunction].description#</p></cfoutput>
	<cfelseif len(stItem.functions[thisfunction].hint)>
		<cfoutput><p>#stItem.functions[thisfunction].hint#</p></cfoutput>
	</cfif>
	
	<cfif len(stItem.functions[thisfunction].examples)>
		<cfoutput>
			<h3>Examples</h2>
			#cleanExamples(stItem.functions[thisfunction].examples)#
		</cfoutput>
	</cfif>
	
	<cfoutput>
		<h3>Arguments</h3>
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
	</cfoutput>
	
	<cfif arraylen(stItem.functions[thisfunction].arguments)>
		<cfloop from="1" to="#arraylen(stItem.functions[thisfunction].arguments)#" index="i">
			<cfif structkeyexists(stItem.functions[thisfunction].arguments[i],"default")>
				<cfset thisdefault = stItem.functions[thisfunction].arguments[i].default />
			<cfelse>
				<cfset thisdefault = "" />
			</cfif>
			<cfoutput>
	            <tr>
	              <td>#stItem.functions[thisfunction].arguments[i].name#</td>
	              <td>#stItem.functions[thisfunction].arguments[i].type#</td>
	              <td>#yesnoformat(stItem.functions[thisfunction].arguments[i].required)#</td>
	              <td>#thisdefault#</td>
	              <td>#stItem.functions[thisfunction].arguments[i].options#</td>
	              <td>#stItem.functions[thisfunction].arguments[i].hint#</td>
	            </tr>
			</cfoutput>
		</cfloop>
	<cfelse>
		<cfoutput><tr><td colspan="6">None</td></tr></cfoutput>
	</cfif>
	
	<cfoutput>
          </tbody>
        </table>
	</cfoutput>
</cfloop>

<cfsetting enablecfoutputonly="false" />