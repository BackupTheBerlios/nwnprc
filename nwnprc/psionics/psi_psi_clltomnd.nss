/*
   ----------------
   Call to Mind
   
   prc_all_clltomnd
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: Self
   Duration: 2 Rounds
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, you gain a bonus to lore equal to 4 + caster level.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CALLTOMIND, CLASS_TYPE_PSION);
}