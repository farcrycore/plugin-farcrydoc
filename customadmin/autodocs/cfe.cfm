<cfsetting enablecfoutputonly="true" />

<cfset oScrape = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.scrape") />
<cfset oGenerateXML = createobject("component","farcry.plugins.farcrydoc.packages.autodoc.CFEDictionary") />

<cfset metadata = structnew() />
<cfset metadata.packages = oScrape.scrapePackages(folderpath='/farcry/core/packages',packagepath='farcry.core.packages') />
<cfset metadata.libraries = oScrape.scrapeLibraries(folderpath='/farcry/core/tags',packagepath='/farcry/core/tags') />

<cfset oGenerateXML.generate(metadata) />

<cfsetting enablecfoutputonly="false" />