/*
   ----------------
   Insanity
   
   prc_pow_insane
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: Medium
   Target: One Humanoid
   Duration: Permanent
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 13
   
   Creatures affected by this power are permanently confused, as the spell.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1,
   and affects another hostile creature within 15 feet of the first.    
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_INSANITY, CLASS_TYPE_WILDER);
}