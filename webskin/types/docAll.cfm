<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type documentation --->
<!--- @@fuAlias: doc --->
<!--- @@viewstack: body --->
<!--- @@viewbinding: type --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/plugins/farcrydoc/tags" prefix="doc" />

<cfset stLocal.oDocType = application.fapi.getContentType(typename="docType") />
<skin:view typename="docType" stObject="#stLocal.oDocType.getType(stObj.name)#" webskin="displayDoc" />
<doc:gentoc selector="##utility" />

<cfsetting enablecfoutputonly="false" />