<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif isdefined("url.ref")>
	<cfset arguments.stParam.ref = url.ref />
</cfif>
<cfif isdefined("url.lib")>
	<cfset arguments.stParam.lib = url.lib />
</cfif>
<cfif isdefined("url.loc")>
	<cfset arguments.stParam.loc = url.loc />
</cfif>

<cfif isdefined("arguments.stParam.ref")>
	<cfset stItem = getItem(arguments.stParam.loc,arguments.stParam.lib,arguments.stParam.ref) />
	<cfset stLibrary = getLibrary(arguments.stParam.loc,arguments.stParam.lib) /><cftry>
	<cfset stLocal.displayname = application.stCOAPI[stObj.name].displayname & "-" & stLibrary.label & " - " & stItem.label /><cfcatch><cfdump var="#arguments#"><cfdump var="#url#"><cfdump var="#stLibrary#"><cfabort></cfcatch></cftry>
	<cfset stLocal.section = lcase(mid(stObj.name,4,len(stObj.name))) />
<cfelseif isdefined("arguments.stParam.lib")>
	<cfset stLibrary = getLibrary(arguments.stParam.loc,arguments.stParam.lib) />
	<cftry><cfset stLocal.displayname = application.stCOAPI[stObj.name].displayname & " - " & stLibrary.label /><cfcatch><cfdump var="#stLibrary#"><cfdump var="#arguments#"><cfabort></cfcatch></cftry>
	<cfset stLocal.section = lcase(mid(stObj.name,4,len(stObj.name))) />
<cfelse>
	<cfif isdefined("application.stCOAPI.#stObj.name#.displaynameplural")>
		<cfset stLocal.displayname = application.stCOAPI[stObj.name].displaynameplural />
	<cfelse>
		<cfset stLocal.displayname = application.stCOAPI[stObj.name].displayname & "s" />
	</cfif>
	<cfset stLocal.section = lcase(mid(stObj.name,4,len(stObj.name))) />
</cfif>

<cfset request.fc.bShowTray = false />

<cfoutput>
	<!DOCTYPE html>
	<html>
	<head>
	  <meta charset="utf-8">
	  <meta name="viewport" content="width=device-width, initial-scale=1.0">
	  <title>FarCry Docs - #stLocal.displayname#</title>
	  <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,700">
	  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
	  <cfif isdefined("url.version") and url.version eq "public">
		  <cfset request.fc.bShowTray = false />
		  <cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		  <skin:loadCSS baseHREF="/farcry/plugins/farcrydoc/www/static/css" lFiles="bootstrap.css,main.css" />
		  <skin:loadJS baseHREF="/farcry/plugins/farcrydoc/www/static/js" lFiles="bootstrap.js,prettify.js" bCombine="false" />
	  <cfelse>
		  <link rel="stylesheet" href="css/bootstrap.css">
		  <link rel="stylesheet" href="css/main.css">
		  <script type="text/javascript" src="js/bootstrap.js"></script>
		  <script type="text/javascript" src="js/prettify.js"></script>
	  </cfif>
	</head>
	
	<body class="docs" onload="prettyPrint()">
	  <div class="navbar navbar-fixed-top navbar-inverse">
	    <div class="navbar-inner">
	      <div class="container-fluid">
	        <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	          <span class="icon-bar"></span>
	          <span class="icon-bar"></span>
	          <span class="icon-bar"></span>
	        </button>
	        <h1 class="brand"><a href="home.html">FarCry Docs</a> / <small>#application.config.docs.title#</small></h1>
	        <div class="nav-collapse collapse">
	          <ul class="nav">
	            <li><a href="#getURL('home')#">Home</a></li>
	            <li<cfif stLocal.section eq "tag"> class="active"</cfif>><a href="#getURL('tag')#">Tags</a></li>
	            <li<cfif stLocal.section eq "component"> class="active"</cfif>><a href="#getURL('component')#">Components</a></li>
	            <li<cfif stLocal.section eq "type"> class="active"</cfif>><a href="#getURL('type')#">Types</a></li>
	            <li<cfif stLocal.section eq "formtool"> class="active"</cfif>><a href="#getURL('formtool')#">Formtools</a></li>
	          </ul><!-- /.nav -->
	        </div><!-- /.nav-collapse -->
	      </div><!-- /.container-fluid -->
	    </div><!-- /.navbar-inner -->
	  </div><!-- /.navbar .navbar-fixed-top .navbar-inverse -->
	  <div id="main">
	    <div class="container-fluid">
</cfoutput>

<cfif isdefined("arguments.stParam.ref")>
	<skin:view stObject="#stObj#" webskin="displayBodyItem" item="#stItem#" library="#stLibrary#" section="#stLocal.section#" />
<cfelseif isdefined("arguments.stParam.lib")>
	<skin:view stObject="#stObj#" webskin="displayBodyLibrary" library="#stLibrary#" section="#stLocal.section#" />
<cfelse>
	<skin:view stObject="#stObj#" webskin="displayBodySection" section="#stLocal.section#" />
</cfif>

<cfoutput>
	    </div><!-- /.container-fluid -->
	  </div><!-- /##main -->
	  <div id="footer">
	    <div class="container-fluid">
	      <p>FarCry Core - <small><a href="http://www.farcrycore.org/">Main Site</a> | <a href="index.html">Documentation Downloads</a></small></p>
	    </div><!-- /.container-fluid -->
	  </div><!-- /##footer -->
	</body><!-- /.docs -->
	</html>
</cfoutput>

<cfsetting enablecfoutputonly="false" />