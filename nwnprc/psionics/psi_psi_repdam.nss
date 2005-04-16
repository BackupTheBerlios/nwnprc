/*
   ----------------
   Psionic Repair Damage
   
   prc_pow_repdam
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 2
   Range: Touch
   Target: One Construct
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When laying your hands upon a construct, you reknit its structure to repair damage it has taken. The power repairs
   3d8 + 1 point per manifester level. 
   
   Augment: For every 2 additional power points spent, this power heals an extra 1d8.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_REPAIRDAMAGE, CLASS_TYPE_PSION);
}
