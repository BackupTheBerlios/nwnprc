/*
   ----------------
   Hammer
   
   prc_all_hammer
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   This power charges your touch with the force of a sledgehammer. A successful melee
   touch attack deals 1d8 bludgeoning damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d8. 
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_HAMMER, CLASS_TYPE_WILDER);
}