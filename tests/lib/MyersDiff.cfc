component hint="A ColdFusion implementation of the Myers Diffing algorithm." {

	/**
	* I initialize the differ.
	*/
	public void function init() {
		// ... no state needed at this time ...
	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I perform a diff against the two strings.
	*/
	public struct function diff(
		required string original,
		required string modified,
		boolean caseSensitive = true
		) {

		return diffElements(
			original = original.reMatch( "." ),
			modified = modified.reMatch( "." ),
			caseSensitive = caseSensitive
		);

	}


	/**
	* I perform a diff against the two arrays of strings.
	*/
	public struct function diffElements(
		required array original,
		required array modified,
		boolean caseSensitive = true
		) {

		// To make the elements easier to work with (so that row/col indices align with
		// input indices), we're going to create local copies of the input arrays with a
		// front-loaded throw-away string. The diffing algorithm works by creating a
		// matrix of "steps" to get from the original string to the modified string; and
		// the whole situation is way easier if we can treat location (1,1) as a UNIQUE
		// value before the start of each string. This keeps all the indices simple!
		var originalInput = original;
		var modifiedInput = modified;
		var original = arrayMerge( [ createUuid() ], originalInput );
		var modified = arrayMerge( [ createUuid() ], modifiedInput );

		// In our matrix, the original text is represented horizontally (by columns) and
		// our modified text is represented vertically (by rows).
		var matrix = matrixNew(
			rowCount = modified.len(),
			columnCount = original.len()
		);

		// Flesh-out the "steps" that we MIGHT take to get from original to modified.
		matrix.each( ( row, rowIndex ) => {
			row.each( ( entry, columnIndex ) => {

				// PERFORMANCE TRADE-OFF: I'm storing a lot more data in each entry that
				// is actually needed because the stored data makes the algorithm easier
				// to think about. But, it also means the algorithm is slower and needs
				// more memory.
				entry.originalValue = original[ columnIndex ];
				entry.modifiedValue = modified[ rowIndex ];
				// Adjust indices to account for the empty string at (1,1).
				entry.originalIndex = ( columnIndex - 1 );
				entry.modifiedIndex = ( rowIndex - 1 );
				// Flag when original and modified content match at the given offsets.
				entry.match = caseSensitive
					? ! compare( entry.originalValue, entry.modifiedValue )
					: ! compareNoCase( entry.originalValue, entry.modifiedValue )
				;
				// Store the steps it took to get to the sibling locations of the matrix.
				// We'll use this in both the path identification and the back-tracing to
				// find optimal operations.
				entry.north = ( matrix[ rowIndex - 1 ][ columnIndex ].steps ?: 0 );
				entry.northWest = ( matrix[ rowIndex - 1 ][ columnIndex - 1 ].steps ?: 0 );
				entry.west = ( matrix[ rowIndex ][ columnIndex - 1 ].steps ?: 0 );

				// First row is based solely on index. As we move RIGHT across the matrix,
				// every step indicates a single "deletion" of the original text.
				if ( rowIndex == 1 ) {

					entry.steps = ( columnIndex - 1 );

				// First column is based solely on index. As we move DOWN across the
				// matrix, every step indicates a single "insertion" of the modified text.
				} else if ( columnIndex == 1 ) {

					entry.steps = ( rowIndex - 1 );

				// If the original / modified texts match at current location, we don't
				// have to increase the "steps" since only modifications count as a step.
				// As such, we'll copy the steps it took to get to the previous location.
				} else if ( entry.match ) {

					entry.steps = entry.northWest;

				// If the original / modified texts differ at the current location, add a
				// step to the smallest non-matching path it took to get to the siblings.
				} else {

					entry.steps = ( min( entry.north, entry.west ) + 1 );

				}

			});
		});

		// Now that we've populated the matrix with various step-paths, we're going to
		// start at the end of the matrix and back-trace through the steps to find the
		// smallest number of operations that get us from the original text to the
		// modified text (with an emphasis on "delete" operations - meaning we want the
		// final operations to list deletes before inserts wherever possible).
		var columnIndex = original.len();
		var rowIndex = modified.len();
		var operations = [];
		var counts = {
			equals: 0,
			insert: 0,
			delete: 0,
			total: 0
		};

		while ( true ) {

			// The origin (1,1) is just the throw-away placeholder that we added to make
			// all the sibling math easier (no null-reference errors). If we've traced
			// back to the placeholder, we can exit the tracing.
			if ( ( rowIndex == 1 ) && ( columnIndex == 1 ) ) {

				break;

			}

			var entry = matrix[ rowIndex ][ columnIndex ];

			// Note: since we're BACK TRACING from the end of the matrix and PREPENDING
			// steps, the operation priority is reversed from the following checks. By
			// checking for INSERTIONS before DELETIONS, it means that DELETIONS will
			// actually occur first when the operations are played-back in the correct
			// order (due to prepending of entries).
			if ( entry.match ) {

				operations.prepend({
					type: "equals",
					value: entry.originalValue,
					index: entry.originalIndex
				});
				counts.equals++;
				counts.total++;

				// Move diagonally for matches.
				columnIndex--;
				rowIndex--;

			} else if ( ( rowIndex > 1 ) && ( entry.steps == ( entry.north + 1 ) ) ) {

				operations.prepend({
					type: "insert",
					value: entry.modifiedValue,
					index: entry.modifiedIndex
				});
				counts.insert++;
				counts.total++;

				// Move vertically for insertions.
				rowIndex--;

			} else if ( ( columnIndex > 1 ) && ( entry.steps == ( entry.west + 1 ) ) ) {

				operations.prepend({
					type: "delete",
					value: entry.originalValue,
					index: entry.originalIndex
				});
				counts.delete++;
				counts.total++;

				// Move horizontally for deletions.
				columnIndex--;

			}

		}

		return [
			operations: operations,
			counts: counts
		];

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I create a matrix with the given dimensions.
	*/
	private array function matrixNew(
		required numeric rowCount,
		required numeric columnCount
		) {

		var row = [];
		row.resize( columnCount );

		for ( var i = 1 ; i <= columnCount ; i++ ) {

			row[ i ] = {};

		}

		var matrix = [];
		matrix.resize( rowCount );

		for ( var i = 1 ; i <= rowCount ; i++ ) {

			matrix[ i ] = duplicate( row );

		}

		return matrix;

	}

}
