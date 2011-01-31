<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Initialise this response an XML document --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.force" default="false" />

<cfif thistag.ExecutionMode eq "start" and not isdefined("application.config.docs.css") or application.config.docs.css>
	<skin:htmlHead id="jquery" />
	<skin:htmlHead><cfoutput>
		<link rel="stylesheet" type="text/css" href="/farcry/plugins/farcrydoc/www/css/docs.css">
		<link rel="stylesheet" type="text/css" href="/farcry/plugins/farcrydoc/www/css/shCore.css">
		<link rel="stylesheet" type="text/css" href="/farcry/plugins/farcrydoc/www/css/shThemeDefault.css">
		<script type="text/javascript" src="/farcry/plugins/farcrydoc/www/js/xregexp.js"></script>
		<script type="text/javascript" src="/farcry/plugins/farcrydoc/www/js/shCore.js"></script>
		<script type="text/javascript" src="/farcry/plugins/farcrydoc/www/js/shBrushColdFusion.js"></script>
		<script type="text/javascript">jQ(function(){ SyntaxHighlighter.all(); });</script>
	</cfoutput></skin:htmlHead>
</cfif>

<cfsetting enablecfoutputonly="false" />