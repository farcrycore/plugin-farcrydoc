<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Functional specification --->
<!--- @@description: Deliverable report --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<ft:processform action="Generate">
	<ft:processformobjects typename="reportFunctionalSpecification" />
</ft:processform>

<admin:header />

<ft:form>
	<cfoutput>
		<h1>Functional Specification</h1>
		<p>This generates a document automatically based on the content types and publishing rules defined for the project. The types, rules, and webskins used are those defined in the FarcryDoc plugin, but the predefined 'Functional Specification' set of sections is included for each instead of the configured sections.</p>
	</cfoutput>
	
	<ft:object typename="reportFunctionalSpecification" lFields="projectname,projectsummary,projectcontact,projectcontactemail,documentdate,documentversion" includefieldset="false" />
	
	<ft:buttonPanel>
		<ft:button value="Generate" />
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />