component hint="Utility methods." {

	/**
	* I initialize the utilities.
	*/
	public void function init() {

		variables.newline = chr( 10 );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I join the given lines back into a string.
	*/
	public string function fromLines( required array lines ) {

		return lines.toList( newline );

	}


	/**
	* I split the given string into lines.
	*/
	public array function toLines( required string value ) {

		return value
			.reReplace( "\r\n?", newline, "all" )
			.reMatch( "[^\n]*" )
		;

	}

}
