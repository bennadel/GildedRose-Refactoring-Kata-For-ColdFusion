<cfscript>

	// Days can be passed-in as a search parameter or an environment variable.
	days = abs( fix( val( url.days ?: server.system.environment.days ?: 30 ) ) );

	// There must be a corresponding TXT file for the expected output.
	expectedFile = "expected-#days#.txt";

	if ( ! fileExists( expectedFile ) ) {

		echo( "Couldn't find expected output file [#expectedFile#].")
		abort;

	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	buffer = [];
	buffer.append( "OMGHAI!" );

	app = new src.GildedRose([
		new src.Item( "+5 Dexterity Vest", 10, 20 ),
		new src.Item( "Aged Brie", 2, 0 ),
		new src.Item( "Elixir of the Mongoose", 5, 7 ),
		new src.Item( "Sulfuras, Hand of Ragnaros", 0, 80 ),
		new src.Item( "Sulfuras, Hand of Ragnaros", -1, 80 ),
		new src.Item( "Backstage passes to a TAFKAL80ETC concert", 15, 20 ),
		new src.Item( "Backstage passes to a TAFKAL80ETC concert", 10, 49 ),
		new src.Item( "Backstage passes to a TAFKAL80ETC concert", 5, 49 ),
		// This conjured item does not work properly yet.
		new src.Item( "Conjured Mana Cake", 3, 6 )
	]);

	// Run simulation for days.
	for ( i = 0 ; i <= days ; i++ ) {

		buffer.append( "-------- day #i# --------" );
		buffer.append( "name, sellIn, quality" );

		for ( item in app.items ) {

			buffer.append( item.toString() );

		}

		buffer.append( "" );
		app.updateQuality();

	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	myers = new lib.MyersDiff();
	utils = new lib.Utils();

	// Compare current output to expected output.
	actual = utils.fromLines( buffer ).trim();
	expected = fileRead( expectedFile, "utf-8" ).trim();
	isPassing = ( actual == expected );

	// Create line-based diff of the outputs (for visual affordance).
	diff = myers.diffElements(
		original = utils.toLines( expected ),
		modified = utils.toLines( actual )
	);

</cfscript>

<cfoutput>
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>
		Testing GildedRose Refactoring Kata For ColdFusion
	</title>
	<style type="text/css">

		body {
			font-family: Avenir, Montserrat, Corbel, URW Gothic, source-sans-pro, sans-serif ;
			font-size: 18px ;
			line-height: 1.4 ;
		}

		.flag {
			border-radius: 8px ;
			display: inline-block ;
			padding-inline: 12px ;

			&.isPassing {
				background-color: green ;
				color: white ;
			}
			&.isFailing {
				background-color: red ;
				color: white ;
			}
		}

		.results {
			display: flex ;
			gap: 30px ;

			& section {
				flex: 1 1 50% ;
			}

			& pre {
				margin-block: 2px ;
			}

			& :is( del, ins ) {
				display: block ;
				font-weight: 600 ;
				text-decoration: none ;
			}

			& ins {
				background-color: ##fff09f ;
			}

			& del {
				background-color: ##ffc7aa ;
			}
		}
	</style>
</head>
<body>

	<h1>
		GildedRose Result:
		<cfif isPassing>
			<mark class="flag isPassing">TextTest Is Passing</mark>
		<cfelse>
			<mark class="flag isFailing">TextTest Is Failing</mark>
		</cfif>
	</h1>

	<div class="results">
		<section>
			<h2>
				Actual Output
			</h2>
			<cfloop array="#diff.operations#" item="operation">

				<cfswitch expression="#operation.type#">
					<cfcase value="delete">
						<!--- Ignore deletes (these are the "expected" lines). --->
					</cfcase>
					<cfcase value="insert">
						<pre><ins>#encodeForHtml( operation.value )#<br /></ins></pre>
					</cfcase>
					<cfdefaultcase>
						<pre>#encodeForHtml( operation.value )#<br /></pre>
					</cfdefaultcase>
				</cfswitch>

			</cfloop>
		</section>
		<section>
			<h2>
				Expected Output
			</h2>
			<cfloop array="#diff.operations#" item="operation">

				<cfswitch expression="#operation.type#">
					<cfcase value="delete">
						<pre><del>#encodeForHtml( operation.value )#<br /></del></pre>
					</cfcase>
					<cfcase value="insert">
						<!--- Ignore inserts (these are the "modified" lines). --->
					</cfcase>
					<cfdefaultcase>
						<pre>#encodeForHtml( operation.value )#<br /></pre>
					</cfdefaultcase>
				</cfswitch>

			</cfloop>
		</section>
	</div>

</body>
</html>
</cfoutput>
