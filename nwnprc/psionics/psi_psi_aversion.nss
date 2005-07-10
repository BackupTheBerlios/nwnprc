/*
   ----------------
   Aversion
   
   prc_all_daze
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 2
   Range: Close
   Target: One Creature
   Duration: 1 Hour/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You plant a powerful aversion in the mind of the subject. The target flees from you at every opportunity.
   
   Augment: For every 2 additional power points spent, this power's save DC increases by 1 and the duration by 1 hour.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_AVERSION, CLASS_TYPE_PSION);
}