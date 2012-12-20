<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset stLibrary = arguments.stParam.library />
<cfset qLibraries = getLibraries() />

<cfoutput>
    <div class="main-side">
      <a class="btn btn-block main-side-toggle" data-toggle="collapse" data-target=".main-side-collapse"><i class="icon-list"></i>Tree</a>
      <div class="main-side-collapse collapse">
        <p class="side-header"><a href="#getURL(arguments.stParam.section)#"><i class="icon-folder-open"></i>#getLabel("itemplural")#</a></p>
		<cfif stLibrary.children.recordcount><!--- There are some sections that don't have a third level of "children" --->
	        <ul>
			  <li class="active parent">
				<a href="#getURL(arguments.stParam.section,stLibrary.name)#">#stLibrary.label#</a></li>
				<ul>
				  <cfloop query="stLibrary.children">
				    <li><a href="#getURL(arguments.stParam.section,stLibrary.name,stLibrary.children.name)#">#stLibrary.children.label#</a></li>
				  </cfloop>
				</ul>
			  </li>
			</ul>
	    <cfelse><!--- In this case, show all so-called "libraries" --->
	        <ul>
	          <cfloop query="qLibraries">
		        <li><a href="#getURL(arguments.stParam.section,qLibraries.library)#" <cfif stLibrary.name eq qLibraries.library>class="active"</cfif>>#qLibraries.label#</a></li>
	  	      </cfloop>
	  	    </ul>
	    </cfif>
      </div><!-- /.main-side-collapse -->
    </div><!-- main-side -->
    <div class="main-content-container">
      <div class="main-content">
        <div class="main-content-title">
          <h1>#stLibrary.label#</h1>
        </div><!-- /.main-content-title -->
        <div class="main-content-title">
          <h1>#stLibrary.label#</h1>
        </div><!-- /.main-content-title -->
        <ul class="breadcrumb clearfix">
          <li><a href="#getURL('home')#">Home</a><span class="divider">/</span></li>
          <li><a href="#getURL(arguments.stParam.section)#">#getLabel("itemplural")#</a><span class="divider">/</span></li>
          <li class="active">#stLibrary.label#</li>
        </ul><!-- /.breadcrumb .clearfix -->
</cfoutput>

<!--- Deprecation --->
<cfif stLibrary.bDeprecated>
	<cfoutput><p class="Deprecated">This #getLabel('librarysingle')# has been deprecated.</p></cfoutput>
</cfif>

<skin:view stObject="#stObj#" webskin="displayLibraryInformation" stParam="#arguments.stParam#" alternateHTML="" />

<cfoutput>#replaceURLs(stLibrary.readme)#</cfoutput>

<cfif stLibrary.children.recordcount>
	<cfoutput>
	        <h2>#getLabel("childplural")#</h2>
	        <ul class="components-list nav nav-pills">
		      <cfloop query="stLibrary.children">
				<li><a href="#getURL(arguments.stParam.section,stLibrary.name,stLibrary.children.name)#">#stLibrary.children.label#</a></li>
			  </cfloop>
	        </ul><!-- /.components-list .nav .nav-pills -->
	</cfoutput>
</cfif>

<cfoutput>
      </div><!-- /.main-content -->
    </div><!-- /.main-content-container -->
</cfoutput>

<cfsetting enablecfoutputonly="false" />