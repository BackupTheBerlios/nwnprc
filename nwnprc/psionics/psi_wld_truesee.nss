/*
   ----------------
   True Seeing
   
   prc_pow_truesee
   ----------------

   23/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Personal
   Target: Caster
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: 9
   
   You magically enhance your sight, revealing everything as it truly is.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TRUESEEING, CLASS_TYPE_WILDER);
}