/*
   ----------------
   Body Adjustment
   
   prc_all_bdyadjst
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 5, PW 3
   
   When you manifest this power, you heal 1d12 hitpoints.
   
   Augment: For every 2 additional power points spent,you heal 1d12 hitpoints.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BODYADJUST, CLASS_TYPE_PSYWAR);
}