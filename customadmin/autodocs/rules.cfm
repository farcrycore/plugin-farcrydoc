<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Rule documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<admin:header />
<skin:view typename="docRule" webskin="displayTypeDocs" />
<admin:footer />

<cfsetting enablecfoutputonly="false" />