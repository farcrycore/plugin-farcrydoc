<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: File and image locations --->

<cfset qMetadata = application.stCOAPI[stObj.name].qMetadata />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and isdefined("url.ref") and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfif arraylen(stObj.aFileLocations)>
	
	<doc:subsection title="Missing Files and Images">
		<doc:details properties="3" class="DocAttributes">
			<doc:item type="header" v1="Property" v2="Type" v3="Expected" />
			
			<cfloop from="1" to="#arraylen(stObj.aFileLocations)#" index="i">
				<cfset stLocal.qMissing = getMissingFiles(stObj.name,stObj.aFileLocations[i].property) />
				<cfif stLocal.qMissing.recordcount>
				
					<cfloop query="stLocal.qMissing">
						<doc:item type="simple" v1="#stObj.aFileLocations[i].property#" v2="#stObj.aFileLocations[i].type#" v3="#stLocal.qMissing.filename#" />
					</cfloop>
			
				<cfelse>
				
					<doc:item type="simple" v1="#stObj.aFileLocations[i].property#" v2="#stObj.aFileLocations[i].type#" v3="None missing" />
					
				</cfif>
			</cfloop>
			
		</doc:details>
	</doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />