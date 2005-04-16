/*
   ----------------
   Dimensional Anchor
   
   prc_pow_dimanch
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 4
   Range: Medium
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 7
   
   A ray springs from your outstretched hand. You must make a ranged touch attack to hit the target. Any creature hit by the ray
   is covered by a shimmering field that completely blocks extradimensional movement. Forms of movement barred by dimensional anchor
   include dimension door, ethereal jaunt, astral travel, gate, shadow walk, teleport, and similar spells. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DIMENSIONALANCHOR, CLASS_TYPE_PSION);
}