/*
   ----------------
   Telempathic Projection
   
   prc_all_telemp
   ----------------

   12/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Medium
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You grant a +4 Perform and Persuade bonus to the affected creature.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TELEMPATHICPRO, CLASS_TYPE_WILDER);
}
