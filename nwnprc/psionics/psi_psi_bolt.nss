/*
   ----------------
   Bolt
   
   prc_all_bolt
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You create a stack of arrows, bolts, or sling bullets. Ammunition has a +1 enhancement bonus.
   The type of ammunition created depends on what weapon is equipped. Bows produce arrows, slings bullets,
   and all others create bolts.
   
   Augment: For every 3 additional power points spent, the enhancement increases by +1. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BOLT, CLASS_TYPE_PSION);
}