/*
   ----------------
   Power Resistance
   
   prc_pow_powres
   ----------------

   23/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Touch
   Target: Creature Touched
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   Target creature gains power resistance of 12 + your manifester level.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_POWERRESISTANCE, CLASS_TYPE_PSION);
}