<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Type webskin summary --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />
<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfif not stObj.typename eq "docRule" and (stObj.typename neq "docComponent" or not len(stObj.name)) and len(url.ref)>
	<cfset stObj = getRule(url.ref) />
</cfif>

<cfparam name="arguments.stParam.config" default="#structnew()#" />
<cfparam name="arguments.stParam.config.showfullcacheandsecurity" default="true" />
<cfparam name="arguments.stParam.config.showfullpath" default="false" />

<cfif arraylen(stObj.aWebskins)>
	
	<doc:subsection title="Webskin Summary">
		<doc:details properties="7">
			<cfif structkeyexists(arguments.stParam.config,"showfullcacheandsecurity") and arguments.stParam.config.showfullcacheandsecurity>
				<doc:item type="header" v1="Name" v2="Description" v3="Location" v4="Roles" v5="Cache" v6="Cache by roles" v7="Cache by URL" />
			<cfelse>
				<doc:item type="header" v1="Name" v2="Description" v3="Location" v4="Cache" />
			</cfif>
			
			<cfloop from="1" to="#arraylen(stObj.aWebskins)#" index="i">
				
				<cfif structkeyexists(arguments.stParam.config,"showfullpath") and arguments.stParam.config.showfullpath>
					<cfset thislocation = stObj.aWebskins[1].path />
				<cfelse>
					<cfset thislocation = "<a title='#stObj.aWebskins[1].path#' class='DocLocation Location_#stObj.aWebskins[i].location# Generic_#stObj.aWebskins[i].bGeneric#'>#stObj.aWebskins[i].location#</a>" />
				</cfif>
				
				<!--- Caching status --->
				<cfswitch expression="#stObj.aWebskins[i].cachestatus#">
					<cfcase value="1">
						<cfset thiscachestatus = "<a title='#stObj.aWebskins[i].cachetimeout# min'>Yes</a>" />
					</cfcase>
					
					<cfcase value="0">
						<cfset thiscachestatus = "Auto" />
					</cfcase>
					
					<cfcase value="-1">
						<cfset thiscachestatus = "No" />
					</cfcase>
				</cfswitch>
				
				<cfif structkeyexists(arguments.stParam.config,"showfullcacheandsecurity") and arguments.stParam.config.showfullcacheandsecurity>
					<doc:item type="simple" v1="#stObj.aWebskins[i].displayname#" v2="#stObj.aWebskins[i].description#" v3="#thislocation#" v4="#stObj.aWebskins[i].roles#" v5="#thiscachestatus#" v6="#yesnoformat(stObj.aWebskins[i].cachebyroles)#" v7="#yesnoformat(stObj.aWebskins[i].cachebyurl)#" />
				<cfelse>
					<doc:item type="simple" v1="#stObj.aWebskins[i].displayname#" v2="#stObj.aWebskins[i].description#" v3="#thislocation#" v4="#thiscachestatus#" />
				</cfif>
			
			</cfloop>
			
		</doc:details>
	</doc:subsection>
</cfif>

<cfsetting enablecfoutputonly="false" />