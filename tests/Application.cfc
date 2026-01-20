component {

	// Define the application settings.
	this.name = "GildedRoseKataForColdFusion";
	this.applicationTimeout = createTimeSpan( 0, 1, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;
	// As a security best practice, we DO NOT WANT to search for unscoped variables in any
	// scope other than the core variables, local, and arguments scope. The CGI, FORM,
	// URL, COOKIE, etc. should only ever be referenced explicitly.
	this.searchImplicitScopes = false;
	// Make sure that every struct key-case matches its original defining context. This
	// way, we don't get any unexpected upper-casing of keys (a legacy CFML behavior)./
	// --
	// Note: for lucee, we also need set the `-Dlucee.preserve.case=true` JVM argument in
	// the server.json file.
	this.serialization = {
		preserveCaseForStructKey: true,
		preserveCaseForQueryColumn: true
	};
	// Make sure that all arrays are passed by reference. Historically, arrays have been
	// passed by value, which has no place in a modern language.
	this.passArrayByReference = true;
	// In addition to CFM/CFML files, only allow HTML files to be compiled and executed
	// as CFML code when transcluded with a cfinclude tag. All other includes will be
	// consumed as static content.
	this.compileExtForInclude = "html";
	// Stop ColdFusion from replacing "<script>" tags with "InvalidTag". This doesn't
	// really help us out and will cause unexpected bugs.
	this.scriptProtect = "none";
	// Block all uploaded file extensions by default. This will require each fileUpload()
	// call to have an explicit set of allow-listed mime-types.
	this.blockedExtForFileUpload = "*";

	// Define application mappings.
	this.directory = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings = {
		"/src": "#this.directory#../src"
	};

	// ---
	// LIFE-CYCLE METHODS.
	// ---

	/**
	* I handle uncaught errors that bubble-up to the application boundary.
	*/
	public void function onError( required any error ) {

		// CAUTION: You would never dump-out an error in production; but for a code kata,
		// this is acceptable.
		dump( error );
		abort;

	}

}
