/*
   ----------------
   True Metabolism
   
   prc_pow_truemeta
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   You are difficult to kill while this power resists. You regenerate at the rate of 10 hitpoints a round.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TRUEMETABOLISM, CLASS_TYPE_PSION);
}