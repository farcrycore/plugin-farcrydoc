<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<admin:header />
<skin:view typename="docFormTool" webskin="displayTypeDocs" />
<admin:footer />

<cfsetting enablecfoutputonly="false" />