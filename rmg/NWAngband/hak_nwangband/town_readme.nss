/*

    Town general structure
    ----------------------

    When a player is in a town, there are a number of options avaliable to them.
    Many options are only avaliable at certain times of day, generally 8am to 8pm.
    A few options are always avaliable.
                                    Hours avaliable         Time taken
        Leave town                  always                  0
        Go to Inn
            Go to Room              always                  2
            Perform                 2pm-2am                 8
            Gamble                  2pm-2am                 8
        Go to Temple
            Private Prayers         always                  2
            Attend services         8am-8pm                 8
            Hire a spellcaster      8am-8pm                 2
        Go shopping
            Full day shopping       8am-8pm                 8
            Quick shopping          8am-8pm                 2

    When a player wishes to sleep, they can use the bed in the inn room. Then
    they can either sleep (till 8am), rest until fully healed, or nap (2 hours pass).

    The inn room also allows players to craft, use items, and generally act as a
    "safe" area.

    Death & taxes
    -------------

    When a player enters a town, they have to pay a certain amount of "tax".

    This is assesed as their total value, with a certain allowance for level.
    Above that, a percentage of the value is the amount of tax.
    If they have above double the allowance, amounts over that have double the tax
    rate. Over triple, triple the tax rate, etc.

    Base tax rate is 10%

    The tax rate caps out at 90% regardless of value.

    When a player leaves a town, they are billed for food, board, etc that they
    have consumed during their stay. This is 10% of itemvalue for a town of that
    level per day.



    Skills useage when shopping
    ---------------------------

    All skills are opposed roll against the merchant. Merchant rolls d20+TownLevel.

    Appraise applies to all stores.
    Difference is % decrease in markup and increase in markdown, capped at 0-10%

    Can then use one other skill optionally on top of that.

    Persuasion  is a minor (2) non-lawful act when shop is non-chaotic
    (your breaking conventional rules that say you pay the asking price)
    Difference is % decrease in markup and increase in markdown, capped at -10-10%

    Bluff       is a minor (2) non-good act when shop is non-evil
    (your lying for your own benefit)
                is a very minor (1) non-lawful acts when shop is non-chaotic.
    (your breaking conventional rules that say you pay the asking price)
    Difference is % increase in markdown, capped at -20-20%

    Intimidate  is a significantly (5) non-good act when shop is non-evil
    (threatening innocents)
                is a very minor (1) non-lawful acts when shop is non-chaotic.
    (your breaking conventional rules that say you pay the asking price)
    Difference is % decrease in markup and increase in markdown, capped at -20-20%

    When Shoplifting, a store is opened that will only "sell" but with -100 Markup
    The DC of an item is d20+LevelOfStore+(2*InventoryArea)+Weight
    Failing by 10 is equivalent to getting caught.
    Failing by less than 10 puts the item back.

    Merchants that accept stolen good have an additional +50% markup and -50% markdown.
    By default, all merchants have -50% markdown.

    For each level of shopping below the maximum in that town, there is -2% markup
    and +2% markdown to represent the extra competition increased levels of supply
    and demand for these more mundane items brings.

    MARKUP SHOULD NEVER BE LESS THAN MARKDOWN and DoShopping will check for this

    MultiplesValue of a town should be equal to that of the highest level goods
    that the town sells.

    InfiniteValue should be 1/10th of the MultiplesValue, so there are no more than
    about 10 instances of a particular item.

    MaxValue is the total gold of the PC, or the value of goods of the merchants level+1
    MinValue is zero, or the value of goods of the merchants level-1

    Normally, shopping takes 8 hours and results in 50% of total goods in the
    town being avaliable.
    However, a player can do a "rapid shop" which only takes 2 hours but this only
    makes 20% of the good in the town avaliable for purchase. In a quick shop,
    only appraise can be used with a -10 penalty.



*/
