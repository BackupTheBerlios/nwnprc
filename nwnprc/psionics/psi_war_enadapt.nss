/*
   ----------------
   Energy Adaption
   
   prc_pow_enadapt
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   When you manifest this power, you gain 10 resistance to acid, cold, electricity, fire and sonic damage.
   This increases to 20 at manifester level 9, and 30 at manifester level 13.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYADAPTION, CLASS_TYPE_PSYWAR);
}