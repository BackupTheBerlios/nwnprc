/*
   ----------------
   Entangling Ectoplasm
   
   prc_all_entangle
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Medium or smaller Creature
   Duration: 5 Rounds
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You draw forth a glob of ectoplasmic goo from the Astral Plane and throw it at a creature
   as a ranged touch attack. On a succesful hit, the subject is covered in goo and becomes entangled.
   
   Augment: For every 2 additional power points spent, this power can affect a target
   that is one size larger.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENTANGLE, CLASS_TYPE_PSION);
}