<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Cover --->

<cfimport taglib="../../tags" prefix="doc" />

<doc:css />

<cfoutput>
	<style type="text/css">
		body * { font-family:Arial, Helvetica, sans-serif; }
		p { width:95% }
			p.documentmeta { font-size:12px; margin: 0 0 0 15px; }
		
		h2.toc_1 { margin-bottom:0; padding-bottom:0; }
		
		ul.toc_2 { list-style-type:none; font-weight:bold; margin-top:5px; padding-top:0; }
	</style>
	
	<h1 class="mainsectiontitle">
		#stObj.projectname#<br />
		Functional Specification
	</h1>
	
	<p class="documentmeta">
		Document date: #dateformat(stObj.documentdate,"dd mmmm yyyy")#<br />
		Print date: #dateformat(now(),"dd mmmm yyyy")#<br />
		Version: #stObj.documentversion#
	</p>
	
	#stObj.projectsummary#
	
	<p class="contact">#stObj.projectcontact#</p>
	<p class="contactemail">#stObj.projectcontactemail#</p>
</cfoutput>

<cfsetting enablecfoutputonly="false" />