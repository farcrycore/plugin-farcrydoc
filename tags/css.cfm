<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Initialise this response an XML document --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.force" default="false" />

<cfif thistag.ExecutionMode eq "start" and not structkeyexists(request,"doccss")>
	<skin:htmlHead id="jquery" />
	<skin:htmlHead><cfoutput>
		<link rel="stylesheet" type="text/css" href="/farcrydoc/css/docs.css">
		<link rel="stylesheet" type="text/css" href="/farcrydoc/css/shCore.css">
		<link rel="stylesheet" type="text/css" href="/farcrydoc/css/shThemeDefault.css">
		<script type="text/javascript" src="/farcrydoc/js/xregexp.js"></script>
		<script type="text/javascript" src="/farcrydoc/js/shCore.js"></script>
		<script type="text/javascript" src="/farcrydoc/js/shBrushColdFusion.js"></script>
		<script type="text/javascript">jQ(function(){ SyntaxHighlighter.all(); });</script>
	</cfoutput></skin:htmlHead>
	
	<cfset request.doccss = true />
</cfif>

<cfsetting enablecfoutputonly="false" />