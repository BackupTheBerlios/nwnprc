/*
   ----------------
   My Light
   
   prc_all_mylight
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, your body begins to glow with bright white light,
   allowing you to see clearly even in the night.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MYLIGHT, CLASS_TYPE_WILDER);
}