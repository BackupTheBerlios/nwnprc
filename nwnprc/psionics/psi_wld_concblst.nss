/*
   ----------------
   Concussion Blast
   
   prc_all_concblst
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Creature + Augmentation
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 3
   
   A subject you select is pummeled with telekinetic force for 1d6 of bludgeoning damage.
   
   Augment: For every 4 additional power points spent, this power's damage increases by 1d6,
   and affects another hostile creature within 15 feet of the first. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CONCBLAST, CLASS_TYPE_WILDER);
}