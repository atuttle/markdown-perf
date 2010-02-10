<cfscript>
	basePath = '/markdown-perf';

	//load the jmd JAR file (via javaLoader)
	if (not structKeyExists(application, "jmd")){
		jl = createObject("component", "javaloader.JavaLoader").init([ expandPath( basePath & '/assets/jmd-0.8.1.jar' ) ]);
		application.jmd = jl.create('com.cforcoding.jmd.MarkDown');
	}
	//load the jmd JAR file (from classpath)
	if (not structKeyExists(application, "jmd2")){
		application.jmd2 = createObject("java", "com.cforcoding.jmd.MarkDown");
	}
	//load the .net assembly
	if (not structKeyExists(application, "mds")){
		application.mds = getMDS();
	}

	//save the content
	mdSrc = getTargetMD();

	writeOutput('<strong>Target Markdown (happy to accept suggestions to make it more complex/etc!):</strong>');
	writeOutput('<textarea style="width: 80%; height: 300px; background-color: ##ddd;">#mdSrc#</textarea>');
</cfscript>

<cffunction name="getMDS" output="false">
	<cfset var mds = '' />
	<cfobject type="dotnet" assembly="#expandPath( basePath & '/assets/MarkdownSharp.dll' )#" class="MarkdownSharp.Markdown" name="mds" />
	<cfreturn mds />
</cffunction>
<cffunction name="getTargetMD" output="false">
	<cfset var mdSrc = '' />
	<cfsavecontent variable="mdSrc"><cfinclude template="assets/syntaxTestDoc.mdown"/></cfsavecontent>
	<cfreturn mdSrc />
</cffunction>

<br/>
<br/>

<cftimer label="MarkdownSharp Execution Time" type="inline">
	<cfset result = application.mds.transform(mdSrc) />
</cftimer>
<br/>

<cftimer label="jMD (via javaloader) Execution Time" type="inline">
	<cfset result = application.jmd.transform(mdSrc) />
</cftimer>
<br/>

<cftimer label="jMD (via classpath) Execution Time" type="inline">
	<cfset result = application.jmd2.transform(mdSrc) />
</cftimer>
