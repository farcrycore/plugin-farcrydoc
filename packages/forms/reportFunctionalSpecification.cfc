<cfcomponent hint="Configure a functional specification" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty ftSeq="1" ftFieldSet="Functional specification"
			name="projectname" type="string" ftLabel="Project name"
			ftType="string" ftDefault="application.config.general.sitetitle" ftDefaultType="evaluate"
			hint="Name of the project" />
	<cfproperty ftSeq="2" ftFieldSet="Functional specification"
			name="projectsummary" type="longchar" ftLabel="Project summary"
			ftType="richtext" ftDefault=""
			hint="A summary of the project functionality" />
	<cfproperty ftSeq="3" ftFieldSet="Functional specification"
			name="projectcontact" type="longchar" ftLabel="Project contact"
			ftType="longchar" ftDefault=""
			hint="Contact information for the project" />
	<cfproperty ftSeq="4" ftFieldSet="Functional specification"
			name="projectcontactemail" type="string" ftLabel="Project contact email"
			ftType="string" ftDefault=""
			hint="Contact email" />
	<cfproperty ftSeq="5" ftFieldSet="Functional specification"
			name="documentdate" type="date" ftLabel="Document date"
			ftType="datetime" ftDefault="now()" ftDefaultType="evaluate"
			hint="Documentation date" />
	<cfproperty ftSeq="6" ftFieldSet="Functional specification"
			name="documentversion" type="string" ftLabel="Document version"
			ftType="string" ftDefault=""
			hint="Document version" />
	
	<cffunction name="process" access="public" output="false" returntype="struct" hint="Empty process function">
		<cfargument name="fields" type="struct" required="true" hint="The fields submitted" />
		
		<cfset var oTypeDoc = application.fapi.getContentType(typename="docType") />
		<cfset var qTypes = oTypeDoc.getTypeQuery(showundocumented=true) />
		<cfset var stTypes = oTypeDoc.getTypeData(refresh=false) />
		<cfset var qTypeIndex = "" />
		
		<cfset var oRuleDoc = application.fapi.getContentType(typename="docRule") />
		<cfset var qRules = oRuleDoc.getRuleQuery(showundocumented=true) />
		<cfset var stRules = oRuleDoc.getRuleData(refresh=false) />
		<cfset var qRuleIndex = "" />
		
		<cfset var stObj = arguments.fields />
		
		<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		<cfimport taglib="/farcry/plugins/farcrydoc/tags" prefix="doc" />
		
		<cfquery dbtype="query" name="qTypeIndex">
			select		typename as [value], displayname as label
			from		qTypes
			order by 	displayname asc
		</cfquery>
		
		<cfquery dbtype="query" name="qRuleIndex">
			select		typename as [value], displayname as label
			from		qRules
			order by 	displayname asc
		</cfquery>
		
		<cfset request.mode.ajax = true />
		
		<cfdocument format="PDF" filename="#application.path.securefilepath#/#arguments.fields.projectname# Functional Specification #arguments.fields.documentversion#.pdf" overwrite="true">
			<cfdocumentsection margintop="0.75" marginbottom="0.5">
				<doc:css force="true" />
				<skin:view stObject="#arguments.fields#" typename="reportFunctionalSpecification" webskin="reportCover" />
			</cfdocumentsection>
			<cfdocumentsection margintop="0.75" marginbottom="0.5">
				<cfdocumentitem type="header">
					<cfoutput><p style="font-family:helvetica,arial;margin:0;">Functional Specification</p></cfoutput>
				</cfdocumentitem>
				<cfdocumentitem type="footer">
					<cfoutput><p style="text-align:center;font-weight:bold;font-family:helvetica,arial;margin:0;">#cfdocument.currentpagenumber#</p></cfoutput>
				</cfdocumentitem>
				
				<doc:css force="true" />
				
				<skin:view stObject="#arguments.fields#" typename="reportFunctionalSpecification" webskin="reportTableOfContents" types="#qTypeIndex#" rules="#qRuleIndex#" />
				<cfdocumentitem type="pagebreak" />
				<skin:view stObject="#arguments.fields#" typename="reportFunctionalSpecification" webskin="reportCodeBaseSummary" />
				<cfloop query="qTypeIndex">
					<cfdocumentitem type="pagebreak" />
					<cfif qTypeIndex.currentrow eq 1>
						<cfoutput><h1 class="mainsectiontitle">Content Types</h1></cfoutput>
					</cfif>
					<skin:view typename="docType" stObject="#oTypeDoc.getType(qTypeIndex.value)#" webskin="displayDoc" parts="displayDocSummary,displayDocPropertySummary,displayDocFileLocations,displayDocJoins,displayDocWebskins:showfullcacheandsecurity=false;showfullpath=true,displayDocPropertyDetails" />
				</cfloop>
				<cfloop query="qRuleIndex">
					<cfdocumentitem type="pagebreak" />
					<cfif qRuleIndex.currentrow eq 1>
						<cfoutput><h1 class="mainsectiontitle">Publishing Rules</h1></cfoutput>
					</cfif>
					<skin:view typename="docRule" stObject="#oRuleDoc.getRule(qRuleIndex.value)#" webskin="displayDoc" parts="displayDocSummary,displayDocPropertySummary,displayDocJoins,displayDocWebskins:showfullcacheandsecurity=true;showfullpath=true,displayDocPropertyDetails" />
				</cfloop>
				
			</cfdocumentsection>
		</cfdocument>
		
		<cfheader name="content-disposition" VALUE='attachment; filename="#arguments.fields.projectname# Functional Specification #arguments.fields.documentversion#.pdf"' />
		<cfheader name="cache-control" value="" />
		<cfheader name="pragma" value="" />
		<cfcontent file="#application.path.securefilepath#/#arguments.fields.projectname# Functional Specification #arguments.fields.documentversion#.pdf" />
		
		<cfreturn arguments.fields />
	</cffunction>
	
</cfcomponent>