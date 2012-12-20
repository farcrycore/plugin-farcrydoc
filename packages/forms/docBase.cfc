<cfcomponent extends="farcry.core.packages.forms.forms" output="false" persistent="false" bAbstract="true">
	
	<cffunction name="getURL" returntype="string" access="public" output="false" hint="Returns a link for use in static docs">
		<cfargument name="section" type="string" required="true" />
		<cfargument name="library" type="string" required="false" />
		<cfargument name="item" type="string" required="false" />
		<cfargument name="version" type="string" required="false" default="static" options="dynamic,static,public" />
		<cfargument name="location" type="string" required="false" default="" hint="Only used if version=dynamic" />
		
		<cfset var urlParameters = structnew() />
		
		<cfif isdefined("url.version")>
			<cfif url.version eq "dynamic">
				<cfset arguments.version = "static" />
			<cfelse>
				<cfset arguments.version = url.version />
			</cfif>
		</cfif>
		<cfif isdefined("url.loc") and len(url.loc)>
			<cfset arguments.location = url.loc />
		</cfif>
		
		<cfif arguments.version eq "static">
			<cfif arguments.section eq "home">
				<cfreturn lcase("index.html") />
			<cfelseif arguments.section eq "cfeclipse">
				<cfreturn lcase("dictionaries/cfeclipse.xml") />
			<cfelseif arguments.section eq "textmate">
				<cfreturn lcase("dictionaries/textmate.xml") />
			<cfelseif arguments.section eq "zip">
				<cfreturn lcase("doc.zip") />
			<cfelse>
				<cfif structkeyexists(arguments,"library")>
					<cfif structkeyexists(arguments,"item")>
						<cfreturn lcase("#arguments.section#-#arguments.library#-#arguments.item#.html") />
					<cfelse>
						<cfreturn lcase("#arguments.section#-#arguments.library#.html") />
					</cfif>
				<cfelse>
					<cfreturn lcase("#arguments.section#.html") />
				</cfif>
			</cfif>
		<cfelse>
			<cfset urlParameters["version"] = arguments.version />
			<cfif len(arguments.location)>
				<cfset urlParameters["location"] = arguments.location />
			</cfif>
			<cfset urlParameters["debug"] = 1 />
			
			<cfif arguments.section eq "home">
				<cfreturn application.fapi.getLink(type="configDocs",view="displayPageHome",stParameters=urlParameters) />
			<cfelseif arguments.section eq "cfeclipse">
				<cfreturn application.fapi.getLink(type="configDocs",view="displayPageCFEclipse",stParameters=urlParameters) />
			<cfelseif arguments.section eq "textmate">
				<cfreturn application.fapi.getLink(type="configDocs",view="displayPageTextmate",stParameters=urlParameters) />
			<cfelseif arguments.section eq "zip">
				<cfreturn "javascript:alert('The zip file is only available from the static generated documentation');" />
			<cfelse>
				<cfif structkeyexists(arguments,"library")>
					<cfif structkeyexists(arguments,"item")>
						<cfset urlParameters["loc"] = arguments.location />
						<cfset urlParameters["lib"] = arguments.library />
						<cfset urlParameters["ref"] = arguments.item />
						<cfreturn application.fapi.getLink(type="doc" & arguments.section,view="displayPageDocumentation",stParameters=urlParameters) />
					<cfelse>
						<cfset urlParameters["loc"] = arguments.location />
						<cfset urlParameters["lib"] = arguments.library />
						<cfreturn application.fapi.getLink(type="doc" & arguments.section,view="displayPageDocumentation",stParameters=urlParameters) />
					</cfif>
				<cfelse>
					<cfset urlParameters["loc"] = arguments.location />
					<cfreturn application.fapi.getLink(type="doc" & arguments.section,view="displayPageDocumentation",stParameters=urlParameters) />
				</cfif>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="cleanExamples" returntype="string" access="public" output="false">
		<cfargument name="text" type="string" required="true" />
		<cfargument name="version" type="string" required="false" default="static" />
		
		<cfset var result = arguments.text />
		<cfset var spaces = "" />
		
		<!--- Clean up code tags --->
		<cfset result = replacelist(result,"<pre>,brush: coldfusion,<code>,</code>","<pre class='linenums prettyprint'>,linenums prettyprint,<pre class='linenums prettyprint'>,</pre>") />
		
		<!--- Convert tabs to 4 spaces --->
		<cfset result = result.replaceAll("\t","    ") />
		
		<!--- Remove empty lines at the start and end of code --->
		<cfset result = result.replaceAll("(<pre[^>]+>)[\r\n]+","$1") />
		<cfset result = result.replaceAll("[\r\n]+(</pre>)","$1") />
		
		<!--- Remove redundant spacing at the start of lines of code - use the first line to figure the spacing --->
		<cfif refind("<pre[^>]+> *",result)>
			<cfset spaces = rereplace(result,"^.*<pre[^>]+>( *).*$","\1") />
			<cfset result = result.replaceAll("(?m)(^|<pre[^>]+>)#spaces#(.*?)$","$1$2") />
		</cfif>
		
		<!--- Replace lines with only spaces, with empty lines --->
		<cfset result = result.replaceAll("(>|\r?\n) +(\r?\n|<)","$1$2") />
		
		<!--- Squashing a documentation bug - some examples have &tl; instead of &lt; or an actual < --->
		<cfset result = result.replaceAll("&amp;tl;","&lt;") />
		
		<!--- Convert any <p></p> immediately before a <pre></pre> into a code heading --->
		<cfset result = result.replaceAll("<p>(.+?)</p>\s*(<pre )","<span class='pre-header'>$1</span>$2") />
		
		<!--- Insert links --->
		<cfset result = replaceURLs(result,arguments.version) />
		
		<cfreturn result />
	</cffunction>
	
	
	
	<cffunction name="replaceURLs" returntype="string" access="public" output="false">
		<cfargument name="text" type="string" required="true" />
		<cfargument name="version" type="string" required="false" default="static" />
		
		<cfset var st = structnew() />
		<cfset var pos = 1 />
		<cfset var match = "" />
		
		<cfloop condition="structisempty(st) or (arraylen(st.pos) and st.pos[1])">
			<cfset st = refindnocase("\{[^\}]*section[^\}]*\}",arguments.text,pos,true) />
			<cfif structisempty(st) or (arraylen(st.pos) and st.pos[1])>
				<cfset match = mid(arguments.text,st.pos[1],st.len[1]) />
				
				<cfif match eq "{home}">
					<cfset match = structnew() />
				<cfelse>
					<cfset match = deserializeJSON(match) />
				</cfif>
				
				<cfset match.version = arguments.version />
				<cfset arguments.text = left(arguments.text,st.pos[1]-1) & getURL(argumentCollection=match) & mid(arguments.text,st.pos[1]+st.len[1],len(arguments.text)) />
				
				<cfset pos = st.pos[1] + st.len[1] />
			</cfif>
		</cfloop>
		
		<cfreturn arguments.text />
	</cffunction>
	
</cfcomponent>