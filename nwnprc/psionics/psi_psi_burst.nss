/*
   ----------------
   Burst
   
   prc_pow_burst
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad), Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, you gain a 50% increase to your speed. This is an instant power. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BURST, CLASS_TYPE_PSION);
}