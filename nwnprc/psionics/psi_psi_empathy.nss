/*
   ----------------
   Empathy
   
   prc_all_empathy
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You detect the surface emotions of creatures around you, giving you a +2 bonus to Bluff,
   Intimidate, and Persuade when interacting with them.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EMPATHY, CLASS_TYPE_PSION);
}
