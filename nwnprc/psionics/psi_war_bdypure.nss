/*
   ----------------
   Body Purification
   
   prc_pow_bdypure
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 5, PW 3
   
   When you manifest this power, you cleanse your body of all ability damage.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BODYPURIFICATION, CLASS_TYPE_PSYWAR);
}