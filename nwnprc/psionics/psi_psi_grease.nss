/*
   ----------------
   Ectoplasmic Sheen
   
   prc_all_grease
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Area: 10' square
   Duration: 1 Round/level
   Saving Throw: Reflex negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a pool of ectoplasm across the floor that inhibits motion and can cause people to slow down.
   This functions as the spell grease.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_GREASE, CLASS_TYPE_PSION);
}