Character Skin ReadMe

Implementation:

1. Import the erf.

2. Apply these scripts to the events:

cskin_moduleload to the modules OnModuleLoad event.
cskin_onlevelup to the modules OnPlayerLevelUp event.
cskin_onenter to the OnEnter event of the area with the module's starting location.

Note:

Item Level Restrictions should be turned off, otherwise players will end up with hides in their inventory.

Configuration:

all script configuration is done in the cskin_include file, in the ConfigurePCRaceHides() function.

You will regonize this if you have configured the ECL scripts, there are two ways

hakless - Currently NOT implemented

with hak - add this line for each race:

SetHidesForRaceByInt(RACIAL_TYPE_*,"0:5:10:15");

Where Racial_type_* is the race you're adding and the second parameter is a list of the levels they get a new hide and it is deliminated by a ':'

Example:

SetHidesForRaceByInt(RACIAL_TYPE_DROW,"0:2:4:6:8:10:12:14:16:18");

This will set up the Drow race to get a hide at levels 0,2,4,6,8,10,12,14,16 and 18.

the hides:

The Hides must have a VERY SPECIFIC RESREF:

"skin_#_#"

The first pound is the integer value of the RACIAL_TYPE_* the hide matches with, the second # is the level it applies to.

"skin_28_0" is the resref for the hide a tiefling gets at level 0.

Note: Level 0 hides are defaults for races that do not change abilities on levelup. If a character is between levels, it will look DOWN the list to nearest they should get one and apply that.