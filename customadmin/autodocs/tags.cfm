<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<admin:header />
<skin:view typename="docTag" webskin="displayTypeDocs" />
<admin:footer />

<cfsetting enablecfoutputonly="false" />