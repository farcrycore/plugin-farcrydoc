<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type webskin details --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="../../tags" prefix="doc" />
<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />

<cfparam name="stParam.bGeneric" default="0" /><!--- true: show 'types' webskins, false: show webskins specific to this particular type --->

<doc:css />

<cfif not stObj.typename eq "docType" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getType(url.ref) />
</cfif>

<cfif stParam.bGeneric>
	<cfset stObj = getType("farCOAPI") />
</cfif>

<cfif stParam.bGeneric>
	<cfset thistitle = "Generic templates">
<cfelseif structkeyexists(application.stCOAPI[stObj.name],"displayname")>
	<cfset thistitle = "#stObj.displayname# templates" />
</cfif>

<misc:map values="#stObj.aWebskins#" result="stObj.aWebskins">
	<cfif stParam.bGeneric eq value.bGeneric and refindnocase("[\\/]display(Page|Teaser)",value.path)>
		<cfset sendback[1] = value />
	</cfif>
</misc:map>

<cfif arraylen(stObj.aWebskins)>
	<doc:subsection title="#thistitle#">
	
		<doc:details properties="2" class="DocWideLabel">
		
			<cfloop from="1" to="#arraylen(stObj.aWebskins)#" index="i">
				<doc:item type="simple" v1="#stObj.aWebskins[i].displayname#" v2="#stObj.aWebskins[i].description#" />
			</cfloop>
			
		</doc:details>
	
	</doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />