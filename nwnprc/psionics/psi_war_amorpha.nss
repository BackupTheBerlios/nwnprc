/*
   ----------------
   Concealing Amorpha
   
   prc_all_amorpha
   ----------------

   22/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Minute/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you weave a quasi-real membrane around yourself. 
   This distortion grants you 20% concealment.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CONCEALAMORPHA, CLASS_TYPE_PSYWAR);
}