/*
   ----------------
   Greater Concealing Amorpha
   
   prc_all_gamorpha
   ----------------

   22/10/04 by Stratovarius

   Class: Psion (Shaper), Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   When you manifest this power, you weave a quasi-real membrane around yourself. 
   This distortion grants you 50% concealment.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_GREATAMORPHA, CLASS_TYPE_PSYWAR);
}