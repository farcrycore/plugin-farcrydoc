<cfsetting enablecfoutputonly="true" />
<!--- @@cachestatus: 1 --->

<!--- CFE dictionary --->
<cfset oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
<cfset oGenerateXML = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.CFEDictionary") />
<cfset metadata = structnew() />
<cfset stTags = application.fapi.getContentType("docTag").getTagData() />
<cfset stComponents = application.fapi.getContentType("docComponent").getComponentData() />

<cfset metadata.packages = structnew() />
<cfset metadata.libraries = structnew() />

<cfloop list="#application.config.docs.locations#" index="thislocation">
	<cfif structkeyexists(stComponents,thislocation)>
		<cfloop collection="#stComponents[thislocation]#" item="k">
			<cfif structkeyexists(metadata.packages,k)>
				<cfset structappend(metadata.packages[k],stComponents[thislocation][k],false) />
			<cfelse>
				<cfset metadata.packages[k] = stComponents[thislocation][k] />
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif structkeyexists(stTags,thislocation)>
		<cfloop collection="#stTags[thislocation]#" item="k">
			<cfif structkeyexists(metadata.libraries,k)>
				<cfset structappend(metadata.libraries[k],stTags[thislocation][k],false) />
			<cfelse>
				<cfset metadata.libraries[k] = stTags[thislocation][k] />
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfset xml = oGenerateXML.generate(metadata,true).toString() />
<cfset bundle = xmltransform(xml,expandpath("/farcry/plugins/farcrydoc/packages/autodoc/textmatebundle.xsl")) />

<cfheader name="Content-Disposition" value="inline; filename=textmate.xml" />
<cfcontent type="text/xml" variable="#ToBinary( ToBase64( bundle ) )#" reset="Yes">

<cfsetting enablecfoutputonly="false" />