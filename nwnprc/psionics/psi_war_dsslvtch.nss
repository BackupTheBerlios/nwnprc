/*
   ----------------
   Dissolving Touch
   
   prc_all_dsslvtch
   ----------------

   27/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 2
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your touch is corrosive, dealing 4d6 points of acid damage on a successful melee touch attack.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISSOLVINGTOUCH, CLASS_TYPE_PSYWAR);
}