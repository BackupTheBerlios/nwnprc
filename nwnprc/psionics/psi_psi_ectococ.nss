/*
   ----------------
   Ectoplasmic Cocoon
   
   prc_pow_ectococ
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 3
   Range: Medium
   Target: One Medium or smaller creature
   Duration: 1 Round/level
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 5
   
   You draw writhing strands of ectoplasm from the Astral Plane that wrap the subject up like a mummy. The subject can still
   breathe but is otherwise helpless. 
   
   Augment: For every 4 additional power points spent, this power can affect a creature one size larger and its DC increases by 1. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ECTOCOCOON, CLASS_TYPE_PSION);
}