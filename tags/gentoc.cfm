<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Table of Contents (for front end) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.selector" /><!--- The element to add the TOC to --->

<cfif thistag.ExecutionMode eq "start">
	<skin:htmlHead id="jquery" />

	<skin:htmlHead><cfoutput>
		<script type="text/javascript">
			jQ(function(){
				jQ("#attributes.selector#").append("<div id='doccont'><h3>Table of contents</h3><ul id='doctoc'></ul></div><div>&nbsp;</div>");
				var $cont = jQ("##doccont");
				
				var $toc = jQ("##doctoc");
				
				jQ("h1").each(function(){
					$toc.append("<li><a href='##"+this.id+"'>"+this.innerHTML+"</a></li>");
				});
				jQ("h2").each(function(){
					$toc.append("<li><a href='##"+this.id+"'>"+this.innerHTML+"</a></li>");
				});
				
				// fixed position definition
				var homepos = $cont.offset();
				var width = $cont.width();
		        setInterval(function(){
					var curscrolltop = jQ("body").scrollTop() || jQ("html").scrollTop();
					if (curscrolltop + 0 > homepos.top) {
						$cont.css({
							position:	'fixed',
							top:		0,
							left:		homepos.left,
							width:		width
						});
					} else {
						$cont.css({
							position:	'absolute',
							top:		null,
							left:		null,
							width:		width
						});
					}
		        },50);
			});
		</script>
	</cfoutput></skin:htmlHead>
</cfif>

<cfsetting enablecfoutputonly="false" />