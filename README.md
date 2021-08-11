# Does more people equal better loot?
Given that:
* A raid gives `<number of people> / 5` items (decimal part is handled as percentage to gain another item)
* Items are distributed between all members of raid, with each having a chance to gain one item

Is there any benefit of fiddling around with including extra players that are not original members of the clan, and how does it affect the outcome of average payoff for clan members? Are there any trends?

## Setup
1. Download https://processing.org/
2. Open this file with it
3. Run

## Configure
```
int MIN_ORIGINAL_PEOPLE = 15;
int MAX_ORIGINAL_PEOPLE = 35;
int MIN_EXTRA_PEOPLE = 0;
int MAX_EXTRA_PEOPLE = 5;
```

These columns define what scenarios will be considered, the output will be cells that vertically match each possible amount (inclusive) of original player count and horizontally each possible amount of extra people. 

## To-Do
* Prettier, more descriptive output
* Randomness analysis
