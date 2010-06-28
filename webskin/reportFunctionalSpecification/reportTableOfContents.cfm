<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Table of Contents --->

<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfoutput>
	<style type="text/css">
		body * { font-family:Arial, Helvetica, sans-serif; }
		p { width:95% }
			p.documentmeta { font-size:12px; margin: 0 0 0 15px; }
		
		h2.toc_1 { margin-bottom:0; padding-bottom:0; }
		
		ul.toc_2 { list-style-type:none; font-weight:bold; margin-top:5px; padding-top:0; }
	</style>
	
	<h1 class="mainsectiontitle">Table of Contents</h1>
	
	<h2 class="toc_1">Code Base Summary</h2>
	
	<h2 class="toc_1">Content Types</h2>
	<ul class="toc_2">
		<cfloop query="arguments.stParam.types">
			<li>#arguments.stParam.types.label#</li>
		</cfloop>
	</ul>
	
	<h2 class="toc_1">Publishing Rules</h2>
	<ul class="toc_2">
		<cfloop query="arguments.stParam.rules">
			<li>#arguments.stParam.rules.label#</li>
		</cfloop>
	</ul>
</cfoutput>

<cfsetting enablecfoutputonly="false" />