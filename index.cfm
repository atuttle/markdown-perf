<cfscript>
	basePath = '/markdown-perf';

	//load the jmd JAR file
	if (not structKeyExists(application, "jmd")){
		jl = createObject("component", "javaloader.JavaLoader").init([ expandPath( basePath & '/assets/jmd-0.8.1.jar' ) ]);
		application.jmd = jl.create('com.cforcoding.jmd.MarkDown');
	}
	//load the .net assembly
	if (not structKeyExists(application, "mds")){
		application.mds = getMDS();
	}

	//save the content
	mdSrc = getTargetMD();

	writeOutput('<strong>Target Markdown (happy to accept suggestions to make it more complex/etc!):</strong>');
	writeOutput('<pre style="max-width: 100%; overflow-x: scroll; background-color: ##ddd;">#mdSrc#</pre>');

	iterations = 2500;
	writeOutput('Iterations of transform operation: #iterations#<br/>');

</cfscript>
<cffunction name="getMDS" output="false">
	<cfset var mds = '' />
	<cfobject type="dotnet" assembly="#expandPath( basePath & '/assets/MarkdownSharp.dll' )#" class="MarkdownSharp.Markdown" name="mds" />
	<cfreturn mds />
</cffunction>
<cffunction name="getTargetMD" output="false">
	<cfset var mdSrc = '' />
<cfsavecontent variable="mdSrc">1. You're trying to add a Treasure to an ArrayList of RandomOccupants, so unless Treasure is a RandomOccupant, that's not going to work. The given code does not make it clear whether Treasure is a subclass of RandomOccupant, so it's not possible from the code here to say whether that's part of the problem.

2. What you're actually doing is adding an int to the list here, which is *definitely* not a RandomOccupant.

3. ArrayList's add() method returns either boolean or void depending on the version that you're using, so you can't assign to it. You're using the method incorrectly.

The two versions of add() are:

    boolean  add(E e)
    void     add(int index, E element)

The second version inserts the element at the specified position, and the first one inserts it at the end. Presumably, what you're intending to do is this:

    for(i = 0; i < numTreasures; ++i)
        randOccupants.add(new Treasure(this));

But of course, that assumes that Treasure is a subclass of RandomOccupant. If it isn't, then you'll need to change the type of the ArrayList for it to hold Treasures.</cfsavecontent>
	<cfreturn mdSrc />
</cffunction>

<cftimer label="MarkdownSharp Execution Time" type="inline">
	<cfloop from="1" to="#iterations#" index="i">
		<cfset result = application.mds.transform(mdSrc) />
	</cfloop>
</cftimer>

<br/>

<cftimer label="jMD Execution Time" type="inline">
	<cfloop from="1" to="#iterations#" index="i">
		<cfset result = application.jmd.transform(mdSrc) />
	</cfloop>
</cftimer>
