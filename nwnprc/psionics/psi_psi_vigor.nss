/*
   ----------------
   Vigor
   
   prc_all_vigor
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You suffuse yourself with power, gaining 5 temporary hit points. 
   
   Augment: For every additional power point you spend, gain an additional 5 temporary HP.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_VIGOR, CLASS_TYPE_PSION);
}