/*
   ----------------
   Ectoplasmic Cocoon, Mass
   
   prc_pow_ectococm
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 7
   Range: Medium
   Target: 20' Burst
   Duration: 1 Hour/level
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 13
   
   You draw writhing strands of ectoplasm from the Astral Plane that wrap the subjects up like a mummy. The subjects can still
   breathe but are otherwise helpless. 
   
   Augment: For every 2 additional power points spent, this power's radius increases by 5 feet.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ECTOCOCOONMASS, CLASS_TYPE_PSION);
}