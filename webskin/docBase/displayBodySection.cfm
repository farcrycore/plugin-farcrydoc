<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset qLibraries = getLibraries() />

<cfoutput>
    <div class="main-side">
      <a class="btn btn-block main-side-toggle" data-toggle="collapse" data-target=".main-side-collapse"><i class="icon-list"></i>Tree</a>
      <div class="main-side-collapse collapse">
        <p class="side-header"><a href="#getURL(arguments.stParam.section)#"><i class="icon-folder-open"></i>#getLabel("itemplural")#</a></p>
        <ul>
	      <cfloop query="qLibraries">
			<li><a href="#getURL(location=qLibraries.location,section=arguments.stParam.section,library=qLibraries.library)#">#qLibraries.label#</a></li>
		  </cfloop>
        </ul>
      </div><!-- /.main-side-collapse -->
    </div><!-- main-side -->
    <div class="main-content-container">
      <div class="main-content">
        <div class="main-content-title">
          <h1>#getLabel("itemplural")#</h1>
        </div><!-- /.main-content-title -->
        <div class="main-content-title">
          <h1>#getLabel("itemplural")#</h1>
        </div><!-- /.main-content-title -->
        <ul class="breadcrumb clearfix">
          <li><a href="#getURL('home')#">Home</a><span class="divider">/</span></li>
          <li class="active">#getLabel("itemplural")#</li>
        </ul><!-- /.breadcrumb .clearfix -->
        <h2>#getLabel("libraryplural")#</h2>
</cfoutput>

<skin:view stObject="#stObj#" webskin="displaySectionInformation" stParam="#arguments.stParam#" alternatehtml="" />

<cfoutput>
        <ul class="components-list nav nav-pills">
	      <cfloop query="qLibraries">
			<li><a href="#getURL(location=qLibraries.location,section=arguments.stParam.section,library=qLibraries.library)#">#qLibraries.label#</a></li>
		  </cfloop>
        </ul><!-- /.components-list .nav .nav-pills -->
      </div><!-- /.main-content -->
    </div><!-- /.main-content-container -->
</cfoutput>

<cfsetting enablecfoutputonly="false" />