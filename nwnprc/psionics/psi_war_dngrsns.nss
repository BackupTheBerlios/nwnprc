/*
   ----------------
   Danger Sense
   
   prc_all_dngrsns
   ----------------

   12/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You can sense the prescence of danger before your senses would normally allow it. Your intuitive sense
   alerts you to danger from traps, granting a +4 bonus to reflex saves and armour class vs traps.
   
   Augment: For 3 additional power points spent, gain the +2 to each bonus.
   
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DANGERSENSE, CLASS_TYPE_PSYWAR);
}