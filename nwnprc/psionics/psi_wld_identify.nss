/*
   ----------------
   Identify
   
   prc_all_identify
   ----------------

   22/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you gain a bonus to lore equal to 10 + caster level.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_IDENTIFY, CLASS_TYPE_WILDER);
}