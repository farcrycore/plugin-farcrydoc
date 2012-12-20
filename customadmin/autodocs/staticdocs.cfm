<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<ft:processform action="Generate">
	<cfset application.fapi.getContentType("configDocs").generateStaticDocumentation() />
	<skin:bubble message="Documentation created" tags="success" />
</ft:processform>

<ft:processform action="Upload to S3">
	<cfset application.fapi.getContentType("configDocs").uploadToS3() />
	<skin:bubble message="Documentation uploaded to S3" tags="success" />
</ft:processform>


<admin:header />

<cfoutput>
	<h1>Generate Static Documentation</h1>
</cfoutput>

<ft:form>
	<skin:pop tags="success" start="<ul id='OKMsg'>" end="</ul>">
		<cfoutput>
			<li>
				<cfif len(trim(message.title))><strong>#message.title#</strong></cfif><cfif len(trim(message.title)) and len(trim(message.message))>: </cfif>
				<cfif len(trim(message.message))>#message.message#</cfif>
			</li>
		</cfoutput>
	</skin:pop>
	
	<cfoutput><p>Dynamically documenation can be viewed <a href="#application.fapi.getContentType('docTag').getURL(section='home',version='public')#">here</a>.</p></cfoutput>
	
	<cfif fileexists("#application.path.defaultfilepath#/staticdocs/index.html")>
		<cfoutput><p>Current static documenation can be viewed <a href="#application.url.fileroot#/staticdocs/index.html">here</a>.</p></cfoutput>
	</cfif>
	
	<ft:buttonPanel>
		<ft:button value="Generate" />
		<cfif fileexists("#application.path.defaultfilepath#/staticdocs/index.html")>
			<ft:button value="Upload to S3" />
		</cfif>
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />