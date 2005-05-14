/*
   ----------------
   Brain Lock
   
   prc_psi_brnlock
   ----------------

   21/10/04 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 2
   Range: Medium
   Target: One Humanoid
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   The subject's higher mind is locked away. He stands dazed, 
   unable to take any mental decisions at all.
   
   Augment: If you spend 2 additional power points, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you spend 4 additional power points, this power also affects Aberration, Dragon, 
   Outsiders, and Elementals. Augmenting this power beyond level 2 will waste power points. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BRAINLOCK, CLASS_TYPE_PSION);
}