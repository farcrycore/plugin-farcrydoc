<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset stLibrary = arguments.stParam.library />
<cfset stItem = arguments.stParam.item />

<cfoutput>
    <div class="main-side">
      <a class="btn btn-block main-side-toggle" data-toggle="collapse" data-target=".main-side-collapse"><i class="icon-list"></i>Tree</a>
      <div class="main-side-collapse collapse">
        <p class="side-header"><a href="#getURL(arguments.stParam.section)#"><i class="icon-folder-open"></i>#getLabel("itemplural")#</a></p>
        <ul>
		  <li class="active parent">
			<a href="#getURL(arguments.stParam.section,stLibrary.name)#">#stLibrary.label#</a></li>
			<ul>
			  <cfloop query="stLibrary.children">
			    <li><a href="#getURL(arguments.stParam.section,stLibrary.name,stLibrary.children.name)#"<cfif stLibrary.children.name eq stItem.name> class="active"</cfif>>#stLibrary.children.label#</a></li>
			  </cfloop>
			</ul>
		  </li>
        </ul>
      </div><!-- /.main-side-collapse -->
    </div><!-- main-side -->
    <div class="main-content-container">
      <div class="main-content">
        <div class="main-content-title">
          <h1>#stItem.label#</h1>
        </div><!-- /.main-content-title -->
        <div class="main-content-title">
          <h1>#stItem.label#</h1>
        </div><!-- /.main-content-title -->
        <ul class="breadcrumb clearfix">
          <li><a href="#getURL('home')#">Home</a><span class="divider">/</span></li>
          <li><a href="#getURL(arguments.stParam.section)#">#getLabel("itemplural")#</a><span class="divider">/</span></li>
          <li><a href="#getURL(arguments.stParam.section,stLibrary.name)#">#stLibrary.label#</a><span class="divider">/</span></li>
          <li class="active">#stItem.label#</li>
        </ul><!-- /.breadcrumb .clearfix -->
</cfoutput>

<!--- Deprecation --->
<cfif arguments.stParam.library.bDeprecated>
	<cfoutput><p class="Deprecated">This tag library has been deprecated.</p></cfoutput>
</cfif>

<skin:view stObject="#stObj#" webskin="displayItemInformation" stParam="#arguments.stParam#" alternateHTML="" />

<cfoutput>
      </div><!-- /.main-content -->
    </div><!-- /.main-content-container -->
</cfoutput>

<cfsetting enablecfoutputonly="false" />