<cfsetting enablecfoutputonly="true" />

<cfset oTag = application.fapi.getContentType("docTag") />
<cfset request.fc.bShowTray = false />

<cfoutput>
	<!DOCTYPE html>
	<html>
	<head>
	  <meta charset="utf-8">
	  <meta name="viewport" content="width=device-width, initial-scale=1.0">
	  <title>#application.config.docs.title# Documentation</title>
	  <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,700">
	  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
	  <cfif isdefined("url.version") and url.version eq "public">
		  <cfset request.fc.bShowTray = false />
		  <cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		  <skin:loadCSS baseHREF="/farcry/plugins/farcrydoc/www/static/css" lFiles="bootstrap.css,main.css" />
	  <cfelse>
		  <link rel="stylesheet" href="css/bootstrap.css">
		  <link rel="stylesheet" href="css/main.css">
	  </cfif>
	</head>
	
	<body class="alt">
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
	            <li><a href="#oTag.getURL('home')#" class="active">Home</a></li>
	            <li><a href="#oTag.getURL('tag')#">Tags</a></li>
	            <li><a href="#oTag.getURL('component')#">Components</a></li>
	            <li><a href="#oTag.getURL('type')#">Types</a></li>
	            <li><a href="#oTag.getURL('formtool')#">Formtools</a></li>
	          </ul><!-- /.nav -->
	        </div><!-- /.nav-collapse -->
	        <div id="google-site-search" class="nav-collapse collapse pull-right span4">
				<script>
					(function() {
						if (window.location.host === "docs.farcrycore.org"){
							var cx = '015935794000702335563:5nwf36h7b7e';
							var gcse = document.createElement('script'); gcse.type = 'text/javascript';
							gcse.async = true;
							gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
								'//www.google.com/cse/cse.js?cx=' + cx;
							var s = document.getElementsByTagName('script')[0];
							s.parentNode.insertBefore(gcse, s);
							
							function updateInputHeight(){
								var input = $("##google-site-search .gsc-input");
								if (input.size())
									input.css("height","30px");
								else
									setTimeout(updateInputHeight,200);
							}
							updateInputHeight();
						}
					})();
				</script>
				<gcse:search></gcse:search>
			</div>
	      </div><!-- /.container-fluid -->
	    </div><!-- /.navbar-inner -->
	  </div><!-- /.navbar .navbar-fixed-top .navbar-inverse -->
	  <div id="main">
	    <div class="container">
	      <div class="page-header">
	        <h1>#application.config.docs.title# Documentation</h1>
	      </div><!-- /.page-header -->
	      <div class="row">
	        <div class="span3">
	          <h2>What is this?</h2>
	        </div><!-- /.span3 -->
	        <div class="span9">
	          <div class="main-content">
	            <p>This is the output from the automatic build of the API documentation for FarCry - the web framework FarCry not the video game FarCry. Here you will find documentation for all the custom tags, components, and ContentTypes in FarCry core and in FarCry CMS.</p>
	            <p>The documentation is provided in both online and <a href="#oTag.getURL('zip')#">downloadable form</a>. In addition, a <a href="#oTag.getURL('cfeclipse')#">CFEclipse dictionary</a> with code completion and snippets are generated as well.</p>
	            <hr>
	            <h3>Please, tell me more</h3>
	            <p>Ok, glad you asked. I dig your enthusiasm. You can follow this process on twitter if you'd like to know when the data is refreshed (pretty much every night), and when anything significant happens.</p>
	            <hr>
	            <h3>How can I help?</h3>
	            <p>You can read how to decorate your code so that the documentation parser can find your in line help by reading <a href="https://farcry.jira.com/wiki/display/FCCORE/Auto-Documentation">the auto documentation</a> section on the wiki. (If you happen to use textmate and the <a href="https://github.com/andyj/CFTextMate">cftextmate</a> bundle, install the FarCry Textmate bundle plugin as well. It has snippets for the documentation decorators.) You can then dig into the FarCry code and write comments or examples to move this whole process along.</p>
	          </div><!-- /.main-content -->
	        </div><!-- /.span9 -->
	      </div><!-- /.row -->
	    </div><!-- /.container -->
	  </div><!-- /##main -->
	  <div id="footer">
	    <div class="container">
	      <p>FarCry Core - <small><a href="http://www.farcrycore.org/">Main Site</a></small></p>
	    </div><!-- /.container -->
	  </div><!-- /##footer -->
	</body><!-- /.alt -->
	</html>
</cfoutput>

<cfsetting enablecfoutputonly="false" />