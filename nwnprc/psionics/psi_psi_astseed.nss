/*
   ----------------
   Astral Seed
   
   prc_pow_astseed
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 8
   Range: Close
   Target: Ground
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   This power weaves strands of ectoplasm into a crystal containing the seed of your living mind. You may have only one seed in 
   existence at any one time. Until such time as you perish, the astral seed is totally inert. Upon dying, you are transported
   to the location of your astral seed, where you will spend a day regrowing a body. Respawning in this manner will cost a level. 
   If your astral seed is destroyed, the power will fail. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ASTRALSEED, CLASS_TYPE_PSION);
}