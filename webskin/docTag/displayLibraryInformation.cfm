<cfsetting enablecfoutputonly="true" />

<cfoutput>
    <table class="table table-bordered table-striped">
      <tbody>
        <tr>
          <td>Prefix</td>
          <td>#arguments.stParam.library.prefix#</td>
        </tr>
        <tr>
          <td>Library path</td>
          <td>#arguments.stParam.library.taglib#</td>
        </tr>
        <tr>
          <td>CFImport</td>
          <td><pre class="linenums prettyprint">&lt;cfimport taglib=&quot;#arguments.stParam.library.taglib#&quot; prefix=&quot;#arguments.stParam.library.prefix#&quot; /&gt;</pre><!-- /.linenums prettyprint --></td>
        </tr>
	  </tbody>
	</table>
</cfoutput>

<cfsetting enablecfoutputonly="false" />