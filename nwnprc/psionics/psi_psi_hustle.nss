/*
   ----------------
   Hustle
   
   prc_pow_hustle
   ----------------

   26/3/05 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: Psion 3, Psychic Warrior 2
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion 5, PW 3
   
   When you manifest this power, you gain all the benefits of haste for one round. This is an instant power. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_HUSTLE, CLASS_TYPE_PSION);
}