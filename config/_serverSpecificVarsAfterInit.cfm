<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:registerCSS id="farcrydoc" baseHREF="/farcry/plugins/farcrydoc/www/css/" lFiles="docs.css,shCore.css,shThemeDefault.css" />
<skin:registerJS id="farcrydoc" baseHREF="/farcry/plugins/farcrydoc/www/js/" lFiles="xregexp.js,shCore.js,shBrushColdFusion.js"><cfoutput>$j(function(){ SyntaxHighlighter.all(); });</cfoutput></skin:registerJS>

<cfsetting enablecfoutputonly="false" />