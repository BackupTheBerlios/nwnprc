/*
   ----------------
   Crystal Shard
   
   prc_all_crysshrd
   ----------------

   21/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You propel a razor-sharp crystal shard at your target. You must succeed on a ranged touch attack
   to deal damage to the target. The shard deals 1d6 of piercing damage.
   
   Augment: For every additional power point spend, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CRYSTALSHARD, CLASS_TYPE_WILDER);
}