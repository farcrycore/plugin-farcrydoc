<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Property summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docFormtool" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getFormtool(url.ref) />
</cfif>

<cfif len(stObj.examples)>
	<doc:subsection title="Examples"><cfoutput>#replacelist(stObj.examples,"<code>,</code>","<pre class='brush: coldfusion'>,</pre>")#</cfoutput></doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />