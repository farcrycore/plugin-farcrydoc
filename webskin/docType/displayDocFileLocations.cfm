<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: File and image locations --->

<cfset qMetadata = application.stCOAPI[stObj.name].qMetadata />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfif arraylen(stObj.aFileLocations)>
	<doc:subsection title="File and Image Locations">
		<doc:details properties="4" class="DocAttributes">
			<doc:item type="header" v1="Property" v2="Type" v3="Location" v4="Details" />
			
			<cfif arraylen(stObj.aFileLocations)>
				
				<cfloop from="1" to="#arraylen(stObj.aFileLocations)#" index="i">
					<!--- extra information --->
					<cfset extra = "" />
					<cfloop list="Secure,Autogenerate type,Autogenerate width,Autogenerate height,Autogenerate source" index="morekey">
						<cfif structkeyexists(stObj.aFileLocations[i],replace(morekey," ","ALL"))>
							<cfset extra = listappend(extra,"#morekey#=#stObj.aFileLocations[i][replace(morekey," ","ALL")]#",", ") />
						</cfif>
					</cfloop>
					
					<doc:item type="simple" v1="#stObj.aFileLocations[i].property#" v2="#stObj.aFileLocations[i].type#" v3="#stObj.aFileLocations[i].fullpath#" v4="#extra#" />
				</cfloop>
				
			<cfelse>
				
				<doc:item type="simple" v1="None" v2="" v3="" v4="" />
				
			</cfif>
			
		</doc:details>
	</doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />