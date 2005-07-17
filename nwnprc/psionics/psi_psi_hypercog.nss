/*
   ----------------
   Hypercognition
   
   prc_pow_hypercog
   ----------------

   17/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   When you manifest this power, you gain a bonus to lore equal to 20 + two times your caster level.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_HYPERCOGNITION, CLASS_TYPE_PSION);
}