/*
   ----------------
   Dominate
   
   prc_psi_dominate
   ----------------

   16/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 4
   Range: Medium
   Target: One Humanoid
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   The target temporarily becomes a faithful and loyal servant of the caster.
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon, Outsider
   and Elementals. If you augment this beyond 3, it affects 1 additional target for each additional augmentation. It costs 2 power 
   points to augment once, 6 to augment 3 times, and 2 additional points for each augmentation beyond 3. For every 2 power points spent
   this way, the DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DOMINATE, CLASS_TYPE_PSION);
}