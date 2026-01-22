
# GildedRose Refactoring Kata For ColdFusion

In a recent YouTube discussion - [How Docker Sandboxes AI Agents (Before They Break Everything)][yt-docker] - one of the hosts mentioned the [GildedRose Refactoring Kata][gildedrose] popularized by [Emily Bache][emily-bache], a software trainer and coach. Bache's kata repository contains the starting point for dozens of different languages; but she doesn't have ColdFusion. As such, I thought it would be fun to try this kata out for myself using [Lucee CFML][lucee] - the open source version of the [ColdFusion web platform][coldfusion].


## My Manual Refactoring Of The GildedRose

I've pushed my manual refactoring of the `GildedRose.cfc` ColdFusion component to the `refactor-v1` branch of the GitHub repository. I tried to work in small incremental steps in order to outline my thought process; and to provide easy roll-back mile markers for when I might hit a deadend in my exploration.

You can view the commits here: **[`master...refactor-v1`][manual-refactor]**


## Running This Kata With CommandBox

The CFML code for the GildedRose Inn is stored in the `src` folder. The 30-day [TextTest][text-test]-inspired refactoring harness is stored in the `tests` folders. The `tests` folder is where you can run [CommandBox][commandbox]:

```sh
# Enter the tests directory.
cd ./tests

# Start the CommandBox Lucee server (the browser window
# should open automatically once the server has started):
box server start

# ... when you're done, to STOP THE SERVER run:
box server stop
```

The `index.cfm` page within the `tests` directory executes a 30-day simulation of the GildedRose business logic and compares the **generated output** to the **`expected-30.txt` output** ([provided in the GildedRose repository][gildedrose-30]). If the output matches character-for-character, the test passes; otherwise it fails.

If you want to run the GildedRose simulation for an explicit number of days, you can pass `DAYS` in as an environment variable. For example, to run the simulation for 3-days you would execute the following (this syntax works on MacOS - your OS mileage may vary):

```sh
DAYS=3 box server start
```

The test harness expects to find a corresponding text file for the expected output in the format of `expected-{DAYS}.txt` (ex, `expected-3.txt`).


## GildedRose Requirements Specification

> **Note**: these requirements were copied from the [GildedRoseRequirments.md][gildedrose-requirements]; and then modified slightly to be rendered as a sub-heading within this README.

Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a prominent city ran by a friendly innkeeper named Allison. We also buy and sell only the finest goods. Unfortunately, our goods are constantly degrading in `Quality` as they approach their sell by date.

We have a system in place that updates our inventory for us. It was developed by a no-nonsense type named Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that we can begin selling a new category of items. First an introduction to our system:

- All `items` have a `SellIn` value which denotes the number of days we have to sell the `items`
- All `items` have a `Quality` value which denotes how valuable the item is
- At the end of each day our system lowers both values for every item

Pretty simple, right? Well this is where it gets interesting:

- Once the sell by date has passed, `Quality` degrades twice as fast
- The `Quality` of an item is never negative
- __"Aged Brie"__ actually increases in `Quality` the older it gets
- The `Quality` of an item is never more than `50`
- __"Sulfuras"__, being a legendary item, never has to be sold or decreases in `Quality`
- __"Backstage passes"__, like aged brie, increases in `Quality` as its `SellIn` value approaches;
	- `Quality` increases by `2` when there are `10` days or less and by `3` when there are `5` days or less but
	- `Quality` drops to `0` after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

- __"Conjured"__ items degrade in `Quality` twice as fast as normal items

Feel free to make any changes to the `UpdateQuality` method and add any new code as long as everything still works correctly. However, do not alter the `Item` class or `Items` property as those belong to the goblin in the corner who will insta-rage and one-shot you as he doesn't believe in shared code ownership (you can make the `UpdateQuality` method and `Items` property static if you like, we'll cover for you).

Just for clarification, an item can never have its `Quality` increase above `50`, however __"Sulfuras"__ is a legendary item and as such its `Quality` is `80` and it never alters.


<!-- References. -->

[coldfusion]: https://www.adobe.com/products/coldfusion-family.html

[commandbox]: https://www.ortussolutions.com/products/commandbox

[emily-bache]: https://emilybache.com/

[gildedrose]: https://github.com/emilybache/GildedRose-Refactoring-Kata

[gildedrose-30]: https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/texttests/ThirtyDays/stdout.gr

[gildedrose-requirements]: http://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/GildedRoseRequirements.md

[lucee]: https://www.lucee.org/

[manual-refactor]: https://github.com/bennadel/GildedRose-Refactoring-Kata-For-ColdFusion/compare/master...refactor-v1

[text-test]: https://texttest.org/

[yt-docker]: https://www.youtube.com/watch?v=tdmqL3mEneo
