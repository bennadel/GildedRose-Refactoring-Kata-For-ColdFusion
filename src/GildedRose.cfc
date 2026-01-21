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

		// Sulfuras items never have to change. They are legendary!
		if ( item.name == "Sulfuras, Hand of Ragnaros" ) {

			return;

		}

		if ( item.name == "Aged Brie" ) {

			item.quality = min( ++item.quality, 50 );

		} else if ( item.name == "Backstage passes to a TAFKAL80ETC concert" ) {

			if ( item.sellIn < 6 ) {

				item.quality += 3;

			} else if ( item.sellIn < 11 ) {

				item.quality += 2;

			} else {

				item.quality++;

			}

			item.quality = min( item.quality, 50 );

		} else {

			item.quality = max( --item.quality, 0 );

		}

		--item.sellIn;

		// If the sell-by date hasn't passed yet, nothing more to process.
		if ( item.sellIn >= 0 ) {

			return;

		}

		if ( item.name == "Aged Brie" ) {

			item.quality = min( ++item.quality, 50 );
			return;

		}

		if ( item.name == "Backstage passes to a TAFKAL80ETC concert" ) {

			item.quality = 0;
			return;

		}

		item.quality = max( --item.quality, 0 );

	}

}
