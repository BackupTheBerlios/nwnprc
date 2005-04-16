/*
   ----------------
   Hail of Crystals
   
   prc_pow_hailcrys
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 5
   Range: Medium
   Target: 20' Burst
   Duration: Instantaneous
   Saving Throw: Reflex half
   Power Resistance: No
   Power Point Cost: 9
   
   An ectoplasmic crystal emanates from your outstretched hand and expands into a two foot ball as it hurtles towards the chosen target.
   You must make a ranged touch attack to strike the target of the spell, who takes 5d4 bludgeoning damage. All those who are in the
   area of effect take 9d4 slashing with a reflex save for half. 
   
   Augment: For every additional power point spent, all those in the area of effect take another 1d4. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_HAILCRYSTALS, CLASS_TYPE_PSION);
}