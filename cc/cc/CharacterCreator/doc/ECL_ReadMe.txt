Effective Character Level System ReadMe

This system is designed to take the effective character level of non-standard races into account and to use standard 3e experience rules.

Because class level cannot be altered by race in the NWN engine, a workaround must be made. Races that have an ECL of +1 or higher receive proportionately less experience, as determined by what level they should be. For example, a level 1 tiefling fighter would normally need 1000 experience to reach level 2, however the tiefling has an ECL of +1, so instead the experience should be the difference between level 2 and 3, or 2000 experience. Therefor, at level 1, this character would get 1/2 the experience of a standard race, 2/3 the experience at level 2, and so on. This simulates the character being 1 level higher, and as such they will cease to gain experience at level 19 (ECL 20).

Implementation:

1. Import the .erf into your module.

This should import the following files into your module:
 ecl_include
 ecl_moduleload
 ecl_onenter
 ecl_onlevelup
 nw_c2_default7
 nw_s3_balordeth

Note: If you have overwritten nw_c2_default7 or nw_s3_balordeth already, refer to the last section of this readme.

2. Set the XP scale of the module to 0.

The XP scale can be found in the module properties, on the advanced tab.

3. Add the scripts to the events.

Add ecl_moduleload into the module's OnModuleLoad event.
Add ecl_onlevelup into the modules' OnPlayerLevelUp event.
Add ecl_onenter into the OnEnter event of the area that has the module's starting location.

If any of these events are already in use, refer to the last section of this readme.

4. New scripting functions.

Any script that you use to grant XP to the player need to be updated. Include the ecl_include script use the following script replacements:

Instead of GiveXPToCreature, use GiveXPToPlayer
Instead of RewardPartyXP, use GrantPartyXP
If you use GetHitDice to get a player's level, you should replace it with GetECL, but only on a pc object.

Configuration:

All configuration is done in the "ecl_include" script.

There are four constants defined at the top:
MAX_XP_GAIN - This is the highest amount of experience any player can receive at a given time. There is a flag to ignore this on a case by case basis, but it will be enforced by default.
MIN_XP_GAIN - This is the minimum amount of experience any player can receive at a given time. The 3e rules specify a player 7 or more levels above the CR rating of a monster get zero experience. Using this constant will apply a minimum to be rewarded after every kill.
MAX_ECL - This is as high an ECL as your mod will allow. It is 3 by default, if you institute races with a higher ECL you must set this value.
DEFAULT_XP_MOD - This number is multiplied into every experience gain. This system uses by the book distribution, which in a non-PnP scenario will level characters far too quickly. There is a flag to ignore this on a case by case basis. The default is 0.04.

Each race is configured in the ConfigureECL() function. One line needs to added for each new races, in one of two ways:

AddRaceByString("Race_Name",ECL);

This is for adding races through the SubRace field, it requires no hak and should fit right in with systems already designed around the SubRace field. There are already a few of these by default, as examples. It is not case sensitive, and will autocomplete from the players subrace. (ie If the player's subrace is 'Tief', it will assume them to be a Tiefling. If it finds more than one match in this fashion it will use the highest ECL matched; so it is best to make sure the player uses the full race name.)

or

AddRaceByInt(RACIAL_TYPE_*,ECL);

This method will add the actual race to the ECL list. It requires a hak for custom races, some examples are included but are commented out by default.



