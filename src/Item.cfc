/**
* NOTE: The code in this component is NOT TO BE CHANGED. All changes should be confined to
* the internal implementation details of GildedRose::updateQuality().
*/
component {

	/**
	* I initialize the item.
	*/
	public void function init(
		required string name,
		required numeric sellIn,
		required numeric quality
		) {

		this.name = arguments.name;
		this.sellIn = arguments.sellIn;
		this.quality = arguments.quality;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I serialize the item to plain text.
	*/
	public string function toString() {

		return "#this.name#, #this.sellIn#, #this.quality#";

	}

}
