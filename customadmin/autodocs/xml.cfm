<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:xml />

<cfoutput><documentation></cfoutput>
<skin:view typename="docType" webskin="displayTypeDocsXML" />
<skin:view typename="docRule" webskin="displayTypeDocsXML" />
<skin:view typename="docTag" webskin="displayTypeDocsXML" />
<skin:view typename="docComponent" webskin="displayTypeDocsXML" />
<cfoutput></documentation></cfoutput>

<cfsetting enablecfoutputonly="false" />