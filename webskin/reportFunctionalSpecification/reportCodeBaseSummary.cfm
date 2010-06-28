<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Code Base Summary --->

<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<doc:section title="Code Base Summary">
	<doc:details properties="3">
		<doc:item type="header" v1="Code Base" v2="Description" v3="Version" />
		
		<!--- Core --->
		<cfsavecontent variable="version"><cfoutput><cfinclude template="/farcry/core/major.version" />.<cfinclude template="/farcry/core/minor.version" />.<cfinclude template="/farcry/core/patch.version" /></cfoutput></cfsavecontent>
		<doc:item type="simple" v1="Core" v2="" v3="#version#" />
		
		<!--- Plugins --->
		<cfloop list="#application.plugins#" index="thisplugin">
			<cfif fileexists(#expandpath('/farcry/plugins/#thisplugin#/install/manifest.cfc')#)>
				<cfset oManifest = createobject("component","farcry.plugins.#thisplugin#.install.manifest") />
				<cfif not structkeyexists(oManifest,"version") and structkeyexists(oManifest,"majorVersion")>
					<cfset oManifest.version = "#oManifest.majorVersion#.#oManifest.minorVersion#.#oManifest.patchVersion#" />
				<cfelse>
					<cfset oManifest.version = "Not specified" />
				</cfif>
			<cfelse>
				<cfset oManifest = structnew() />
				<cfset oManifest.name = thisplugin />
				<cfset oManifest.description = "" />
				<cfset oManifest.version = "Not specified" />
			</cfif>
			
			<cfif fileexists(expandpath("/farcry/plugins/#thisplugin#/major.version"))>
				<cfsavecontent variable="oManifest.version"><cfoutput><cfinclude template="#expandpath('/farcry/plugins/#thisplugin#/major.version')#" />.<cfinclude template="#expandpath('/farcry/plugins/#thisplugin#/minor.version')#" />.<cfinclude template="#expandpath('/farcry/plugins/#thisplugin#/patch.version')#" /></cfoutput></cfsavecontent>
			</cfif>
			
			<doc:item type="simple" v1="#oManifest.name#" v2="#oManifest.name#" v3="#oManifest.version#" />
		</cfloop>
		
		<!--- Project --->
		<cfif fileexists("#application.path.project#/install/manifest.cfc")>
			<cfset oManifest = createobject("component","farcry.projects.#application.projectdirectoryname#.install.manifest") />
			<cfif not structkeyexists(oManifest,"version") and structkeyexists(oManifest,"majorVersion")>
				<cfset oManifest.version = "#oManifest.majorVersion#.#oManifest.minorVersion#.#oManifest.patchVersion#" />
			<cfelse>
				<cfset oManifest.version = "Not specified" />
			</cfif>
		<cfelse>
			<cfset oManifest = structnew() />
			<cfset oManifest.name = "Project" />
			<cfset oManifest.description = "" />
			<cfset oManifest.version = "Not specified" />
		</cfif>
		
		<cfif fileexists(expandpath("#application.path.project#/major.version"))>
			<cfsavecontent variable="oManifest.version"><cfoutput><cfinclude template="#application.path.project#/major.version" />.<cfinclude template="#application.path.project#/minor.version" />.<cfinclude template="#application.path.project#/patch.version" /></cfoutput></cfsavecontent>
		</cfif>
		
		<doc:item type="simple" v1="#oManifest.name#" v2="#oManifest.name#" v3="#oManifest.version#" />
	</doc:details>
</doc:section>

<cfsetting enablecfoutputonly="false" />