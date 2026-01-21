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

		if (
			( item.name != "Aged Brie" ) &&
			( item.name != "Backstage passes to a TAFKAL80ETC concert" )
			) {

			if ( item.quality > 0 ) {

				if ( item.name != "Sulfuras, Hand of Ragnaros" ) {

					item.quality = item.quality - 1;

				}

			}

		} else {

			if ( item.quality < 50 ) {

				item.quality = item.quality + 1;

				if ( item.name == "Backstage passes to a TAFKAL80ETC concert" ) {

					if ( item.sellIn < 11 ) {

						if ( item.quality < 50 ) {

							item.quality = item.quality + 1;

						}

					}

					if ( item.sellIn < 6 ) {

						if ( item.quality < 50 ) {

							item.quality = item.quality + 1;

						}

					}

				}

			}

		}

		if ( item.name != "Sulfuras, Hand of Ragnaros" ) {

			item.sellIn = item.sellIn - 1;

		}

		if ( item.sellIn < 0 ) {

			if ( item.name != "Aged Brie" ) {

				if ( item.name != "Backstage passes to a TAFKAL80ETC concert" ) {

					if ( item.quality > 0 ) {

						if ( item.name != "Sulfuras, Hand of Ragnaros" ) {

							item.quality = item.quality - 1;

						}

					}

				} else {

					item.quality = item.quality - item.quality;

				}

			} else {

				if ( item.quality < 50 ) {

					item.quality = item.quality + 1;

				}

			}

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

}
