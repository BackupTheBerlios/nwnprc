/*
   ----------------
   Energy Push Cold
   
   prc_all_enpushc
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 3
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 2d6+2 cold damage. On a successful Fortitude safe, damage is cut in half. On
   a failed save, the target is knocked down.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6+1, 
   and the DC increases by 1. 
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYPUSH_COLD, CLASS_TYPE_PSION);
}