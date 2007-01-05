
=================
Warlock Bug Fixes
=================
Simple scripts and compiled scripts to throw in the override to make invocations act as per PnP.
I purposely released this pack in this way so that players can merge this with other mods.
You can choose to copy whatever spell you want fixed into your override, and only those your want changed.

I am hoping to work with Pixxee from the NwN2 forums to get all the changes we have individually made compiled together.
I will also check Even and see if I can make this fully compatible with the 3.5e PnP hak.
It will definitely be integrated into the PRC once that makes its way into NwN2.

Unchanged:
==========
Evard's Tentacles, Animate Dead.
Eldritch Blast - weapon-like spell feats, sneak attack.  (Coming with PRC pack).
Hideous Blow - (waiting for PRC pack).

Current Minor Changes:
======================
Devil's Sight - Now has ultravision so it can see through magical darkness.  (formerly darkvision only, now both)
Retributive Invisiblity - Duration is 1 round/casterlvl. (formerly 3 rounds)
Wall of Perilous Flame - 2d6+caster level damage. (formerly 2d6 + charisma modifer)
Eldritch Blast - can crit. 20/x2 (could not crit)

Current Major Changes:
======================
Chilling Tentacles
------------------
OEI version
1d4 tentacles perform attack roll of 5+d20 vs. creature AC. (25 max >= nAC ... cannot hit over 26 AC)
Each tentacle can do 1d6+4  damage (despite saying 2d6 in the description) of +2 magical enchancement damage type.
If you hit, fort save vs. being paralyzed for 1 round.
Deald 2d6 cold damage to those within the AoE.

Can be spammed by a lock 20 times to deal 40d6 cold damage per round.
and 20d4 attempts to deal 1d6+4 damage, and paralyze... supposing you actually hit with anything.

PnP Version
Grapple check. *
d20+ Caster Level+ 4(STR mod)+ 4(size mod) vs. d20+ BaB+ STR mod+ Size Mod.
Can only grapple things up to two size categories larger.  **
Another grapple check is made to deal 1d6+4 damage.  PnP does not specify it as a magical weapon of any sort.
Players can escape a grapply by making an opposed grapple check,
or by spending a standard action to make an Escape Artist check. ***
All movement within the AoE is reduced to 50%, even those not being grappled.
Deald 2d6 cold damage to those within the AoE.

'Fixed' version (acts as PnP except as noted)
* Being in a grapple is close to being paralyzed, minus the Coupe De Grace.
  My spell uses CutSceneImmobilize, because a friend told me it did exactly that. paralyze minus the CDG.
** NwN1/2 lack any sizes that would be 2 larger than LARGE (tentacle size), hence this is ignored entirely.
*** They make a check every round to escape, escape artist does not exist and is not supported.

Additionally, I added some configuration options in the script to change the 'stacking' behavior.
PnP does not clearly state yes/no to wether the stacking of ridiculous damage is legal, I think it's not.
By default, my script only allows 1 instance of the spell PER CASTER to grapple/damage a creature.
This stops the 40d6 cheese spam behavior, but allows 2 different warlocks to stack the spells together.
This behavior can be changed allow no stacking at all (even from other casters),
stacking of 1 per caster, or stacking by all of instances of the spell OEI defualt.

-------------
The Dead Walk
-------------
OEI version
Summons a level 1 skeleton, level 2 zombie, or level 3 skeleton warrior based on character level.
Summon lasts 1 hr / caster level.  (Or until its killed in 2 hits)

PnP version
Raise up to 2*HD undead by touching their corpses.
Raised dead last 1 min / caster level, unless made permanent by using 25 gp per HD of undead in Black Onyx.
A caster can control up to 4*HD in undead HD.
They can released a selected undead to raise a new one.

'Fixed' version
Currently summons 1 undead equal to your own level, permanently.
Note: this will be changed as soon as I work around the issues noted below.

NOTE:
There are a ton of flags in the script to radically change the behavior of this spell!

Summon Count - max number of summons 4*HD or a set number. (BUGGED, see below)
Summon Type - random or level based.
Min/Max level - can set these to (HD or CL)/X.  Max can also be set to a value.  Spell selects level randomly between min/max.
Duration - 1 min/lvl, permanent, or 1 min/lvl on first cast, permanent if you target summon and cast it again. (BUGGED, see below)
Gold Cost - none, or 25gp/HD on a permanent summon.

The original idea was to have temporary, semi-random leveled (between HD/2 and HD) summons that you could make permanent by spending gold.
Unfortunately, I ran into the following issues and have yet to sort it out.
In the interest of getting something better than the OEI spell out the door, I chose to release it as it for the moment.

-------------------
KNOWN BUGS / ISSUES
-------------------
All of these pertain to The Dead Walk, I listed all the issues I am having in making it work properly.
Perhaps anyone reading this can offer some ideas on the vault, NwN2 forums, or PRC IRC chat.

EffectSummonCreature(string, int, float) - Can only summon 1 creature, destroys any other summon.
	Work Around NwN1:
		SetIsDestroyable FALSE, DelayCommand SetIsDestroyable TRUE.
	Work Around NwN2:
		Above method kicks preveious summon from party. (Stop following and responding to voice commands.)
		Work around:
			Possibly find function to add them back to party?
			Use CreateObject/CutSceneDominate instead. (Leads to next 2 issues)

GetAssociate(int, object, int) - used in while loop to determine controlled undead number / HD
				 seems to be broken with ASSOCIATE_TYPE_DOMINATED returning the first dominated object regardless of nth parameter.
	Work Around NwN2:
		Use... Henchmen instead? 
		Find a way to make EffectSummonCreature work?
		Determine if GetAssociate is bugged for all ASSOCIATE_TYPE_* and see if OEI will fix it.


Duration 1 min/lvl - 	is 'real time' minutes, not in game world minutes.
			Because of the CreateObject/CutSceneDominate work around, summons persist through resting.

Division By Zero - Apparently NwN2 just dumps a script with a division by zero WITHOUT ANY OUTPUT...
		   took me a while to narrow down the line of code causing the problem.
		   Would have taken less than a minute had NwN2 had the error output like NwN1 had.

Special Thanks
==============
Pixxee - Posting on the NwN2 forums about all the lock bugs, making me interested in fixing the class.
Altaem - for helping me get the undead summons scaling up in level.
PRC - all the members that have been helping me on IRC dealing with multiple summon issues and the like.

Revision History
================
v0.2 - Chilling Tentacles (stacking removed, switches added), The Dead Walk (1 undead of character's HD, many switches to change behavior).
v0.1 - Inital Release
v0.1 - Devil's Sight (ultravision), Retributive Invisiblity (duration), Wall of Perilous Flame (damage) fixed.
v0.1 - Eldritch Blast (crit), Chilling Tentacles (PnP-ified).









