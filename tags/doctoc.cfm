<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Table of Contents and Reference Selector --->
<!--- @@single: false --->

<cfif not thistag.HasEndTag>
	<cfthrow message="doctoc must have a closing tag" />
</cfif>

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.urlvar" default="ref" /><!--- The URL variable used to specify which reference is being shown --->
<cfparam name="attributes.showref" default="#structkeyexists(url,attributes.urlvar) and len(url[attributes.urlvar])#" /><!--- Should the table of contents be generated and tag content be included --->
<cfparam name="attributes.showrefresh" default="true" /><!--- Should the refresh link be shown --->
<!--- <cfparam name="attributes.qIndex" type="query" default="#querynew('empty')#" /> ---><!--- Reference index. If specified, a select is shown that allows the user to choose a different reference. --->
<cfparam name="attributes.indexvalue" default="value" /><!--- Index value, used as value in select --->
<cfparam name="attributes.indexlabel" default="label" /><!--- Index label, used in select --->
<cfparam name="attributes.indexgroup" default="" /><!--- Index group, used to group select options --->

<cfparam name="url.#attributes.urlvar#" default="" />
<cfparam name="url.refreshdocs" default="0" />

<cfif thistag.ExecutionMode eq "start">
	<cfif attributes.showref>
		<skin:htmlHead library="jqueryjs" />

		<skin:htmlHead><cfoutput>
			<script type="text/javascript">
				jQ(function(){
					var $toc = jQ("##toc");
					
					jQ("h1").each(function(){
						$toc.append("<li><a href='##"+this.id+"'>"+this.innerHTML+"</a></li>");
					});
					jQ("h2").each(function(){
						$toc.append("<li><a href='##"+this.id+"'>"+this.innerHTML+"</a></li>");
					});
					
					// fixed position definition definition
					var $opt = jQ("##options");
					var homepos = $opt.offset();
			        setInterval(function(){
						var curscrolltop = jQ("body").scrollTop() || jQ("html").scrollTop();
						if (curscrolltop + 0 > homepos.top) {
							$opt.css({
								position:	'fixed',
								top:		0,
								left:		homepos.left
							});
						} else {
							$opt.css({
								position:	'absolute',
								top:		null,
								left:		null
							});
						}
			        },50);
				});
			</script>
		</cfoutput></skin:htmlHead>
	</cfif>
	
	<cfif structkeyexists(attributes,"qIndex")>
		<cfset referenceredirect = application.factory.oUtils.fixURL(removevalues='+#attributes.urlvar#,refreshdocs') />
		<cfoutput>
			<div id="options" style="width:24%;float:left;height:95%;overflow-y:auto;overflow-x:hidden;">
				<select onchange="window.location='#referenceredirect#<cfif find('?',referenceredirect)>&<cfelse>?</cfif>#attributes.urlvar#='+this.value;">
					<option value="">-- NONE --</option>
		</cfoutput>
		
		<cfif len(attributes.indexgroup)>
			<cfoutput query="attributes.qIndex" group="#attributes.indexgroup#">
				<optgroup label="#attributes.qIndex[attributes.indexgroup][attributes.qIndex.currentrow]#">
					<cfoutput><option value="#attributes.qIndex[attributes.indexvalue][attributes.qIndex.currentrow]#"<cfif url[attributes.urlvar] eq attributes.qIndex[attributes.indexvalue][attributes.qIndex.currentrow]> selected="selected"</cfif>>#attributes.qIndex[attributes.indexlabel][attributes.qIndex.currentrow]#</option></cfoutput>
				</optgroup>
			</cfoutput>
		<cfelse>
			<cfloop query="attributes.qIndex">
				<cfoutput><option value="#attributes.qIndex[attributes.indexvalue][attributes.qIndex.currentrow]#"<cfif url[attributes.urlvar] eq attributes.qIndex[attributes.indexvalue][attributes.qIndex.currentrow]> selected="selected"</cfif>>#attributes.qIndex[attributes.indexlabel][attributes.qIndex.currentrow]#</option></cfoutput>
			</cfloop>
		</cfif>
					
		<cfoutput>
				</select>
		</cfoutput>
	</cfif>
	
	<cfif attributes.showrefresh>
		<cfset refreshredirect = application.factory.oUtils.fixURL(removevalues='+refreshdocs') />
		<cfoutput><a href="#refreshredirect#<cfif find('?',refreshredirect)>&<cfelse>?</cfif>refreshdocs=1"><img src="#application.url.webtop#/facade/icon.cfm?icon=reload&size=16" alt="Refresh" /></a></cfoutput>
	</cfif>
	
	<cfif attributes.showrefresh or structkeyexists(attributes,"qIndex")>
		<cfoutput><br /><br /></cfoutput>
	</cfif>
	
	<cfif attributes.showref>
		<cfoutput>
			<h3>Table of contents</h3>
			<ul id="toc"></ul>
		</cfoutput>
	</cfif>
	
	<cfoutput>
		</div>
	</cfoutput>
	
	<cfoutput>
		<div style="margin-left:25%;margin-right:10px;float:left;width:75%" id="reference"><br /><br />
	</cfoutput>
	
	<cfif not attributes.showref>
		<cfoutput></div></cfoutput>
		<cfexit method="exittag" />
	</cfif>
</cfif>

<cfif thistag.ExecutionMode eq "end">
	
	<cfoutput>
		</div>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="false" />
