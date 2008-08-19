//::///////////////////////////////////////////////
//:: Name      Spike Stones
//:: FileName  sp_spike_stn.nss
//:://////////////////////////////////////////////
/** @file Spike Stones
Transmutation [Earth]
Level: Drd 4, Earth 4
Components: V, S, DF
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Area: One 20-ft. square/level
Duration: 1 hour/level (D)
Saving Throw: Reflex partial
Spell Resistance: Yes

Rocky ground, stone floors, and similar
surfaces shape themselves into long, sharp
points that blend into the background.
Spike stones impede progress through an
area and deal damage. Any creature
moving on foot into or through the spell�s
area moves at half speed.
In addition, each creature moving
through the area takes 1d8 points of piercing
damage for each 5 feet of movement
through the spiked area.
Any creature that takes damage from
this spell must also succeed on a Reflex
save to avoid injuries to its feet and legs. A
failed save causes the creature�s speed to be
reduced to half normal for 24 hours or
until the injured creature receives a cure
spell (which also restores lost hit points).
Another character can remove the penalty
by taking 10 minutes to dress the injuries
and succeeding on a Heal check against
the spell�s save DC.
Spike stones is a magic trap that can�t be
disabled with the Disable Device skill.
Note: Magic traps such as spike stones are
hard to detect. A rogue (only) can use the
Search skill to find spike stones. The DC is
25 + spell level, or DC 29 for spike stones.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        