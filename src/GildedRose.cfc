/**
* NOTE: Only the code WITHIN THE updateQuality() METHOD is intended to be changed. The
* constructor and items assignment should REMAIN UNCHANGED. That said, you can add
* additional private methods as needed to aide in refactoring.
*/
component {

	/**
	* I initialize the store.
	*/
	public void function init( required array items ) {

		this.items = arguments.items;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I update the quality of the store items, assuming that 1-day has passed since this
	* method was last called.
	*
	* Note: I copied the existing PHP version of the kata and converted it to CFML syntax.
	* I intentionally left the code looking awful (vis-a-vis white-space) to underscore
	* the need for refactoring.
	* --
	* https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/php/src/GildedRose.php
	*/
	public void function updateQuality() {

		for ( var item in this.items ) {

			updateQualityForItem( item );

		}

	}


	/**
	* I update the quality for the given item, assuming that 1-day has passed since this
	* item was last updated.
	*/
	public void function updateQualityForItem( required Item item ) {

		var MAX_QUALITY = 50;
		var MIN_QUALITY = 0;

		// Special handling of legendary items which never have to be changed.
		switch ( item.name ) {
			case "Sulfuras, Hand of Ragnaros":

				return;

			break;
		}

		switch ( item.name ) {
			case "Aged Brie":

				++item.quality;

			break;
			case "Backstage passes to a TAFKAL80ETC concert":

				if ( item.sellIn <= 5 ) {

					item.quality += 3;

				} else if ( item.sellIn <= 10 ) {

					item.quality += 2;

				} else {

					item.quality += 1;

				}

			break;
			default:

				--item.quality;

			break;
		}

		--item.sellIn;

		// If the sell-by date HAS PASSED, some additional quality tweaks are needed.
		if ( item.sellIn < 0 ) {

			switch ( item.name ) {
				case "Aged Brie":

					++item.quality;

				break;
				case "Backstage passes to a TAFKAL80ETC concert":

					item.quality = 0;

				break;
				default:

					--item.quality;

				break;
			}

		}

		item.quality = clamp( item.quality, MIN_QUALITY, MAX_QUALITY );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I constraint the given value to the given min/max range.
	*/
	private numeric function clamp(
		required numeric value,
		required numeric minValue,
		required numeric maxValue
		) {

		return min( max( value, minValue ), maxValue );

	}

}
