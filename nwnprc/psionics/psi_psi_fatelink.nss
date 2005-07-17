/*
   ----------------
   Fate Link
   
   prc_pow_fatelink
   ----------------

   15/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 4
   Range: Close
   Target: Two Creatures
   Duration: 10 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   You temporarily link the fates of any two creatures, if both fail their saving throws. If either linked creature experiences 
   pain, both feel it. When one loses hit points, the other loses the same amount. If one creature is subjected to an effect to 
   which it is immune (such as a type of energy damage), the linked creature is not subjected to it either. If one dies, the 
   other must immediately succeed on a Fortitude save against this power’s save DC or gain two negative levels.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_FATELINK, CLASS_TYPE_PSION);
}