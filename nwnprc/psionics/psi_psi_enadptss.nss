/*
   ----------------
   Energy Adaption, Specified Sonic
   
   prc_all_enadptss
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you gain 10 resistance to the chosen energy type.
   This increases to 20 at manifester level 9, and 30 at manifester level 13.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYADAPTSONIC, CLASS_TYPE_PSION);
}