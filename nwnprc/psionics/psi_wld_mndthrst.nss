/*
   ----------------
   Mind Thrust
   
   prc_all_mndthrst
   ----------------

   21/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You instantly deliver a massive assault on the thought pathways of any 
   one creature, dealing 1d10 points of damage to it.
   
   Augment: For every additional power point spend, this power's damage increases by 1d10. 
   For each extra 2d10 points of damage, this power's save DC increases by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MINDTHRUST, CLASS_TYPE_WILDER);
}